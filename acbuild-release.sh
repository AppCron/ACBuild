#!/bin/bash

ACScheme="MyScheme"
ACExportPlistPath="acbuild-release.plist"

echo "### ACBuild: Starting Build ..."
echo

echo "### ACBuild: Cleaning targets ..."
xcodebuild clean -alltargets
echo

echo "### ACBuild: Running archive build ..."
echo
xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive"
echo

echo "### ACBuild: Exporting archive to IPA ..."
echo "### Export options PLIST path: $ACExportPlistPath"
echo
xcodebuild -exportArchive -archivePath "build/ACBuild/$ACScheme.xcarchive" -exportOptionsPlist "$ACExportPlistPath" -exportPath "build/ACBuild"
