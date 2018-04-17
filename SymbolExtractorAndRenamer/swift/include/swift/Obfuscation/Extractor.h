#ifndef Extractor_h
#define Extractor_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

using ModuleNameAndParts = std::pair<std::string, std::vector<std::string>>;

using ClassDeclarationsWithModules =
  std::vector<std::pair<const ClassDecl*, std::string>>;

using ProtocolDeclarationsWithModules =
  std::set<std::pair<const ProtocolDecl*, std::string>>;

class Extractor {

private:

  template<class T> const T*
  findRecursivelyBaseOverridenDeclarationWithModules(const T *Declaration,
                                                     std::set<std::string> &Modules);

protected:

  template<class T>
  std::pair<const T*, std::set<std::string>>
  getBaseOverridenDeclarationWithModules(const T *Declaration);

public:

  virtual ~Extractor() = 0;

  virtual std::string moduleName(const Decl *);

  virtual ModuleNameAndParts moduleNameAndIdentifierParts(const Decl *);

  std::string declarationName(const ValueDecl* Declaration);

  llvm::Expected<std::string> enclosingTypeName(const Decl* Declaration);

  std::string typeName(const NominalTypeDecl *);

  bool isOverriddenMethodFromTheSameModule(const std::set<std::string> &Modules,
                                           const std::string &OriginModuleName);

  llvm::Expected<std::vector<std::string>>
  nominalTypeIdentifierParts(const NominalTypeDecl *, const std::string &);

};

class NominalTypeExtractor : public Extractor {

private:

  ClassDeclarationsWithModules
  findRecursivelySuperClassDeclarationsWithModules(const ClassDecl *,
                                                   ClassDeclarationsWithModules &);

  void
  findRecursivelyConformingProtocolDeclarationsWithModules(const NominalTypeDecl *,
                                                           ProtocolDeclarationsWithModules &);

public:

  ProtocolDeclarationsWithModules
  getConformingProtocolDeclarationsWithModules(const NominalTypeDecl *);

  ClassDeclarationsWithModules
  getSuperClassDeclarationsWithModules(const ClassDecl *);

  std::string symbolName(const NominalTypeDecl *);

};

class FunctionExtractor : public Extractor {

private:

  void extractSignaturePart(const Type &Result,
                            llvm::raw_string_ostream &StringStream,
                            std::string Fallback);

  std::string extractSignature(const AbstractFunctionDecl *Declaration,
                               std::string Fallback);

public:

  ModuleNameAndParts
  functionIdentifierParts(const AbstractFunctionDecl *Declaration);

  std::vector<ValueDecl*>
  satisfiedProtocolOptionalRequirements(const AbstractFunctionDecl* Declaration);

  std::vector<ValueDecl*>
  satisfiedProtocolRequirements(const AbstractFunctionDecl* Declaration);

  std::string functionName(const AbstractFunctionDecl *);

  std::string functionSignature(const AbstractFunctionDecl *Declaration);

  std::pair<const FuncDecl*, std::set<std::string>>
  getBaseOverridenDeclarationWithModules(const FuncDecl *Declaration);

};

class OperatorExtractor : public Extractor {

public:

  std::string operatorName(const OperatorDecl *);

};

class ParameterExtractor : public Extractor {

private:

  bool isMemberwiseConstructor(const ConstructorDecl*);

public:

  bool isMemberwiseConstructorParameter(const ParamDecl*);

  std::string externalParameterName(const ParamDecl *);

  std::string internalParameterName(const ParamDecl *);

  std::pair<const AbstractFunctionDecl*, std::set<std::string>>
  getBaseOverridenDeclarationWithModules(const AbstractFunctionDecl *);

  std::vector<DeclWithRange> parametersFrom(const AbstractFunctionDecl *);

  llvm::Expected<std::string> parameterNameForCallSite(ParamDecl *);

};

class VariableExtractor : public Extractor {

public:

  std::pair<const VarDecl*, std::set<std::string>>
  getBaseOverridenDeclarationWithModules(const VarDecl *Declaration);

  llvm::Expected<ModuleNameAndParts>
  variableIdentifierPartsFromContext(const VarDecl *Declaration);

};

class TypeRepresentationExtractor : public Extractor {

private:

  llvm::Optional<DeclWithRange>
  handleComponent(ComponentIdentTypeRepr *Component);

  void
  handleTypeRepresentationRecursively(std::vector<llvm::Optional<DeclWithRange>> &Declarations,
                                      TypeRepr *ParentOfTypeRepresentation,
                                      TypeRepr *TypeRepresentation);

public:

  std::vector<DeclWithRange> declarationsFromTypeRepresentation(TypeRepr *);

};

} //namespace obfuscation
} //namespace swift

#endif /* Extractor_h */
