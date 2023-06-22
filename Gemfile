source "https://rubygems.org"

gem 'cocoapods', '~> 1.11.2'
gem 'fastlane'
gem 'danger'
gem 'danger-swiftlint'
gem 'danger-xcode_summary'
gem 'linterbot'
gem 'cocoapods-binary'

# gem 'slather',
#ruby '2.5.0'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }



plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)



