#include "swift/Obfuscation/Renaming.h"
#include "swift/Obfuscation/FileIO.h"

#include "swift/Basic/LLVMInitialize.h"
#include "llvm/Support/CommandLine.h"

using namespace swift;
using namespace swift::obfuscation;

namespace options {
  
static llvm::cl::OptionCategory ObfuscatorRenamer("Obfuscator Renamer");
  
static llvm::cl::opt<std::string>
FilesJsonPath("filesjson",
              llvm::cl::desc("Name of the file containing File Extractor data"),
              llvm::cl::cat(ObfuscatorRenamer));

static llvm::cl::opt<std::string>
RenamesJsonPath("renamesjson",
                llvm::cl::desc("Name of the output file to write extracted "
                               "symbols with proposed renamings"),
                llvm::cl::cat(ObfuscatorRenamer));

static llvm::cl::opt<std::string>
ObfuscatedProjectPath("obfuscatedproject",
                      llvm::cl::desc("Path to the directory for obfuscated "
                                     "project"),
                      llvm::cl::cat(ObfuscatorRenamer));
  
}

void printObfuscatedFiles(const FilesList &Files) {
  llvm::outs() << "obfuscated files:" << '\n';
  for (const auto &File : Files) {
    llvm::outs() << File.second << '\n';
  }
}

// This function isn't referenced outside its translation unit, but it
// can't use the "static" keyword because its address is used for
// getMainExecutable (since some platforms don't support taking the
// address of main, and some platforms can't implement getMainExecutable
// without being given the address of a function in the main executable).
void anchorForGetMainExecutable() {}

int main(int argc, char *argv[]) {
  INITIALIZE_LLVM(argc, argv);
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorRenamer);
  
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );
  llvm::outs() << "Swift obfuscator renamer tool" << '\n';
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-renamer");
  
  if (options::FilesJsonPath.empty()) {
    llvm::errs() << "cannot find Files json file" << '\n';
    return 1;
  }
  if (options::RenamesJsonPath.empty()) {
    llvm::errs() << "cannot find Renames json file" << '\n';
    return 1;
  }
  if (options::ObfuscatedProjectPath.empty()) {
    llvm::errs() << "cannot find path to the obfuscated project" << '\n';
    return 1;
  }
  
  auto FilesJsonOrError = parseJson<FilesJson>(options::FilesJsonPath);
  if (auto Error = FilesJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  auto RenamesJsonOrError = parseJson<RenamesJson>(options::RenamesJsonPath);
  if (auto Error = RenamesJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  
  void *MainExecutablePointer =
    reinterpret_cast<void *>(&anchorForGetMainExecutable);
  std::string MainExecutablePath =
    llvm::sys::fs::getMainExecutable(argv[0], MainExecutablePointer);
  
  auto FilesOrError = performRenaming(MainExecutablePath,
                                      FilesJsonOrError.get(),
                                      RenamesJsonOrError.get(),
                                      options::ObfuscatedProjectPath);
  if (auto Error = FilesOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  
  printObfuscatedFiles(FilesOrError.get());
  return 0;
}

