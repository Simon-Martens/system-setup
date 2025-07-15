# commit faster
function c() {
		git add .
		git commit -m "$1"
		git push
}

alias lg='lazygit'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

