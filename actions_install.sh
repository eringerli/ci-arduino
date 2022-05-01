#!/bin/bash

set -e

pip3 install clint pyserial setuptools adafruit-nrfutil

# Only install stuff if it is really missing. This should never be executed,
# as the default image contains clang-format v10, v11 (default) and v12.
# https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-Readme.md#language-and-runtime
if [ ! -f /usr/bin/clang-format ]; then
    sudo gem install apt-spy2
    sudo apt-spy2 check
    sudo apt-spy2 fix --commit

    # after selecting a specific mirror, we need to run 'apt-get update'
    sudo apt-get -o Acquire::Retries=3 update

    sudo apt-get -o Acquire::Retries=3 install -y -V clang-format-8 libllvm8

    sudo ln -s /usr/bin/clang-format-8 /usr/bin/clang-format
fi

# make all our directories we need for files and libraries
mkdir ${HOME}/.arduino15
mkdir ${HOME}/.arduino15/packages
mkdir ${HOME}/Arduino
mkdir ${HOME}/Arduino/libraries

# install arduino IDE
export PATH=$PATH:$GITHUB_WORKSPACE/bin
echo $GITHUB_WORKSPACE/bin >> $GITHUB_PATH
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
arduino-cli config init > /dev/null
arduino-cli core update-index > /dev/null
