
eval "$(/opt/homebrew/bin/brew shellenv)"
typeset +x FPATH   # brew shellenv exports FPATH, which churns oh-my-zsh's compdump cache on every new tab; keep it shell-local
