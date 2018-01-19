#!/bin/bash 

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)

cp -r -p SymbolExtractorAndRenamer/build ./tmp_build
rm -r SymbolExtractorAndRenamer/build

for i in ${!projects[@]}; do
  git rm -r ${projects[$i]} --quiet
  git fetch ${projects[$i]}
  git read-tree --prefix=${projects[$i]} -u ${projects[$i]}/master
done

cp -r -p tmp_build SymbolExtractorAndRenamer/build 
rm -r tmp_build

git add . -A
git commit -m "Updated dependencies"

