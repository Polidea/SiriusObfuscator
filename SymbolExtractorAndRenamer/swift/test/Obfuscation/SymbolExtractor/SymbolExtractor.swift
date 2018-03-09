
//RUN: echo "{\"project\": {\"rootPath\": \"TestRootPath\", \"projectFilePath\": \"testProjectFilePath\"}, \"module\": {\"name\": \"TestModuleName\", \"triple\": \"x86_64-apple-macosx10.13\"}, \"sdk\": {\"name\": \"%target-sdk-name\", \"path\": \"%sdk\"}, \"sourceFiles\": [\"%S/Inputs\/ViewController.swift\", \"%S/Inputs\/AppDelegate.swift\"], \"layoutFiles\": [], \"explicitlyLinkedFrameworks\": [], \"implicitlyLinkedFrameworks\": [], \"frameworkSearchPaths\": [], \"headerSearchPaths\": [], \"bridgingHeader\": \"\"}" > %T/files.json
//RUN: obfuscator-symbol-extractor -filesjson %T/files.json -symbolsjson %t -printdiagnostics
//RUN: diff -w %S/Inputs/expectedSymbols.json %t

