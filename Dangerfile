# github comment settings
github.dismiss_out_of_range_messages

# Warn when there is a big PR
warn("Big PR, try to keep changes smaller if you can") if git.lines_of_code > 300

# Notice with PR
if github.pr_title.include?('[WIP]') || github.pr_labels.include?('WIP')
    warn('PR is classed as Work in Progress')
  end

swiftlint.max_num_violations = 20

swiftlint.config_file = '.swiftlint.yml'
swiftlint.binary_path = './Pods/SwiftLint/swiftlint'
swiftlint.lint_files inline_mode: true 
# checkstyle_format.base_path = Dir.pwd
# checkstyle_format.report 'swiftlint-checkstyle.xml'
swiftlint.lint_files fail_on_error: true 
swiftlint.lint_all_files = true
