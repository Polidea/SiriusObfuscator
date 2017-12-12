#!/bin/bash

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "NameMapper"
  "TestProjects"
  "VerificationSuite"
)
for i in ${!projects[@]}; do
  echo "BUILD: /bin/bash ${projects[$i]}/Scripts/build.sh"
  /bin/bash ${projects[$i]}/Scripts/build.sh
done

