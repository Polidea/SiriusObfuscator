#include "swift/Obfuscation/SymbolExtracting.h"
#include "swift/Obfuscation/FileIO.h"

#include "swift/Basic/LLVMInitialize.h"
#include "llvm/Support/CommandLine.h"

using namespace swift;
using namespace swift::obfuscation;

namespace options {
  
static llvm::cl::OptionCategory
ObfuscatorSymbolExtractor("Obfuscator Symbol Extractor");
  
static llvm::cl::opt<std::string>
FilesJsonPath("filesjson",
              llvm::cl::desc("Name of the file containing File Extractor data"),
              llvm::cl::cat(ObfuscatorSymbolExtractor));

static llvm::cl::opt<std::string>
SymbolJsonPath("symbolsjson",
               llvm::cl::desc("Name of the file to write extracted Symbols"),
               llvm::cl::cat(ObfuscatorSymbolExtractor));
  
}

void printSymbols(const std::vector<Symbol> &Symbols) {
  for (const auto &Symbol : Symbols) {
    llvm::outs()
      << "identifier: " << Symbol.Identifier << '\n'
      << "name: " << Symbol.Name << '\n'
      << "module: " << Symbol.Module << '\n';
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
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorSymbolExtractor);
  
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );
  llvm::outs() << "Swift obfuscator symbol extractor tool" << '\n';
  
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-symbol-extractor");
  
  if (options::FilesJsonPath.empty()) {
    llvm::errs() << "cannot find Files Extractor json file" << '\n';
    return 1;
  }

  std::string PathToJson = options::FilesJsonPath;
  void *MainExecutablePointer =
    reinterpret_cast<void *>(&anchorForGetMainExecutable);
  std::string MainExecutablePath =
    llvm::sys::fs::getMainExecutable(argv[0], MainExecutablePointer);

    auto FilesJsonOrError = parseJson<FilesJson>(PathToJson);

    if (auto Error = FilesJsonOrError.takeError()) {
        ExitOnError(std::move(Error));
    }
  
  auto SymbolsOrError = extractSymbols(FilesJsonOrError.get(),
                                       MainExecutablePath);
  if (auto Error = SymbolsOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  printSymbols(SymbolsOrError.get().Symbols);
  if (options::SymbolJsonPath.empty()) {
    llvm::errs() << "there is no path to write extracted symbols to" << '\n';
    return 1;
  }

  std::string PathToOutput = options::SymbolJsonPath;
  FileFactory<llvm::raw_fd_ostream> Factory = FileFactory<llvm::raw_fd_ostream>();

  auto WriteErrorCode = writeToPath(SymbolsOrError.get(),
                                    PathToOutput,
                                    Factory,
                                    llvm::outs());
  ExitOnError(std::move(WriteErrorCode));
  return 0;
}

