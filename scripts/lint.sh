#!/bin/bash

function sectionEcho() {
  printf "\n"
  printf "\033[32;1m--------------------- $1 ---------------------\033[0m\n"
}

function isExist() {
  type $1 >/dev/null 2>&1
}

# Homebrew のインストール
if ! isExist brew; then
  sectionEcho "install homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# swiftlint のインストール
if ! isExist swiftlint; then
  sectionEcho "brew install swiftlint"
  brew install swiftlint
fi

# swiftlint実行
sectionEcho "swiftlint eSageApp"
swiftlint --config .swiftlint.yml --quiet --path eSageApp/App
