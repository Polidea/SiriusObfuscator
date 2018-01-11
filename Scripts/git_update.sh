#!/bin/bash 

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)

mv SymbolExtractorAndRenamer/build ./tmp_build

for i in ${!projects[@]}; do
  git rm -r ${projects[$i]} --quiet
  git fetch ${projects[$i]}
  git read-tree --prefix=${projects[$i]} -u ${projects[$i]}/master
done

mv tmp_build SymbolExtractorAndRenamer/build 

git add . -A
git commit -m "Updated dependencies"

