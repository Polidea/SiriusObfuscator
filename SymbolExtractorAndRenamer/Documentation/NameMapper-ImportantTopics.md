# Important topics for Name Mapper

The goal of this document is to be a bag of important ideas, decisions, concepts and discoveries in the `NameMapper` project. Currently these include:

1. [Why is NameMapper a separate command line tool?](#separate)
2. [Why does NameMapper need to know about the symbol type to generate the obfuscated name proposal?](#type)
3. [Where are the characters to build the obfuscated name taken from?](#symbols)
4. [How can we ensure that the generated name will be unique and there will be no name collision?](#unique)
5. [Why is there a random and deterministic name generation option available?](#deterministic)

# <a name="separate"></a> `NameMapper` as the separate tool

Among the tools that are part of the obfuscator the `NameMapper` is the smallest and has the least responsibilities. It's a simple input-output command line tool that takes one json and returnes almost identical json, with just one field added to it's schema.

It's build as the separate command line tool, with all the infrastructure that comes with it, so that the logic determining what is the renaming mode and what symbols are being renamed and how is kept in one place. It makes it way easier to ensure that the particular symbol will not be renamed (it's enough to remove it from the the `Renames.json`). It also makes the de-obfuscation a trivial task (it's enough to provide the `Renames.json` with values from `originalName` and `obfuscatedName` reversed). The renaming modes can be defined and added to the command-line interface in a dedicated place, which avoids clutter in the command-line iterfaces of the other tools.

# <a name="type"></a> Why are symbols types necessary for the NameMapper to generate name?

Different symbols have different sets of characters that are permitted to be used in them. So to generate the obfuscated name for operator one has to use characters that are not allowed in the function name. That's why `NameMapper` requires separate symbol type.

# <a name="symbols"></a> Characters for obfuscated names

The symbols used to generate obfuscated names are taken from the [Swift language grammar reference](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/zzSummaryOfTheGrammar.html#//apple_ref/doc/uid/TP40014097-CH38-ID458). For example, the [structure of the identifier](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/swift/grammar/identifier) explicitely lists what characters might be used. In the other place, the [structure of the type](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/zzSummaryOfTheGrammar.html#//apple_ref/doc/uid/TP40014097-CH38-ID482) shows that the type name is an identifier, and therefore all the characters used for identifier can be used for type name.

Similar analysis is used for all supported constructs, like function names or operators.

# <a name="unique"></a> How `NameMapper` prevents name collisions?

`NameMapper` caches what names were already generated and used for renaming. It tries to generate new name in case of name collision. The process is repeated up to 100 times. If after 100 tries this there's still name collision, the `NameMapper` logs error to the output and exits.

There's no name collision preventing at the time, however, that ensures that the generated name is different than some already existing original symbol name. The feature is in the future plans.

# <a name="deterministic"></a> Why is there a random and deterministic name generation option available?

The random generation is the default one and it leads to the obfuscation in its main purpose: to render the code unreadable and more difficult to understand for the attacker that's looking for symbols in the binary file.

The deterministic name generation was created for the testing purpose as it enables to write the expected obfuscated code for the given original source file. It's done with three steps:

* each symbol has a known prefix (dependant on its kind) added to the name instead of replacing its name with the random name (`NF` for functions, `T` for types etc.),

* the strictly incremental index number is appended to the prefix, so that if there's more than one symbol of the same kind and the same name in the source code, the obfuscated name differs between them (for example, `NF1_foo` and `NF2_foo`),

* the symbol extraction is done in the deterministic order from the top of the file to the bottom of the file, with files parsed in the alphabetical order (`a-zA-Z`).

These three rules are enough to know what obfuscated name would a particular symbol get. It's enough to know it's kind, name and the first occurence.
