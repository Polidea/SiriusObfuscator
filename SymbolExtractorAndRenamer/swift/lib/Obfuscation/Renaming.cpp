#include "swift/Obfuscation/Renaming.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/ConfigurationExcluder.h"
#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/LayoutRenamer.h"
#include "swift/Obfuscation/ExtensionExcluder.h"

#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "swift/IDE/Utils.h"

#include <memory>
#include <unordered_map>

#include <sys/stat.h>

namespace swift {
namespace obfuscation {

using SmallPath = llvm::SmallString<256>;
  
llvm::Expected<SmallPath>
computeObfuscatedPath(const StringRef Filename,
                      const StringRef OriginalProjectPath,
                      const StringRef ObfuscatedProjectPath) {
  SmallPath Path(Filename);
  llvm::sys::path::replace_path_prefix(Path,
                                       OriginalProjectPath,
                                       ObfuscatedProjectPath);
  return Path;
}

llvm::Error copyProject(const StringRef OriginalPath,
                        const StringRef ObfuscatedPath) {
  
  std::error_code ErrorCode;
  using RecursiveIterator = llvm::sys::fs::recursive_directory_iterator;
  for (RecursiveIterator Iterator(OriginalPath, ErrorCode), End;
       Iterator != End && !ErrorCode;
       Iterator.increment(ErrorCode)) {
    if (llvm::sys::fs::is_directory(Iterator->path())) {
      continue;
    }
    
    auto PathOrError = computeObfuscatedPath(StringRef(Iterator->path()),
                                             OriginalPath,
                                             ObfuscatedPath);
    if (auto Error = PathOrError.takeError()) {
      return Error;
    }
    
    auto Path = PathOrError.get();
    auto DirectoryPath = Path;
    llvm::sys::path::remove_filename(DirectoryPath);
    if (auto Error = llvm::sys::fs::create_directories(DirectoryPath)) {
      auto Message = "Cannot create directory in " + Path.str().str();
      return stringError(Message, Error);
    }

    llvm::sys::fs::remove(Path);
    if (auto Error = llvm::sys::fs::copy_file(Iterator->path(), Path)) {
      auto Message = "Cannot copy file from " + Iterator->path() + " to " +
        Path.str().str();
      return stringError(Message, Error);
    }

    llvm::sys::fs::file_status Status;
    auto Error = status(Iterator->path(), Status);
    if (!Error) {
      mode_t Modes = 0;
      auto Permissions = Status.permissions();
      if (Permissions & llvm::sys::fs::perms::owner_read) {
        Modes |= S_IRUSR;
      }
      if (Permissions & llvm::sys::fs::perms::owner_write) {
        Modes |= S_IWUSR;
      }
      if (Permissions & llvm::sys::fs::perms::owner_exe) {
        Modes |= S_IXUSR;
      }
      if (Permissions & llvm::sys::fs::perms::group_read) {
        Modes |= S_IRGRP;
      }
      if (Permissions & llvm::sys::fs::perms::group_write) {
        Modes |= S_IWGRP;
      }
      if (Permissions & llvm::sys::fs::perms::group_exe) {
        Modes |= S_IXGRP;
      }
      if (Permissions & llvm::sys::fs::perms::others_read) {
        Modes |= S_IROTH;
      }
      if (Permissions & llvm::sys::fs::perms::others_write) {
        Modes |= S_IWOTH;
      }
      if (Permissions & llvm::sys::fs::perms::others_exe) {
        Modes |= S_IXOTH;
      }
      chmod(Path.c_str(), Modes);
    }
  }
  
  if (ErrorCode) {
    auto Message = "Error while traversing the project directory " +
      OriginalPath.str();
    return stringError(Message, ErrorCode);
  }
  
  return llvm::Error::success();
}

static bool shouldRename(const struct SymbolRenaming &SymbolRenaming,
                         const struct Symbol &Symbol,
                         const std::string &ModuleName) {
  return Symbol.Identifier == SymbolRenaming.Identifier
      && Symbol.Name == SymbolRenaming.OriginalName
      && Symbol.Module == ModuleName;
}
  
llvm::Expected<bool> performActualRenaming(SourceFile &Current,
                                           const std::string &ModuleName,
                                           const RenamesJson &RenamesJson,
                                           SourceManager &SourceManager,
                                           unsigned int BufferId,
                                           StringRef Path,
                                           std::vector<SymbolRenaming>
                                                          &RenamedSymbols,
                                           std::set<Excluder*> &Excluders) {
  bool performedRenaming = false;
  auto IndexedSymbolsWithRanges = walkAndCollectSymbols(Current, Excluders);
  
  using EditConsumer = swift::ide::SourceEditOutputConsumer;
  
  std::unique_ptr<llvm::raw_fd_ostream> DescriptorStream(nullptr);
  std::unique_ptr<EditConsumer> Editor(nullptr);
  
  //TODO: would be way better to have a map instead of iterating through symbols
  for (const auto &IndexedSymbolWithRange : IndexedSymbolsWithRanges) {
    for (const auto &Symbol : RenamesJson.Symbols) {
      auto SymbolWithRange = IndexedSymbolWithRange.SymbolWithRange;

      if (shouldRename(Symbol, SymbolWithRange.Symbol, ModuleName)) {
        if (Editor == nullptr) {
          std::error_code Error;
          DescriptorStream =
            llvm::make_unique<llvm::raw_fd_ostream>(Path,
                                                    Error,
                                                    llvm::sys::fs::F_None);
          if (DescriptorStream->has_error() || Error) {
            return stringError("Cannot open output file: " + Path.str(), Error);
          }
          Editor = llvm::make_unique<EditConsumer>(SourceManager,
                                                   BufferId,
                                                   *DescriptorStream);
        }
        auto ObfuscatedName = StringRef(Symbol.ObfuscatedName);
        Editor->ide::SourceEditConsumer::accept(SourceManager,
                                                SymbolWithRange.Range,
                                                ObfuscatedName);
        RenamedSymbols.push_back(Symbol);
        performedRenaming = true;
        break;
      }
    }
  }
  return performedRenaming;
}
  
llvm::Expected<FilesList>
performRenaming(std::string MainExecutablePath,
                const FilesJson &FilesJson,
                ObfuscationConfiguration &&ObfuscationConfiguration,
                const RenamesJson &RenamesJson,
                std::string ObfuscatedProjectPath,
                llvm::raw_ostream &DiagnosticStream) {
  
  CompilerInstance CI;
  if (auto Error = setupCompilerInstance(CI,
                                         FilesJson,
                                         MainExecutablePath,
                                         DiagnosticStream)) {
    return std::move(Error);
  }
  
  if (auto Error = copyProject(FilesJson.Project.RootPath,
                               ObfuscatedProjectPath)) {
    return std::move(Error);
  }
  
  FilesList Files;
  std::vector<SymbolRenaming> RenamedSymbols;

  ExtensionExcluder ExtensionExcluder;
  NSManagedExcluder NSManagedExcluder;
  ConfigurationExcluder ConfigurationExcluder(std::move(ObfuscationConfiguration));
  
  std::set<Excluder*> Excluders = { &ExtensionExcluder, &NSManagedExcluder, &ConfigurationExcluder };
  
  for (auto* Unit : CI.getMainModule()->getFiles()) {
    if (auto* Current = dyn_cast<SourceFile>(Unit)) {

      auto PathOrError = computeObfuscatedPath(Current->getFilename(),
                                               FilesJson.Project.RootPath,
                                               ObfuscatedProjectPath);
      if (auto Error = PathOrError.takeError()) {
        return std::move(Error);
      }
      
      auto Path = PathOrError.get().str();
      auto &SourceManager = Current->getASTContext().SourceMgr;
      auto BufferId = Current->getBufferID().getValue();
      
      if (performActualRenaming(*Current,
                                FilesJson.Module.Name,
                                RenamesJson,
                                SourceManager,
                                BufferId,
                                Path,
                                RenamedSymbols,
                                Excluders)) {
        auto Filename = llvm::sys::path::filename(Path).str();
        Files.push_back(std::pair<std::string, std::string>(Filename, Path));
      }
    }
  }
  
  // Rename layout files
  for (const auto &LayoutFile: FilesJson.LayoutFiles) {
    
    auto PathOrError = computeObfuscatedPath(LayoutFile,
                                             FilesJson.Project.RootPath,
                                             ObfuscatedProjectPath);
    
    if (auto Error = PathOrError.takeError()) {
      return std::move(Error);
    }
    
    auto Path = PathOrError.get().str().str();
    
    LayoutRenamer LayoutRenamer(LayoutFile);

    // Extract nodes
    auto NodesToRenameOrError
                     = LayoutRenamer.extractLayoutRenamingNodes(RenamedSymbols);
    
    if (auto Error = NodesToRenameOrError.takeError()) {
      return std::move(Error);
    }
    
    auto NodesToRename = NodesToRenameOrError.get();
    
    // Perform renaming on extracted nodes
    if (!NodesToRename.empty()) {
      LayoutRenamer.performRenaming(NodesToRename, Path);

      Files.push_back(std::pair<std::string, std::string>(LayoutFile, Path));
    }
  }
  
  return Files;
}

} //namespace obfuscation
} //namespace swift
