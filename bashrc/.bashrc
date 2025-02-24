# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
export PATH="/home/dave/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/dave/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$PATH:/home/dave/Desktop/basex/bin"

alias ls=ls
