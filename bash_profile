if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

##
# Your previous /Users/glongman/.bash_profile file was backed up as /Users/glongman/.bash_profile.macports-saved_2011-04-13_at_16:29:13
##

# MacPorts Installer addition on 2011-04-13_at_16:29:13: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(rbenv init - bash)"
source ~/.rx/shell_config

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/glongman/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/glongman/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/glongman/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/glongman/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
