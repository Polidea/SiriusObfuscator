#include "swift/Obfuscation/NameMapping.h"
#include "swift/Obfuscation/FileIO.h"

#include "swift/Basic/LLVMInitialize.h"
#include "llvm/Support/CommandLine.h"

using namespace swift;
using namespace swift::obfuscation;

namespace options {
  
static llvm::cl::OptionCategory ObfuscatorNameMapper("Obfuscator Name Mapper");
  
static llvm::cl::opt<std::string>
SymbolsJsonPath("symbolsjson",
                llvm::cl::desc("Name of the file containing extracted symbols"),
                llvm::cl::cat(ObfuscatorNameMapper));

static llvm::cl::opt<std::string>
RenamesJsonPath("renamesjson",
                llvm::cl::desc("Name of the output file to write extracted "
                               "symbols with proposed renamings"),
                llvm::cl::cat(ObfuscatorNameMapper));
  
static llvm::cl::opt<NameMappingStrategy>
NameMappingStrategy("namemappingstrategy",
                    llvm::cl::init(NameMappingStrategy::Random),
                    llvm::cl::desc("Choose name mapping strategy:"),
                    llvm::cl::values(
                      clEnumValN(NameMappingStrategy::Random,
                                 "random",
                                 "Generate random unique identifiers "
                                 "(default)"),
                      clEnumValN(NameMappingStrategy::Deterministic,
                                 "deterministic",
                                 "Generate deterministic identifiers "
                                 "(useful for testing)"),
                      clEnumValN(NameMappingStrategy::Minifying,
                                 "minifying",
                                 "Generate minified identifiers")
                    ),
                llvm::cl::cat(ObfuscatorNameMapper));
  
static llvm::cl::opt<bool>
Verbose("verbose",
        llvm::cl::init(false),
        llvm::cl::desc("Print debug info."),
        llvm::cl::cat(ObfuscatorNameMapper));
}

int main(int argc, char *argv[]) {
  // Required by LLVM to properly parse command-line options
  INITIALIZE_LLVM(argc, argv);
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorNameMapper);

  // Defines the handler for flow-aborting errors, which lets you choose
  // what code to return, whether to log and wheter to do any cleanup
  // http://llvm.org/docs/ProgrammersManual.html#using-exitonerror-to-simplify-tool-code
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );

  llvm::outs() << "Swift obfuscator name mapper tool" << '\n';

  // Must be called before checking the options for values
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-name-mapper");
  
  if (options::SymbolsJsonPath.empty()) {
    llvm::errs() << "cannot find Symbols json file" << '\n';
    return 1;
  }
  std::string PathToJson = options::SymbolsJsonPath;

  auto SymbolsJsonOrError = parseJson<SymbolsJson>(PathToJson);
  if (auto Error = SymbolsJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }

  // This is the place that the actual name generation is performed using
  // the strategy defined by the command line option.
  // The logic for name generation is in the swiftObfuscation library.
  NameMapping NameMapping(options::NameMappingStrategy);
  auto RenamingsOrError = NameMapping.proposeRenamings(SymbolsJsonOrError.get());
  if (auto Error = RenamingsOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  auto Renamings = RenamingsOrError.get();
  
  std::string PathToOutput = options::RenamesJsonPath;
  
  llvm::raw_ostream *DebugStream;
  if (options::Verbose) {
    DebugStream = &llvm::outs();
  } else {
    DebugStream = new llvm::raw_null_ostream();
  }
  
  // Writes the renaming proposals to Renames.json file. Saves at given path.
  FileFactory<llvm::raw_fd_ostream> Factory;
  auto WriteErrorCode = writeToPath(Renamings,
                                    PathToOutput,
                                    Factory,
                                    *DebugStream);
  ExitOnError(std::move(WriteErrorCode));
  
  return 0;
}
