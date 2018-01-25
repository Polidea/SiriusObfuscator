#!/bin/bash

cmake --build ./build/Ninja-ReleaseAssert/swift-macosx-x86_64/ -- -j4 SwiftUnitTests
./build/Ninja-ReleaseAssert/swift-macosx-x86_64/unittests/SwiftObfuscation/SwiftObfuscationTests
swift/utils/run-test swift/test/Obfuscation --build-dir build/Ninja-ReleaseAssert/swift-macosx-x86_64 --lit build/Ninja-ReleaseAssert/llvm-macosx-x86_64/bin/llvm-lit

