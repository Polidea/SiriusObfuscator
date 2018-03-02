# Things that are not obfuscated

There are a couple of language features that are not subject to obfuscation.
These features are:
  - local variables
  - closure parameters
  - closure capture list elements
  - associated types
  - type aliases
  - enum constants
  - generic parameters

None of them is visible in the compiled binary. For example local variables are not included in the [symbol table](https://en.wikipedia.org/wiki/Symbol_table). They are kept on [stack](https://en.wikipedia.org/wiki/Call_stack) or in [registers](https://en.wikipedia.org/wiki/Processor_register) depending on how compiler optimized the code. You may be now wondering - how the debugger know the names of local variables? It uses special debug informations that are included in the compiled binary when it's compiled in "debug mode". In release builds these special debug informations are stripped off.

Similarly associated types, type aliases, enum constants and generic parameters are also not visible in the compiled code.


References:
  - ["Advanced Apple Debugging & Reverse Engineering" by Derek Selander (pages 124, 159)](https://store.raywenderlich.com/products/advanced-apple-debugging-and-reverse-engineering)
  - [Compiler, Assembler, Linker and Loader:
 a brief story](http://www.tenouk.com/ModuleW.html)
