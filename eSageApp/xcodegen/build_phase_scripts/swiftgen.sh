# https://github.com/SwiftGen/SwiftGen

if [[ -f "${PODS_ROOT}/SwiftGen/bin/swiftgen" ]]; then
  "${PODS_ROOT}/SwiftGen/bin/swiftgen" config run --config "$SRCROOT/../SwiftGen.yml"
else
  echo "warning: SwiftGen is not installed. Run 'pod install --repo-update' to install it."
fi
