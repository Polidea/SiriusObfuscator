# Integration testing

This document describes the infrastructure for writing and running integration tests. It aims at answering following questions:

1. [How can I run integration tests on my machine?](#run)
2. [Where can I find already existing integration tests?](#find)
3. [How can I write new integration test?](#write)
4. [Where is the integration testing infrastructure defined?](#conf)

We'll tackle these questions one by one.

# <a name="run"></a> Running integration tests

The test runner is called `lit` and it's part of the LLVM testing infrastructure. You can find more information at [lit documentation](https://llvm.org/docs/CommandGuide/lit.html) and [LLVM testing infrastructure guide](https://llvm.org/docs/TestingGuide.html).

Since LLVM is a dependency of Swift compiler, `lit` is already build and available after the compiler is built. However, we're not using it directly. Swift compiler is providing an additional utility called `run-test` that runs `lit` underneath. The utility is available as part of Swift `utils` directory. It creates a better output for `lit` execution and passes the sane default parameters. However, it requires the path to the `lit` executable and to the build folder.

Therefore the actual command to run integration tests is:

```
swift/utils/run-test swift/test/Obfuscation \
    --build-dir build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64 \
    --lit build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/llvm-macosx-x86_64/Debug/bin/llvm-lit
```

# <a name="find"></a> Where are the obfuscator integration tests?

The obfuscator tests are part of the larger Swift compiler test suite and therefore stored at the same root path as the other ones: `swift/test`. There's separate directory for the obfuscator-related tests under `swift/test/Obfuscation`.

For the tests that are working with the whole obfuscation process there's a directory called `FullProcess`. Inside it there're directories for each test suite that will be interpreted as a separate test case by `lit`.

Each directory has the same basic scheme, for example:

```
Properties/  <---------------- name of the test directory
|
|-> Properties.swift  <------- test file with original Swift source
|
|-> Expected/  <-------------- expected fixtures directory
    |
    |-> Properties.swift  <--- expected obfuscated Swift source
```

Name of the directory describes what it contains. There are no limitations on the name. It doesn't have to be the same as the Swift source file name, but it might help with future maintainance.

Test file contains the run command for `lit` and the original Swift source code to be obfuscated. It's name must be the same as the name of the expected fixture file. There might be only one test file per test directory.

`Expected` directory contains the expected fixture file. It must always be of the name `Expected`.

Expected fixture file contains the source code that we expect to be the same as the original source code after obfuscation. Its name must always be the same as the name of the test file.

# <a name="write"></a> Writing integration tests

To write new test in the existing test case (in other words, to expand the existing test case), just add the source code to the test file and the fixture file.

To write the new test case, create a new directory of structure described [above](#find). You might do it by copying already existing test case. Choose the proper names for the directory and for test and fixture files.

Then write the original Swift source code in the test file and the obfuscated source code in the expected fixture file.

Also add the run command for `lit` at the top of the original source file:

```
//RUN: %target-prepare-obfuscation-for-file "<test-file-name>" %target-run-full-obfuscation
```

Remember to provide the correct test file name in the place of `<test-file-name>`. It must be provided without extension, so for `Properties.swift` write:

```
//RUN: %target-prepare-obfuscation-for-file "Properties" %target-run-full-obfuscation
```

If you are deliberately writing test that should fail, please use
```
//XFAIL: *
```
above `//RUN` to indicate that.

Then [run the tests](#run) to ensure the new test is loaded and executed properly.

# <a name="conf"></a> Integration tests configuration

The configuration for running integration tests is added to `swift/test/lit.cfg` file. There's a section between:

```
# Swift Obfuscator Test infrastructure BEGIN
```

and

```
# Swift Obfuscator Test infrastructure END
```

that contain all the commands that are being used for running the integration tests. What happens in the short summary is:

1. `%target-prepare-obfuscation-for-file` defines the bash script that will be generated. The script contains all the commands that should be run for the test. It defines the `FILE` variable that contains the name of the test file and the expected fixture file.

2. `%target-run-full-obfuscation` writes the bash script to filesystem and then runs it.



