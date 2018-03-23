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
  
static llvm::cl::opt<bool>
HideDiagnostics("hidediagnostics",
                 llvm::cl::init(false),
                 llvm::cl::desc("Don't print diagnostic informations from "
                                "Swift compiler"),
                 llvm::cl::cat(ObfuscatorSymbolExtractor));
  
static llvm::cl::opt<bool>
Verbose("verbose",
        llvm::cl::init(false),
        llvm::cl::desc("Print debug info."),
        llvm::cl::cat(ObfuscatorSymbolExtractor));

}

// This function isn't referenced outside its translation unit, but it
// can't use the "static" keyword because its address is used for
// getMainExecutable (since some platforms don't support taking the
// address of main, and some platforms can't implement getMainExecutable
// without being given the address of a function in the main executable).
void anchorForGetMainExecutable() {}

int main(int argc, char *argv[]) {
  // Required by LLVM to properly parse command-line options
  INITIALIZE_LLVM(argc, argv);
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorSymbolExtractor);

  // Defines the handler for flow-aborting errors, which lets you choose
  // what code to return, whether to log and wheter to do any cleanup
  // http://llvm.org/docs/ProgrammersManual.html#using-exitonerror-to-simplify-tool-code
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );

  llvm::outs() << "Swift obfuscator symbol extractor tool" << '\n';

  // Must be called before checking the options for values
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-symbol-extractor");
  
  if (options::FilesJsonPath.empty()) {
    llvm::errs() << "cannot find Files Extractor json file" << '\n';
    return 1;
  }
  std::string PathToJson = options::FilesJsonPath;

  // Required for the compiler to find the path to this tool, and therefore
  // exists only in the tools that are performing compilation (semantic analysis)
  void *MainExecutablePointer =
    reinterpret_cast<void *>(&anchorForGetMainExecutable);
  std::string MainExecutablePath =
    llvm::sys::fs::getMainExecutable(argv[0], MainExecutablePointer);

  auto FilesJsonOrError = parseJson<FilesJson>(PathToJson);
  if (auto Error = FilesJsonOrError.takeError()) {
      ExitOnError(std::move(Error));
  }
  
  llvm::raw_ostream *DiagnosticStream;
  // Decides if and where the logs from the compiler will be printed.
  // If llvm::raw_null_ostream is used, they're just discarded.
  if (options::HideDiagnostics) {
    DiagnosticStream = new llvm::raw_null_ostream();
  } else {
    DiagnosticStream = &llvm::outs();
  }

  // This is the place that the actual symbol extraction is performed.
  // The logic for symbol extraction is in the swiftObfuscation library.
  auto SymbolsOrError = extractSymbols(FilesJsonOrError.get(),
                                       MainExecutablePath,
                                       *DiagnosticStream);
  if (auto Error = SymbolsOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  if (options::SymbolJsonPath.empty()) {
    llvm::errs() << "there is no path to write extracted symbols to" << '\n';
    return 1;
  }
  
  std::string PathToOutput = options::SymbolJsonPath;

  llvm::raw_ostream *DebugStream;
  if (options::Verbose) {
    DebugStream = &llvm::outs();
  } else {
    DebugStream = new llvm::raw_null_ostream();
  }
  
  // Writes the extracted symbols to Symbols.json file. Saves at given path.
  FileFactory<llvm::raw_fd_ostream> Factory;
  auto WriteErrorCode = writeToPath(SymbolsOrError.get(),
                                    PathToOutput,
                                    Factory,
                                    *DebugStream);
  ExitOnError(std::move(WriteErrorCode));

  return 0;
}

