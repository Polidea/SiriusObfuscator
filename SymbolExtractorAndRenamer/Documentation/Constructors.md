# Constructors Renaming

# Finding constructor calls in source code

## Creating AST

After passing project source files to `CompilerInstance` via  `CompilerInvocationConfiguration` the AST is created by calling:

```
CompilerInstance.performSema();
```
Next, we retrieve source files representations by calling

```
ComplierInstance.getMainModule()->getFiles();
```
and cast each `FileUnit` object to `SourceFile`.

For finding constructor calls we use `RenamesCollector`. It's a subclass of `SourceEntityWalker` - part of swiftAST toolchain for traversing AST and providing source information.

We pass  `SourceFile` objects one by one to `RenamesCollector`:

```
RenamesCollector.walk(SourceFile);
```
and use `SourceEntityWalker`'s callbacks to find constuctor calls.

## Finding constructor calls in AST

For finding constructor calls while traversing AST we use `SourceEntityWalker`'s callback overriden by `RenamesCollector`:

```
bool visitDeclReference(ValueDecl *Declaration, CharSourceRange Range,
TypeDecl *CtorTyRef, ExtensionDecl *ExtTyRef,
Type T, ReferenceMetaData Data)
```
If `CtorTyRef` parameter is non-null, it means that we've found constructor declaration reference and it represents the type owning this constructor.

## Renaming

After casting `CtorTyRef` to `NominalTypeDecl` it is represented in `symbols.json` the same way as type declaration. This way we ensure that each constructor is renamed to the same name as the type of object it is constructing.

Currently only the constructor calls' names are being renamed. If the constructor has arguments, their names are not being renamed in neither constructor declarations nor calls.

## Examples

### Example 1: Implicit / empty init

```swift
struct Sample { }
struct Sample { init {} }
let sample = Sample()
let sample2 = Sample.init()

———————————————————————————

struct ObfuscatedSample { }
struct ObfuscatedSample { init {} }
let sample = ObfuscatedSample()
let sample2 = ObfuscatedSample.init()
```

### Example 2: Memberwise init

```swift
struct Sample {
  let number: Int
  let text: String
}
let sample = Sample(number: 42, text: "24")
let sample2 = Sample.init(number: 42, text: "24")

———————————————————————————————————————————

struct ObfuscatedSample {
  let number: Int
  let text: String
}
let sample = ObfuscatedSample(number: 42, text: "24")
let sample2 = ObfuscatedSample.init(number: 42, text: "24")
```

### Example 3: Init with arguments

```swift
struct Sample {
  init(number: Int, text: String) { /* ... */ }
}
let sample = Sample(number: 42, text: "24")
let sample2 = Sample.init(number: 42, text: "24")

———————————————————————————————————————————

struct ObfuscatedSample {
  init(number: Int, text: String) { /* ... */ }
}
let sample = ObfuscatedSample(number: 42, text: "24")
let sample2 = ObfuscatedSample.init(number: 42, text: "24")
```
