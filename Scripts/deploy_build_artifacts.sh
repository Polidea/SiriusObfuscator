#!/bin/bash

now="$(date +%Y-%m-%d_%H%M%S)"
archive_name="Obfuscator_$now.tar.gz"

echo "Compressing build artifacts"
tar -zcf $archive_name bin lib

if [ -z "$CI_COMMIT_TAG" ]; then
  upload_url="http://artifactory.local.polidea.com:8081/artifactory/obfuscator-tool/master/$archive_name"
else
  upload_url="http://artifactory.local.polidea.com:8081/artifactory/obfuscator-tool/$CI_COMMIT_TAG/$archive_name"
fi

echo "Deploying build artifacts to Artifactory"
curl -u $ARTIFACTORY_USER:$ARTIFACTORY_API_KEY -T $archive_name $upload_url
rm -r $archive_name
