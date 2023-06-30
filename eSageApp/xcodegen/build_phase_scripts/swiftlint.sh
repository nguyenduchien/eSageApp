if test -d /opt/homebrew/bin; then
  PATH=/opt/homebrew/bin/:$PATH
fi

if [ ${CONFIGURATION} == "Release" ]; then
echo "Skip SwiftLint"
exit 0
fi

if which swiftlint >/dev/null; then
swiftlint
else
echo "SwiftLint does not exist, download from https://github.com/realm/SwiftLint"
fi
