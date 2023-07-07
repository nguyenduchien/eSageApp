# github comment settings
github.dismiss_out_of_range_messages

# Warn when there is a big PR
warn("Big PR, try to keep changes smaller if you can") if git.lines_of_code > 300

# Notice with PR
if github.pr_title.include?('[WIP]') || github.pr_labels.include?('WIP')
    warn('PR is classed as Work in Progress')
  end

  # Warn when there is a big PR
warn "a large PR" if git.lines_of_code > 500
warn "No details" if github.pr_body.length < 1 && git.lines_of_code > 10

protected_files = ["Gemfile", "Cartfile", "Podfile", "Dangerfile", ".gitignore", ".swiftlint.yml"]
protected_files.each do |file|
  next if git.modified_files.grep(/#{file}/).empty?
  message("#{file} changed")
end

# swiftlint
swiftlint.lint_files inline_mode: true

swiftlint.max_num_violations = 20

swiftlint.config_file = '.swiftlint.yml'
swiftlint.binary_path = './Pods/SwiftLint/swiftlint'
swiftlint.lint_files inline_mode: true 
# checkstyle_format.base_path = Dir.pwd
# checkstyle_format.report 'swiftlint-checkstyle.xml'
swiftlint.lint_files fail_on_error: true 
swiftlint.lint_all_files = true


xcode_summary.report './fastlane/test_output/eSageLocal.xcresult'
