
# Some ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Get rid of command not found
alias cd..='cd ..'

# Handy short cuts
alias h='history'
alias j='jobs -l'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T" +"%d-%m-%Y"'

alias vi=vim

alias ports='netstat -tulanp'

# Confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias wget='wget -c'

alias c='clear'
alias e='emacsclient -t'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Bash profile
alias reload='source ~/.bashrc'

# Git
alias g='git'
alias gg='git status'

# Misc :)
alias less='less -r' # raw control characters

