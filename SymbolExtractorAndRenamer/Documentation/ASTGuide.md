# Swift AST Guide

This document stores all the information that we've gathered while working with the Swift AST. Since AST is not documented (the closest to the introductory guide is provided by [this blogpost](https://medium.com/@slavapestov/the-secret-life-of-types-in-swift-ff83c3c000a5)), the knowledge is partial and experimental. Please treat it as the work in progress, not as the very trusted source :)

# Basic AST node types

* `Decl` is the AST node that represents a declaration, so basically the identifier in code.

* `Expr` is the AST node that represents an expression, which is something that returns value.

* `Stmt` is the AST node that represents a statement, the language part that is used for the control flow and defining the context for the expressions and identifiers, but doesn't return value.

# `Decl` AST node subtypes

* `NominalTypeDecl` represents a declaration of type, like struct or class or enum or protocol. It has four subclasses:

  * `EnumDecl` represents the declaration of enum

  * `StructDecl` represents the declaration of struct

  * `ClassDecl` represents the declaration of class

  * `ProtocolDecl` represents the declaration of protocol

* `FuncDecl` represents the declaration of functions

* `OperatorDecl` represents the declaration of the operator

* `ConstructorDecl` represents the declaration of constructor

* `ParamDecl` represents the declaration of parameter

* `VarDecl` represents the declaration of variable
