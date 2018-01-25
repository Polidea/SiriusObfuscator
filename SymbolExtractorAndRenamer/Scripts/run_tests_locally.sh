#!/bin/bash

xcodebuild -project build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/Swift.xcodeproj -target SwiftObfuscationTests

./build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64/unittests/SwiftObfuscation/Debug/SwiftObfuscationTests

swift/utils/run-test swift/test/Obfuscation --build-dir build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/swift-macosx-x86_64 --lit build/Xcode-RelWithDebInfoAssert+swift-DebugAssert/llvm-macosx-x86_64/Debug/bin/llvm-lit

