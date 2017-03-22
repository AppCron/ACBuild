echo "### ACBuild: Starting build ..."

ACExportPlistPath="acbuild-development.plist"

skipNext=0

for param in "$@"; do
  if [ $skipNext == 1 ]; then
    shift
    skipNext=0
    continue
  elif [ $param == "-scheme" ]; then
    shift
    ACScheme=$1
    skipNext=1
  elif [ $param == "-team" ]; then
    shift
    ACTeam=$1
    skipNext=1
  elif [ $param == "-bundle" ]; then
    shift
    ACBundleIdentifier=$1
    skipNext=1
  elif [ $param == "-options" ]; then
    shift
    ACExportPlistPath=$1
    skipNext=1
  fi
done

echo "Xcode version:"
xcodebuild -version
echo

if ! [ -n "$ACScheme" ]; then
  echo "Error: Scheme is missing. Please specificy a scheme with -scheme schemeName"
  return
fi

echo "Build Scheme: $ACScheme"
echo "Development Team: $ACTeam"
echo "Bundle Identifier: $ACBundleIdentifier"
echo "Export PLIST: $ACExportPlistPath"
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
xcodebuild clean -alltargets DEVELOPMENT_TEAM="$ACTeam"
echo

echo "### ACBuild: Running archive build ..."
echo

# Team + x
if [ -n "$ACTeam" ]; then
  if [ - n "$ACBundleIdentifier"]; then
    xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive" DEVELOPMENT_TEAM="$ACTeam" PRODUCT_BUNDLE_IDENTIFIER="$ACBundleIdentifier"
  else
    xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive" DEVELOPMENT_TEAM="$ACTeam" 
  fi
# Bundle Identifier only
elif [- n "$ACBundleIdentifier"]; then
  echo "GOOD"
  xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive" PRODUCT_BUNDLE_IDENTIFIER="$ACBundleIdentifier"
# Default
else
  xcodebuild -scheme "$ACScheme" archive -archivePath "build/ACBuild/$ACScheme.xcarchive" 
fi
echo

echo "### ACBuild: Exporting archive to IPA ..."
echo "### Export options PLIST path: $ACExportPlistPath"
echo
xcodebuild -exportArchive -archivePath "build/ACBuild/$ACScheme.xcarchive" -exportOptionsPlist "$ACExportPlistPath" -exportPath "build/ACBuild"
