#!/bin/bash 

projects=(
  "FileExtractor"
  "SymbolExtractorAndRenamer"
  "TestProjects"
  "VerificationSuite"
)

GITSHA=$(git log -1 --format="%H")

touch tmp.file
git add . -A
git commit -m "Updated dependencies"
NEWSHA=$(git log -1 --format="%H")

for i in ${!projects[@]}; do
  git merge -X subtree=${projects[$i]} --squash ${projects[$i]}/master --allow-unrelated-histories
  git commit --fixup $NEWSHA
done

rm tmp.file
git add . -A
git commit --fixup $NEWSHA

git rebase --interactive --autosquash $GITSHA

