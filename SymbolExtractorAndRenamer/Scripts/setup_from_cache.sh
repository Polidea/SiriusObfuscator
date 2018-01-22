#!/bin/bash

echo "Identifying current commit"
git rev-parse --verify HEAD
commit_sha=$(git rev-parse --verify HEAD)
echo "Current commit SHA is ${commit_sha}"

echo "Remove current sources"
rm -f -r llvm
rm -f -r clang
rm -f -r swift
rm -f -r lldb
rm -f -r cmark
rm -f -r llbuild
rm -f -r swiftpm
rm -f -r compiler-rt
rm -f -r swift-corelibs-xctest
rm -f -r swift-corelibs-foundation
rm -f -r swift-corelibs-libdispatch
rm -f -r swift-integration-tests
rm -f -r swift-xcode-playground-support
rm -f -r ninja
echo "Removing finished"

echo "Copy vanilla sources"
cp -r -p build/TMP_SOURCES/llvm/ llvm/ 
cp -r -p build/TMP_SOURCES/clang/ clang/ 
cp -r -p build/TMP_SOURCES/swift/ swift/ 
cp -r -p build/TMP_SOURCES/lldb/ lldb/ 
cp -r -p build/TMP_SOURCES/cmark/ cmark/ 
cp -r -p build/TMP_SOURCES/llbuild/ llbuild/ 
cp -r -p build/TMP_SOURCES/swiftpm/ swiftpm/ 
cp -r -p build/TMP_SOURCES/compiler-rt/ compiler-rt/ 
cp -r -p build/TMP_SOURCES/swift-corelibs-xctest/ swift-corelibs-xctest/ 
cp -r -p build/TMP_SOURCES/swift-corelibs-foundation/ swift-corelibs-foundation/ 
cp -r -p build/TMP_SOURCES/swift-corelibs-libdispatch/ swift-corelibs-libdispatch/ 
cp -r -p build/TMP_SOURCES/swift-integration-tests/ swift-integration-tests/ 
cp -r -p build/TMP_SOURCES/swift-xcode-playground-support/ swift-xcode-playground-support/ 
cp -r -p build/TMP_SOURCES/ninja/ ninja/ 

rm -f -r build/TMP_SOURCES/
echo "Copying finished"

echo "Checking out the actual branch at ${commit_sha}"
git add . -A
git reset --hard ${commit_sha}
