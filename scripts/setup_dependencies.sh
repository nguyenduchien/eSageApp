#!/bin/bash
# Store current conf profile as bash by default
configurationProfile=~/.bash_profile

# Store current shell as bash by default
currentShell=bash

function sectionEcho() {
  if [ -z "$2" ]; then
    bg_color="81"
  else 
    bg_color="$2"
  fi

  if [ -z "$3" ]; then
    text_color="16"
  else 
    text_color="$3"
  fi

  printf "\n"
  printf "\033[38;5;${text_color};48;5;${bg_color}m --------------------- $1 --------------------- \033[0m\n"
}

function isExist() {
  type $1 >/dev/null 2>&1
}

function isAppleSilicon() {

  # uname -p or uname -m will return x86_64 if using Rosetta.
  # To avoid, use sysctl and grep for "Apple" at the start of string.

  if [[ $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
    true
  else
    false
  fi
}

function checkVersion() {
  if [ $1 != $2 ]; then
    printf "\033[31;1m$3 version is not the most recent（Have: $1 , Latest: $2 ）\033[0m\n"
  else
    printf "\033[32;1m$3 is the latest version（Ver: $1）\033[0m\n"
  fi
}

function cocoapodsOutdated() {
  if [[ `brew outdated | grep "cocoapods" 2>/dev/null` ]]; then
    true
  else
    false
  fi
}

function getCurrentShell() {
  if [[ $SHELL == "/bin/zsh" ]]; then
    configurationProfile=~/.zshrc
    currentShell=zsh
  else
    configurationProfile=~/.bash_profile
    currentShell=bash
  fi
}

function configureRbenvShell() {
  if command -v rbenv 1>/dev/null 2>&1; then
    if !(grep -q .rbenv/bin "$configurationProfile"); then
      echo "export PATH="$HOME/.rbenv/bin:$PATH"" >> "$configurationProfile"
      echo "eval $(rbenv init - $currentShell)" >> "$configurationProfile"
    fi
  fi
}


function reloadShellConfig() {
  sectionEcho "Reloading your shell profile..." 16 231
  source "$configurationProfile"
}

# configure shell

getCurrentShell

# install brew

if ! isExist brew; then
  sectionEcho "Installing Homebrew" 27 231
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi

# check for apple silicon

if isAppleSilicon; then
  echo "       
               _            _ _ _             
   ___ ___ ___| |___    ___|_| |_|___ ___ ___ 
  | .'| . | . | | -_|  |_ -| | | |  _| . |   |
  |__,|  _|  _|_|___|  |___|_|_|_|___|___|_|_|
      |_| |_|                                 
  "

  sectionEcho "Configuring for Apple Silicon-based Mac" 27 231

  if [[ :$PATH: != *:"/opt/homebrew/bin":* ]]; then
    export PATH=/opt/homebrew/bin:$PATH
    reloadShellConfig
  fi
else
  echo "         
   _     _       _ 
  |_|___| |_ ___| |
  | |   |  _| -_| |
  |_|_|_|_| |___|_|              
  "
  
  sectionEcho "Configuring for Intel-based Mac" 27 231
fi

# install xcodegen

if ! isExist xcodegen; then
  sectionEcho "Installing Xcodegen..." 27 231
  brew install xcodegen
fi

# install rbenv
#
# if no rbenv, we can assume that development ruby 
# has not been installed into it either, so do that too

if ! isExist rbenv; then
  sectionEcho "Installing rbenv..." 63 231
  brew install rbenv 

  sectionEcho "Verifying rbenv installation..." 63 231
  configureRbenvShell
  reloadShellConfig

  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | eval "$currentShell"  
  
  sectionEcho "Initializing rbenv..." 63 231
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | eval "$currentShell" 

  sectionEcho "Installing ruby..." 63 231
  rbenv install 3.0.2 

  sectionEcho "Setting global ruby version..." 63 231
  rbenv global 3.0.2 

  reloadShellConfig
elif isExist rbenv; then
  sectionEcho "Configuring rbenv..." 63 231
  if ! rbenv versions 2>&1 | grep -q '3.0.2'; then
    sectionEcho "Installing ruby..." 63 231
    rbenv install 3.0.2 

    sectionEcho "Setting global ruby version..." 63 231
    rbenv global 3.0.2 
  else
    sectionEcho "Setting global ruby version..." 63 231
    rbenv global 3.0.2 
  fi

  reloadShellConfig
fi

# install swiftlint
if ! isExist swiftlint; then
  sectionEcho "Installing swiftlint..." 171 231
  brew install swiftlint 
fi

# install bundler
if ! isExist bundle; then
  sectionEcho "Installing bundler..." 207 231
  gem install bundler 
fi

# execute bundle install
sectionEcho "Running bundler..." 219 16

bundle config set --local path 'vendor/bundle' 
bundle install 

if isAppleSilicon; then
  # For aSi, Homebrew Cocoapods is required!
  # Certain crashes with Cocoapods will only be avoided this way.
  # let bundler proceed, but then replace the Pods binary...

  gem uninstall cocoapods 
  brew install cocoapods 
fi

# build project
sectionEcho "Building project with xcodegen..." 123 16
xcodegen --spec ./eSageApp/project_local.yml --project ./eSageApp



# execute pod install
sectionEcho "Running pod install..." 75 16
bundle exec pod install  || bundle exec pod install --repo-update 

# install mergepbx
if ! isExist mergepbx; then
  sectionEcho "Installing mergepbx - A Tool to Automatically Merge Changes in Your XCode Project Files" 27 231
  ./scripts/setup_mergepbx.sh 
fi

# check cocoapods version

sectionEcho "Checking cocoapods version..." 63 231

if isAppleSilicon; then
  if cocoapodsOutdated; then
    sectionEcho "Upgrading cocoapods..." 63 231
    brew upgrade cocoapods 
  else
    sectionEcho "You have the latest version of Cocoapods! Nice!" 119 16
  fi
else
  current_ver=`bundle exec pod --version`
  latest_ver=`gem list cocoapods --remote 2>/dev/null | head -n 1 | grep -oe '\d\.\d\{1,\}\.\d\{1,\}'`
  checkVersion ${current_ver} ${latest_ver} "Cocoapods" 119 16
fi

sectionEcho "Creating config githooks..." 99 231
  git config core.hooksPath "./scripts/githooks"

sectionEcho "Success!" 119 16

# send a notification on finish via Applescript
if isExist osascript; then
  osascript -e 'display notification "Setup xong rồi đó ku" with title "Nhìn giề"'
fi

