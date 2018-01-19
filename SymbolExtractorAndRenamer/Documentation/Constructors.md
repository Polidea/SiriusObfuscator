# Constructors Renaming

# Finding constructors declarations and calls in source code

After compiling source code we extract Decl objects. To determine if the Decl object represents either constructor declaration or call we cast Decl to ConstructorDecl using dyn_cast.
```
if (auto *ConstructorDeclaration = dyn_cast<ConstructorDecl>(BaseDeclaration)) { ... }
```

We can also identify that Decl relates to constructor by retrieving it's kind name:
```
auto DeclKind = BaseDeclaration->getKind();
auto KindName = BaseDeclaration->getKindName(DeclKind);
```

# Use Cases

When renaming constructors various cases were considered. For each case we gathered ideas and Swift Compilator solutions to differenciate constructor definitions and calls in source code.

## Structs

### Empty struct without init

#### Declaration

No explicit constructor declaration in source code - nothing to obfuscate.

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

### Empty struct with custom empty init

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

### Struct with property and memberwise init

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

## Classes

### Empty class without init

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

### Empty class with custom empty init

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

### Empty class without init - subclass of UIViewController

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

#### Call

To identify the constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

### Empty subclass of UIViewController with custom init and `required init?(coder aDecoder: NSCoder)`

**TODO: Differenciate constructor declarations from calls**

#### Declaration

To identify the custom constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

For  `required init?(coder aDecoder: NSCoder)` getRequiredInterfactType() returns error. We can handle it by checking:
```
if (ConstructorDeclaration->getInterfaceType()->getKind() == TypeKind::Error) { ... }
```

#### Call

To identify the custom constructor type we check the result type by calling:
```
Decl->getResultInterfaceType()
```

