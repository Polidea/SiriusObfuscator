#!/bin/bash 

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)

for i in ${!projects[@]}; do
  echo "Fetch origin ${projects[$i]}"
  git fetch ${projects[$i]}

  echo "Clone code from ${projects[$i]} to directory ${projects[$i]}_tmp"
  git read-tree --prefix=${projects[$i]}_tmp -u ${projects[$i]}/master

  echo "Copy cloned code from ${projects[$i]}_tmp to ${projects[$i]}"
  rsync --progress --checksum --ignore-times -r ${projects[$i]}_tmp/* ${projects[$i]}

  echo "Delete directory ${projects[$i]}_tmp"
  rm -r "${projects[$i]}_tmp"
done

git add . -A
git commit -m "Updated dependencies"

