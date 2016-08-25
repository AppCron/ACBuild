#   Set -e to abort on error, just like Jenkins.
set -e

ACScheme="SDSApp"
ACBundleIdentifier=""
ACExportPlistPath="build-release.plist"

echo "### ACBuild: Starting Build ..."
echo

echo "### ACBuild: Listing Xcode project ..."
xcodebuild -list
echo

echo "### ACBuild: Checking build folder ..."
if [ -d build ]; then
echo "### ACBuild: Removing build folder ..."
rm -r build
fi
echo

echo "### ACBuild: Cleaning targets ..."
xcodebuild clean -alltargets
echo

echo "### ACBuild: Running archive build ..."
echo
if [ -n "$ACBundleIdentifier" ]; then
xcodebuild PRODUCT_BUNDLE_IDENTIFIER="$ACBundleIdentifier" -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive"
else
xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive"
fi
echo

echo "### ACBuild: Exporting archive to IPA ..."
echo "### Export options PLIST path: $ACExportPlistPath"
echo
xcodebuild -exportArchive -archivePath "build/ACBuild/$ACScheme.xcarchive" -exportOptionsPlist "$ACExportPlistPath" -exportPath "build/ACBuild"
