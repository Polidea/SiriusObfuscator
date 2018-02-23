# Important topics for SymbolExtractor

The goal of this document is to be a bag of important ideas, decisions, concepts and discoveries in the `SymbolExtractor` project. Currently these include:

1. [Why do we use Swift compiler for identifying symbols in Swift source code?](#compiler)
2. [Why do we use the LLVM mechanism for error handling?](#errors)
3. [What is the `CompilerInstance` and `CompilerInvocation` and how are they used?](#instance)
4. [How the semantic analysis is performed?](#sema)
5. [How do we work with AST that is the result of semantic analysis?](#ast)
6. [What are symbols and what is their relation to AST?](#symbols)
7. [Why are there multiple structures for symbols?](#multiple)
8. [What information should identifier carry?](#identifier)
9. [How can I add support for the new Swift construct?](#add)
10. [What are usual problems to take into consideration when supporting a new Swift construct?](#problems)

# <a name="compiler"></a> Why we forked Swift compiler?

We're using Swift compiler so that we can obtain the semantic analysis of the Swift source code. The information that we look for are:

* What part of language does this identifier represent?  
  For example: Is it a type name, a function name, an operator?
* In what context is particular identifier used?  
  For example: Is it a function definition or function call?
* What module does this identifier belong to?  
  For example: Is it part of out code and we should rename it or is it part of UIKit and we should not rename it?
* What are additional characteristics of the ideintifier?  
  For example: If it's a function, then does it override other function? Does it fulfill a protocol requirement?

All the information are required to decide whether the indentifier should be renamed and what should it be renamed to. At the same time, these are hard to obtain from a naive parsing.

# <a name="errors"></a> Why do we use LLVM error handling?

Swift compiler is written in a close relation to LLVM. It's using a lot of LLVM infrastructure, from the types such as `llvm::StringRef` or `llvm::ArrayRef` through the actual LLVM IR generation to the coding convenctions and test tools. In the compiler-based projects we're trying to follow the conventions and therefore adapt the LLVM way of writing C++.

One of the LLVM standards it to avoid using C++ exceptions for error handling. Also, it's recommended to avoid `std::error_code`. There's a dedicated LLVM API providing the alternative, namely `llvm::Expected<>` and `llvm::ErrorOr<>` types. They're very similar to the `Result` type from many other languages.

See [LLVM Programmer's Manual](https://llvm.org/docs/ProgrammersManual.html) and [LLVM Coding Standards](https://llvm.org/docs/CodingStandards.html) for more information.

# <a name="instance"></a> How do we launch the compiler?

We're using the Swift compiler class called `CompilerInstance` from `swiftFrontend` library to perform the part of compilation related to semantic analysis. This class keeps references to multiple singletons that are storing the compilation state and results (such as `ASTContext`). It also provides the essencial `performSema` method.

The `CompilerInstance` must be set up before starting to work. The class for gathering and storing all the information required for compilation is `CompilerInvocation`. It defines what's needed for compilation and therefore was the must important element of determining which information should be extracted in `FileExtractor` and stored in `Files.json`. The most important one include:

* module name, which defines which module would the compiled code be represented as belonging to,

* input filenames, which are paths to the actual Swift source code files that are compiled and analysed,

* framework search paths, which must include paths to look for the frameworks defining moduls that compiled files link to,

* sdk path, which should contain the actual system libraries to link the app against,

* target triple, which defines the architecture that we should compile against. It's used to determine which standard library and which shims for system libraries to use.


# <a name="sema"></a> How the semantic analysis is performed?

Semantic analysis is done by the `CompilerInstance` in the `performSema` method. It takes all the input source files and parses them to build the AST for the whole module. The process of AST generation ends even if there're some problems making it impossible to generate the proper AST for some parts of code; for example, if the code doesn't compile, it might cause the lack of recognision for some symbols.

# <a name="ast"></a> How do we work with AST that is the result of semantic analysis?

`CompilerInstace`, after the semantic analysis, gives the resulting AST in the form of `SourceFile` objects. These objects define the declaration context that represent the code in a particular Swift source file. We're parsing them one by one using the `SourceEntityWalker` class from `swiftAST` library. This class, being asked to parse `SourceFile` using `walk(SourceFile &SrcFile)` method, calls back its virtual `walkTo*` and `visit*` methods each time a symbol is encountered. By providing our own implementations of these methods we can control what to do when a symbol is encountered.

The basic objects to look for are `Decl` subclasses obtained in `walkToDeclPre` and `visitDeclReference` methods. Sample declarations include: `FuncDecl` (function declaration), `NominalTypeDecl` (declaration of type), `OperatorDecl` (operator declaration). Each one of these is then parsed by the proper declaration parsers.

# <a name="symbols"></a> What are symbols and what is their relation to AST?

Symbols are structures internal to `swiftObfuscation` library designed to store all the data required to uniquely identify the particular symbol, its metadata, the place that it was encountered and the index of its occurence among all the symbols in the files. In other words, AST is the representation of the syntactic structure of source code that carries all the information. Symbol is a greatly simplified representation of a particular substring in the source code that carries just enough information to let uniquely identify it among other substrings. Therefore AST is the source of information and symbols are the derived view designed for obfuscation needs.

Most AST nodes are being represented by one symbol, for example the type or function name. Some, however, might be represented by multiple symbols, such as `ParamDecl` (parameter declaration, used in the functions signatures and bodies), which results two symbols: external parameter name and internal parameter name.

# <a name="multiple"></a> Why are there multiple structures for symbols?

There are three structures for symbols: `IndexedSymbolWithRange`, `SymbolWithRange`, `Symbol` and `SymbolRenaming`. 

The last two are the simple data structures that are serializable and deserializable and designed to just store the information that symbol carries. `Symbol` is defining the format of `Symbols.json` and `SymbolRenaming` is defining `Renames.json`.

The other two are just adding additional information to the `Symbol`. 

`SymbolWithRange` is adding the information about where the particular symbol was encountered in the file. It stores the location of the substring in the Swift source code. It's the basic structure that the declaration parsers are working with, because it enables them to store all the occurences of symbols.

`IndexedSymbolWithRange` is adding the information about the order in which the symbols were encountered among all the source files. It enables us to write them down in the `Symbols.json` file in the same order and therefore get the same order of obfuscated name generations. It's crucial for the integration tests.

# <a name="identifier"></a> What information should identifier carry?

The identifier should carry just enough information to be uniquely represented among all the other symbols with the same name. The amount of information depends on the particular symbol. 

For types, the name and module is enough to distinguish them among other types, because it's forbidden in Swift to have two classes with the same name on one module (nested classes are represented with their full path).

For methods, however, the name and module is not enough. We also need to write the scope in which they were defined (because two methods with the same name can exist in different classes), whether they're static or instance (because two methods with the same name might exist in the same class if one is static and the other is not), their signatures (because two methods with the same name can exist in the same class if their signatures are different) and so on.

Defining the proper scope of information for each symbol identifier is crucial task in the obfuscator development.

# <a name="add"></a> How can I add support for the new Swift construct?

If the construct is already parsed in the `SourceEntityWalker`, please visit corresponding parser, for example `DeclarationParser` or `ExpressionParser`.

If the constuct is not yet parsed in `SourceEntityWalker`, please override the proper `SourceEntityWalker` virtual method and provide the new parser.

# <a name="problems"></a> What are usual problems to take into consideration when supporting a new Swift construct?

The non-exhaustive list of things to consider when implementing support for new constuct include:

* can it be in relation to some other construct, such as the function can override other function of fulfill the protocol requirements?

* can it reference or be in relation with the symbol from other module, such as property might override the SDK-derived property?

* does it exist in multiple forms, such as function can be either static or instance?

* can it exist in multiple places, such as type that might be used to specify the variable type, but also to parametrize the generic type?

* is there a corresponding construct that must also be supported, such as the constructor that should be renamed when the type is renamed?
