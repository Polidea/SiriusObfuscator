#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/Utils.h"

#include "swift/Frontend/PrintingDiagnosticConsumer.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"

#include <vector>

namespace swift {
namespace obfuscation {

struct CompilerInvocationConfiguration {
  std::string ModuleName;
  std::string Triple;
  std::string MainExecutablePath;
  std::string SdkPath;
  std::vector<std::string> InputFilenames;
  std::vector<SearchPathOptions::FrameworkSearchPath> Paths;
  std::vector<std::string> HeaderPaths;
  std::string BridgingHeader;
  
  CompilerInvocationConfiguration(const FilesJson &FilesJson,
                                  std::string MainExecutablePath)
  : ModuleName(FilesJson.Module.Name),
  Triple(FilesJson.Module.TargetTriple),
  MainExecutablePath(MainExecutablePath),
  SdkPath(FilesJson.Sdk.Path),
  InputFilenames(FilesJson.SourceFiles),
  HeaderPaths(FilesJson.HeaderSearchPaths),
  BridgingHeader(FilesJson.BridgingHeader) {
    for (const auto &Framework : FilesJson.ExplicitlyLinkedFrameworks) {
      if (Framework.Path.find(SdkPath) == std::string::npos) {
        SearchPathOptions::FrameworkSearchPath Path(Framework.Path, false);
        Paths.push_back(Path);
      }
    }
    for (const auto &FrameworkPath : FilesJson.FrameworkSearchPaths) {
      SearchPathOptions::FrameworkSearchPath Path(FrameworkPath, false);
      Paths.push_back(Path);
    }
  }
};

CompilerInvocation
createInvocation(const CompilerInvocationConfiguration &Configuration) {
  CompilerInvocation Invocation;
  Invocation.setModuleName(Configuration.ModuleName);
  Invocation.setMainExecutablePath(Configuration.MainExecutablePath);
  for (const auto &InputFilename : Configuration.InputFilenames) {
    Invocation.addInputFilename(InputFilename);
  }
  auto ExtraArgs = Invocation.getExtraClangArgs().vec();
  for (auto HeaderPath : Configuration.HeaderPaths) {
    ExtraArgs.push_back("-I" + HeaderPath);
  }
  Invocation.setExtraClangArgs(ExtraArgs);
  Invocation.getFrontendOptions().ImplicitObjCHeaderPath =
    Configuration.BridgingHeader;
  Invocation.getClangImporterOptions().BridgingHeader =
    Configuration.BridgingHeader;
  Invocation.getLangOptions().EnableObjCInterop = true;
  Invocation.getLangOptions().AttachCommentsToDecls = true;
  Invocation.setFrameworkSearchPaths(Configuration.Paths);
  Invocation.setSDKPath(Configuration.SdkPath);
  Invocation.setTargetTriple(Configuration.Triple);
  return Invocation;
}

llvm::Expected<std::unique_ptr<CompilerInstance>>
createCompilerInstance(const FilesJson &FilesJson,
                       std::string MainExecutablePath,
                       llvm::raw_ostream &LogStream) {

  auto CompilerInstance = llvm::make_unique<class CompilerInstance>();

  CompilerInvocationConfiguration Configuration(FilesJson, MainExecutablePath);
  auto Invocation = createInvocation(Configuration);
  PrintingDiagnosticConsumer Printer(LogStream);
  CompilerInstance->addDiagnosticConsumer(&Printer);
  if (CompilerInstance->setup(Invocation) || Printer.didErrorOccur()) {
    return stringError("Error during compiler setup");
  }
  CompilerInstance->performSema();
  if (Printer.didErrorOccur()) {
    LogStream << "Error during compiler semantic analysis. Be extra careful "
                 "while interpreting the results." << '\n';
  }
  return std::move(CompilerInstance);
}

} //namespace obfuscation
} //namespace swift
