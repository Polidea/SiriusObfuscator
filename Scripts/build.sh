#!/bin/bash

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)
for i in ${!projects[@]}; do
  echo "BUILD: cd ${projects[$i]} && /bin/bash Scripts/build.sh"
  cd ${projects[$i]} 
  /bin/bash Scripts/build.sh
  cd ..
done

mkdir bin
tar -xf FileExtractor/file-extractor-1.0.0-osx.tar.gz -C .
mv file-extractor-1.0.0-osx/* bin/
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-symbol-extractor bin/
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-name-mapper bin/
cp SymbolExtractorAndRenamer/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/obfuscator-renamer bin/ 
cp VerificationSuite/VerificationSuite bin/verification-suite



