# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

export PATH=$PATH:$(go env GOPATH)/bin

export PATH="$HOME/develop/flutter/bin:$PATH"
export CHROME_EXECUTABLE='/usr/bin/chromium'
export ANDROID_HOME='/home/dff/Android/Sdk'

export ANDROID_SDK_ROOT='/home/dff/Android/Sdk/'
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/

# export YDTOOL='/usr/bin/chromium'
