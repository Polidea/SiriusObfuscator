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

static llvm::cl::opt<bool>
HideDiagnostics("hidediagnostics",
                llvm::cl::init(false),
                llvm::cl::desc("Don't print diagnostic informations from "
                               "Swift compiler"),
                llvm::cl::cat(ObfuscatorRenamer));
  
static llvm::cl::opt<bool>
Verbose("verbose",
        llvm::cl::init(false),
        llvm::cl::desc("Print debug info."),
        llvm::cl::cat(ObfuscatorRenamer));
  
static llvm::cl::opt<bool>
InPlace("inplace",
        llvm::cl::init(false),
        llvm::cl::desc("Obfuscate project in place "
                       "(without making a copy)."),
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
  // Required by LLVM to properly parse command-line options
  INITIALIZE_LLVM(argc, argv);
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorRenamer);

  // Defines the handler for flow-aborting errors, which lets you choose
  // what code to return, whether to log and wheter to do any cleanup
  // http://llvm.org/docs/ProgrammersManual.html#using-exitonerror-to-simplify-tool-code
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );

  llvm::outs() << "Swift obfuscator renamer tool" << '\n';

  // Must be called before checking the options for values
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-renamer");
  
  if (options::FilesJsonPath.empty()) {
    llvm::errs() << "cannot find Files json file" << '\n';
    return 1;
  }
  if (options::RenamesJsonPath.empty()) {
    llvm::errs() << "cannot find Renames json file" << '\n';
    return 1;
  }
  if (!options::InPlace && options::ObfuscatedProjectPath.empty()) {
    llvm::errs() << "cannot find path to the obfuscated project" << '\n';
    return 1;
  }

  auto FilesJsonOrError = parseJson<FilesJson>(options::FilesJsonPath);
  if (auto Error = FilesJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  auto ConfigurationFilePath = FilesJsonOrError.get().ConfigurationFile;
  ObfuscationConfiguration ObfuscationConfiguration;
  if (!ConfigurationFilePath.empty()) {
    auto ObfuscationConfigurationOrError =
      parseJson<struct ObfuscationConfiguration>(ConfigurationFilePath);
    if (auto Error = ObfuscationConfigurationOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      llvm::outs() << "Error while reading configuration file from "
                   << ConfigurationFilePath << '\n';
    } else {
      ObfuscationConfiguration =
        std::move(ObfuscationConfigurationOrError.get());
    }
  }

  auto RenamesJsonOrError = parseJson<RenamesJson>(options::RenamesJsonPath);
  if (auto Error = RenamesJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  // Required for the compiler to find the path to this tool, and therefore
  // exists only in the tools that are performing compilation (semantic analysis)
  void *MainExecutablePointer =
    reinterpret_cast<void *>(&anchorForGetMainExecutable);
  std::string MainExecutablePath =
    llvm::sys::fs::getMainExecutable(argv[0], MainExecutablePointer);
  
  llvm::raw_ostream *DiagnosticStream;
  // Decides if and where the logs from the compiler will be printed.
  // If llvm::raw_null_ostream is used, they're just discarded.
  if (options::HideDiagnostics) {
    DiagnosticStream = new llvm::raw_null_ostream();
  } else {
    DiagnosticStream = &llvm::outs();
  }

  std::string ProjectPath = options::ObfuscatedProjectPath;
  if(options::InPlace) {
    ProjectPath = FilesJsonOrError.get().Project.RootPath;
  }
  
  // This is the place that the actual renaming is performed.
  // The logic for renaming is in the swiftObfuscation library.
  auto FilesOrError = performRenaming(MainExecutablePath,
                                      FilesJsonOrError.get(),
                                      std::move(ObfuscationConfiguration),
                                      RenamesJsonOrError.get(),
                                      ProjectPath,
                                      options::InPlace,
                                      *DiagnosticStream);
  if (auto Error = FilesOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  if (options::Verbose) {
    // Prints only to the output, not to file
    printObfuscatedFiles(FilesOrError.get());
  }
  
  return 0;
}

