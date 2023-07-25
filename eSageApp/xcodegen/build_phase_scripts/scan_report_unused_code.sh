# Type a script or drag a script file from your workspace to insert its path.
SCHEME_NAME=`cat ${SCHEME_FILE}`
echo "Current scheme: $SCHEME_NAME"

rm ${SCHEME_FILE}

if test -d /opt/homebrew/bin; then
  PATH=/opt/homebrew/bin/:$PATH
fi

report_file="$SRCROOT/../unused_code_report.log"

if which periphery >/dev/null; then
  periphery clear-cache
  periphery scan --workspace "../eSage.xcworkspace" --schemes "eSageAppDebug" --targets "eSageApp" --format xcode --clean-build 2>&1 | tee -a $report_file
else
  echo "Periphery does not exist, download from https://github.com/peripheryapp/periphery"
fi

rm -f $file_path
