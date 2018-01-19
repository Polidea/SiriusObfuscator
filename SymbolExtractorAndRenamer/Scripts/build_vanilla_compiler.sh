#!/bin/bash

echo "Identifying current commit"
git rev-parse --verify HEAD
commit_sha=$(git rev-parse --verify HEAD)
echo "Current commit SHA is ${commit_sha}"

echo "Switching git from commit ${commit_sha} to commit 3cb38854e963b84873a7b7769b6c0b3f28c86015"
git checkout 3cb38854e963b84873a7b7769b6c0b3f28c86015

echo "Building project at vanilla state"
swift/utils/build-script -R

echo "Checking out the actual branch at ${commit_sha}"
git checkout ${commit_sha}

