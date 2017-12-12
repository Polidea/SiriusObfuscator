#!/bin/bash

names=( 
    "llvm"
    "clang"
    "swift"
    "lldb"
    "cmark"
    "llbuild"
    "swiftpm"
    "compiler-rt"
    "swift-corelibs-xctest"
    "swift-corelibs-foundation"
    "swift-corelibs-libdispatch"
    "swift-integration-tests"
    "swift-xcode-playground-support"
    "ninja"
)

paths=(
    "apple/swift-llvm"
    "apple/swift-clang"
    "apple/swift"
    "apple/swift-lldb"
    "apple/swift-cmark"
    "apple/swift-llbuild"
    "apple/swift-package-manager"
    "apple/swift-compiler-rt"
    "apple/swift-corelibs-xctest"
    "apple/swift-corelibs-foundation"
    "apple/swift-corelibs-libdispatch"
    "apple/swift-integration-tests"
    "apple/swift-xcode-playground-support"
    "ninja-build/ninja"
)

masterbranches=(
    "stable"
    "stable"
    "master"
    "stable"
    "master"
    "master"
    "master"
    "stable"
    "master"
    "master"
    "master"
    "master"
    "master"
    "release"
)

swift_3_0_branches=(
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "swift-3.0-branch"
    "release"
)

swift_3_1_branches=(
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "swift-3.1-branch"
    "release"
)

swift_4_0_branches=(
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "swift-4.0-branch"
    "release"
)

swift_4_1_branches=(
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "swift-4.1-branch"
    "release"
)

if [ $# -eq 0 ]
then
    echo "Using default branches: Swift 4.0"
    branches=( "${swift_4_0_branches[@]}" ) # default to swift 4.0
else
    branch_parameter="$1"
    case $branch_parameter in
        -m|--master)
        branches=( "${masterbranches[@]}" )
        ;;
        -3.0|--swift-3.0)
        branches=( "${swift_3_0_branches[@]}" )
        ;;
        -3.1|--swift-3.1)
        branches=( "${swift_3_1_branches[@]}" )
        ;;
        -4.0|--swift-4.0)
        branches=( "${swift_4_0_branches[@]}" )
        ;;
        -4.1|--swift-4.1)
        branches=( "${swift_4_1_branches[@]}" )
        ;;
        -h|--help)
        echo "Available parameters for checing dependencies in given version:"
        echo ""
        echo "-m   | --master    -> current master branch (not frozen)"
        echo "-3.0 | --swift-3.0 -> branch for Swift 3.0 (frozen)"
        echo "-3.1 | --swift-3.1 -> branch for Swift 3.1 (frozen)"
        echo "-4.0 | --swift-4.0 -> branch for Swift 4.0 (frozen)"
        echo "-4.1 | --swift-4.1 -> branch for Swift 4.1 (frozen)"
        exit 0
        ;;
        *)
        echo "Invalid parameter ${branch_parameter}"
        echo "Use --help or -h to discover valid parameters"
        exit 1
        ;;
    esac
fi

diff_start=3cb38854e963b84873a7b7769b6c0b3f28c86015 # the starting commit
diff_end=$(git log -1 --format="%H")

echo "GENERATE PATCH: git checkout ${diff_end} && git format-patch ${diff_start} --stdout > obfuscator.patch"
git checkout ${diff_end} && git format-patch ${diff_start} --stdout > obfuscator.patch

echo "RESET TO START: git reset --hard ${diff_start}"
git reset --hard ${diff_start}

for i in ${!names[@]}; do
  echo "DATA: ${names[$i]} -> ${paths[$i]} -> ${branches[$i]}"
  echo "GIT REMOVE: git rm -r ${names[$i]}"
  git rm -r ${names[$i]}
  echo "REMOTE: git remote add ${names[$i]} https://github.com/${paths[$i]}.git"
  git remote add ${names[$i]} https://github.com/${paths[$i]}.git
  echo "FETCH: git fetch ${names[$i]}"
  git fetch ${names[$i]}
  echo "READ-TREE: git read-tree --prefix=${names[$i]} -u ${names[$i]}/${branches[$i]}"
  git read-tree --prefix=${names[$i]} -u ${names[$i]}/${branches[$i]}
done

echo "APPLY PATCH: git apply obfuscator.patch"
git apply obfuscator.patch

echo "REMOVE PATCH: rm obfuscator.patch"
rm obfuscator.patch

