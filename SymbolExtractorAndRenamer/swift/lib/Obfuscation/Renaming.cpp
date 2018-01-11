#include "swift/Obfuscation/Renaming.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/SymbolProvider.h"
#include "swift/Obfuscation/Utils.h"

#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "swift/IDE/Utils.h"

namespace swift {
namespace obfuscation {

typedef llvm::SmallString<256> SmallPath;
  
llvm::Expected<SmallPath>
computeObfuscatedPath(const StringRef Filename,
                      const StringRef OriginalProjectPath,
                      const StringRef ObfuscatedProjectPath) {
  SmallPath Path(Filename);
  llvm::sys::path::replace_path_prefix(Path, OriginalProjectPath, ObfuscatedProjectPath);
  return Path;
}

llvm::Error copyProject(const StringRef OriginalPath,
                        const StringRef ObfuscatedPath) {
  
  std::error_code ErrorCode;
  for (llvm::sys::fs::recursive_directory_iterator Iterator(OriginalPath, ErrorCode), End;
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
      return stringError("Cannot create directory in " + Path.str().str(), Error);
    }
    
    if (auto Error = llvm::sys::fs::copy_file(Iterator->path(), Path)) {
      return stringError("Cannot copy file from " + Iterator->path() + " to " + Path.str().str(), Error);
    }
  }
  
  if (ErrorCode) {
    return stringError("Error while traversing the project directory " + OriginalPath.str(), ErrorCode);
  }
  
  return llvm::Error::success();
}

bool performActualRenaming(swift::SourceFile* Current,
                           const FilesJson &FilesJson,
                           const RenamesJson &RenamesJson,
                           swift::SourceManager &SourceManager,
                           swift::ide::SourceEditOutputConsumer& Editor) {
  
  bool performedRenaming = false;
  
  auto SymbolsWithRanges = findSymbolsWithRanges(*Current);
  
  //TODO: would be way better to have a map here instead of iterating through symbols
  for (const auto &SymbolWithRange : SymbolsWithRanges) {
    for (const auto &Symbol : RenamesJson.Symbols) {
      
      if (SymbolWithRange.Symbol.Identifier == Symbol.Identifier
          && SymbolWithRange.Symbol.Name == Symbol.OriginalName
          && std::string::npos != SymbolWithRange.Symbol.Identifier.find(FilesJson.Module.Name)) {
        
        Editor.ide::SourceEditConsumer::accept(SourceManager,
                                               SymbolWithRange.Range,
                                               StringRef(Symbol.ObfuscatedName));
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
                const RenamesJson &RenamesJson,
                std::string ObfuscatedProjectPath) {
  
  CompilerInstance CI;
  if (auto Error = setupCompilerInstance(CI, FilesJson, MainExecutablePath)) {
    return std::move(Error);
  }
  
  if (auto Error = copyProject(FilesJson.Project.RootPath, ObfuscatedProjectPath)) {
    return std::move(Error);
  }
  
  FilesList Files;
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
      std::error_code Error;
      llvm::raw_fd_ostream DescriptorStream(Path, Error, llvm::sys::fs::F_None);
      if (DescriptorStream.has_error() || Error) {
        return stringError("Cannot open output file: " + Path.str(), Error);
      }
      
      auto BufferId = Current->getBufferID().getValue();
      swift::ide::SourceEditOutputConsumer Editor(SourceManager,
                                                  BufferId,
                                                  DescriptorStream);
      if (performActualRenaming(Current, FilesJson, RenamesJson, SourceManager, Editor)) {
        auto Filename = llvm::sys::path::filename(Path).str();
        Files.push_back(std::pair<std::string, std::string>(Filename, Path));
      }
    }
  }
  
  return Files;
}

} //namespace obfuscation
} //namespace swift
