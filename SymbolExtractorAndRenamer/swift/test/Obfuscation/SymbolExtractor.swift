//RUN: obfuscator-symbol-extractor -filesjson  %S/Inputs/Files.json -symbolsjson %t
//RUN: diff -w %S/Inputs/ExpectedSymbols.json %t
