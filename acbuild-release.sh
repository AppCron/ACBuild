#!/bin/bash

ACScheme="MyScheme"

echo "### ACBuild: Starting Build..."
echo

#   Build the app with release configuration.
echo "### ACBuild: Running archive build ..."
echo
xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive"
