#!/bin/bash

function sectionEcho() {
  printf "\n"
  printf "\033[32;1m--------------------- $1 ---------------------\033[0m\n"
}

function isExist() {
  type $1 >/dev/null 2>&1
}

# Homebrew installation if not exists
if ! isExist brew; then
  sectionEcho "install homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# periphery if not exist
if ! isExist periphery; then
  sectionEcho "brew install periphery"
  brew install peripheryapp/periphery/periphery
fi

sectionEcho "periphery scan"

report_file="unused_code_report.log"

periphery clear-cache
periphery scan --workspace "eSage.xcworkspace" --schemes "eSageApp" --targets "eSageApp" --format xcode --clean-build 2>&1 | tee -a $report_file

# Mac notification
if isExist osascript; then
  osascript -e 'display notification "Done" with title "periphery scan"'
fi
