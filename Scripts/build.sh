#!/bin/bash

projects=(
  "FileExtractor"
  "TestProjects"
  "VerificationSuite"
  "SymbolExtractorAndRenamer"
)
for i in ${!projects[@]}; do
  echo "BUILD: cd ${projects[$i]} && /bin/bash Scripts/build.sh"
  cd ${projects[$i]} 
  /bin/bash Scripts/build.sh
  cd ..
done

echo "Recreating bin directory"
rm -r bin
mkdir -p bin

echo "Installing FileExtractor"
tar -xf FileExtractor/file-extractor-1.0.0-osx.tar.gz -C .
mv file-extractor-1.0.0-osx/* bin/

echo "Installing FileExtractor"
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-symbol-extractor bin/symbol-extractor

echo "Installing NameMapper"
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-name-mapper bin/name-mapper

echo "Installing Renamer"
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-renamer bin/renamer

echo "Copying Swift compiler lib catalog"
rm -r lib
mkdir lib
cp -r SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/lib/swift ./lib/swift

echo "Installing VerificationSuite"
cp VerificationSuite/VerificationSuite bin/verification-suite

echo "Installing ObfuscatorTool"
swift build -c release 
cp $(swift build -c release --show-bin-path)/ObfuscatorTool bin/obfuscator

