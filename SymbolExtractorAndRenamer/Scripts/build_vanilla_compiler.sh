#!/bin/bash

echo "Identifying current commit"
git rev-parse --verify HEAD
commit_sha=$(git rev-parse --verify HEAD)
echo "Current commit SHA is ${commit_sha}"

echo "Switching git from commit ${commit_sha} to commit 3cb38854e963b84873a7b7769b6c0b3f28c86015"
git checkout 3cb38854e963b84873a7b7769b6c0b3f28c86015

echo "Building project at vanilla state"
swift/utils/build-script -R --ios --tvos --watchos

echo "Making directory for sources in cache"
mkdir build/TMP_SOURCES

echo "Copying vanilla state to build folder for cache reasons..."
cp -r -p llvm/ build/TMP_SOURCES/llvm/
cp -r -p clang/ build/TMP_SOURCES/clang/
cp -r -p swift/ build/TMP_SOURCES/swift/
cp -r -p lldb/ build/TMP_SOURCES/lldb/
cp -r -p cmark/ build/TMP_SOURCES/cmark/
cp -r -p llbuild/ build/TMP_SOURCES/llbuild/
cp -r -p swiftpm/ build/TMP_SOURCES/swiftpm/
cp -r -p compiler-rt/ build/TMP_SOURCES/compiler-rt/
cp -r -p swift-corelibs-xctest/ build/TMP_SOURCES/swift-corelibs-xctest/
cp -r -p swift-corelibs-foundation/ build/TMP_SOURCES/swift-corelibs-foundation/
cp -r -p swift-corelibs-libdispatch/ build/TMP_SOURCES/swift-corelibs-libdispatch/
cp -r -p swift-integration-tests/ build/TMP_SOURCES/swift-integration-tests/
cp -r -p swift-xcode-playground-support/ build/TMP_SOURCES/swift-xcode-playground-support/
cp -r -p ninja/ build/TMP_SOURCES/ninja/
echo "Copying finished"

echo "Checking out the actual branch at ${commit_sha}"
git checkout ${commit_sha}
