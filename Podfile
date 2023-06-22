require 'cocoapods'
source 'https://github.com/CocoaPods/Specs.git'
plugin 'cocoapods-binary'

# Uncomment the next line to define a global platform for your project
ios_target_version = '13.0'
platform :ios, ios_target_version
workspace 'eSage'
project 'eSageApp/eSageApp'
# install! 'cocoapods', :disable_input_output_paths => true
use_frameworks!
keep_source_code_for_prebuilt_frameworks!
enable_bitcode_for_prebuilt_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!

def install_pods
    pod 'SwiftGen', '~> 6.0', :binary => true
    pod 'AppsFlyerFramework','6.5.3'
    pod 'Kingfisher', '7.3.2'
    pod 'lottie-ios', '3.5.0'
    pod 'SwiftLint'
end


target 'eSageApp' do
    install_pods
end

 # Networking
#  pod 'Moya'
 
 # Utils
# pod 'IQKeyboardManagerSwift'
 
 # UI
# pod 'NVActivityIndicatorView'

 # Security
# pod 'KeychainAccess'


post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = ios_target_version
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
end

