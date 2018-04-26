#!/bin/bash

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "VerificationSuite"
)
for i in ${!projects[@]}; do
  echo "GIT REMOVE: git rm -r ${projects[$i]}"
  git rm -r ${projects[$i]}
  echo "REMOTE: git remote add ${projects[$i]} git@github.com:PolideaPlayground/SiriusObfuscator-${projects[$i]}.git"
  git remote add ${projects[$i]} git@github.com:PolideaPlayground/SiriusObfuscator-${projects[$i]}.git
  echo "FETCH: git fetch ${projects[$i]}"
  git fetch ${projects[$i]}
  echo "READ-TREE: git read-tree --prefix=${projects[$i]} -u ${projects[$i]}/master"
  git read-tree --prefix=${projects[$i]} -u ${projects[$i]}/master
done