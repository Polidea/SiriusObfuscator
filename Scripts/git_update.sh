#!/bin/bash 

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)
for i in ${!projects[@]}; do
  git merge -X subtree=${projects[$i]} --squash ${projects[$i]}/master
done

