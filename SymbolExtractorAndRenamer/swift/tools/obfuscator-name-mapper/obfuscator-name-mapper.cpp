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

}

void printRenamings(const std::vector<SymbolRenaming> &Renamings) {
  for (const auto &Renaming : Renamings) {
    llvm::outs()
      << "identifier: " << Renaming.Identifier << '\n'
      << "originalName: " << Renaming.OriginalName << '\n'
      << "obfuscatedName: " << Renaming.ObfuscatedName << '\n'
      << "module: " << Renaming.Module << '\n';
  }
}

int main(int argc, char *argv[]) {
  INITIALIZE_LLVM(argc, argv);
  llvm::cl::HideUnrelatedOptions(options::ObfuscatorNameMapper);
  
  llvm::ExitOnError ExitOnError;
  ExitOnError.setExitCodeMapper(
    [](const llvm::Error &Err) { return 1; }
  );
  llvm::outs() << "Swift obfuscator name mapper tool" << '\n';
  
  llvm::cl::ParseCommandLineOptions(argc, argv, "obfuscator-name-mapper");
  
  if (options::SymbolsJsonPath.empty()) {
    llvm::errs() << "cannot find Symbols json file" << '\n';
    return 1;
  }

  MemoryBufferProvider BufferProvider = MemoryBufferProvider();
  std::string PathToJson = options::SymbolsJsonPath;
  auto SymbolsJsonOrError = parseJson<SymbolsJson>(PathToJson, BufferProvider);
  if (auto Error = SymbolsJsonOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  
  auto RenamingsOrError = proposeRenamings(SymbolsJsonOrError.get());
  if (auto Error = RenamingsOrError.takeError()) {
    ExitOnError(std::move(Error));
  }
  auto Renamings = RenamingsOrError.get();
  
  printRenamings(Renamings.Symbols);
  
  std::string PathToOutput = options::RenamesJsonPath;
  FileFactory<llvm::raw_fd_ostream> Factory = FileFactory<llvm::raw_fd_ostream>();

  if (auto Error = writeToPath(Renamings, PathToOutput, Factory, llvm::outs())) {
    ExitOnError(std::move(Error));
  }
  return 0;
}
