# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
# Custom prompt to look like Dell OptiPlex
# PS1='\[\e[01;32m\]dell@dell-OptiPlex-380:\[\e[01;34m\]\w\[\e[00m\]\$ '
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# alias codefile="cd /media/iiab-admin/C298879E98879019/OneDrive/codefile"
alias codefile="cd /mnt/E/codefile"
alias codefilec="cd /media/iiab-admin/OS/Users/jebin/Documents/Codefile"
alias myclock="cd ~/clock && ~/clock/clock"
alias shifter="open /mnt/E/codefile/Js/Me/Shifter/index.html"
alias scheduler="open '/mnt/E/codefile/Js/Me/Scheduler web 2/index.html'"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

 
# Set Java 21 as the default for builds
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Enable Vi mode
set -o vi

# Make Ctrl-C usable by Readline (stop sending SIGINT while editing)
stty intr undef

# Map Ctrl-C to switch to normal mode while editing
bind -m vi-insert '"\C-c": vi-movement-mode'

# Disable 'v' completely in vi command mode
bind -m vi-command '"v": noop'

# Restore real SIGINT for Ctrl-\ 
bind -x '"\C-\\": "kill -INT $$"'

# Created by `pipx` on 2025-11-07 14:55:48
export PATH="$PATH:/home/iiab-admin/.local/bin"
. "$HOME/.cargo/env"

# wine
alias wine32='WINEPREFIX=~/.wine32 WINEARCH=win32 wine'
alias wine64='WINEPREFIX=~/.wine64 WINEARCH=win64 wine'

# opencode
export PATH=/home/iiab-admin/.opencode/bin:$PATH

# add hotkey for tmux-sessionizer
bind -x '"\C-f": ~/.local/bin/tmux-sessionizer'

export PATH=~/.npm-global/bin:$PATH

export LC_ALL=en_IN.UTF-8 
export LANG=en_IN.UTF-8

# opencode
export PATH=/home/lewin/.opencode/bin:$PATH
export EDITOR="nvim"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
 
 
 
# 1. Handle the 'fdfind' vs 'fd' naming on Linux
if command -v fdfind >/dev/null 2>&1; then
    export FD_CMD="fdfind"
elif command -v fd >/dev/null 2>&1; then
    export FD_CMD="fd"
fi

# 2. Set FZF to use FD if available, otherwise fallback to find
if [ -n "$FD_CMD" ]; then
    export FZF_DEFAULT_COMMAND="$FD_CMD --type f --strip-cwd-prefix --hidden --exclude .git --exclude node_modules"
else
    # Fallback if fd is not installed at all
    export FZF_DEFAULT_COMMAND="find . -maxdepth 10 -not -path '*/.*' -not -path './node_modules/*'"
fi

# 3. The Fixed fo function
fo() {
  local file
  # Select the file
  file=$(fzf --query="$1" --select-1 --exit-0)
  
  # Only attempt to open if a file was actually selected
  if [ -n "$file" ]; then
    echo "Opening $file..."
    xdg-open "$file" > /dev/null 2>&1
  fi
}
va() {
    if [ -d ".venv" ]; then
        echo "Activating .venv..."
        source .venv/bin/activate
    elif [ -d "venv" ]; then
        echo "Activating venv..."
        source venv/bin/activate
    else
        echo "No .venv or venv directory found in the current folder."
    fi
}
