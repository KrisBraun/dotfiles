# Powerlevel10k instant prompt (must be near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Oh My Zsh ---
typeset -U path fpath   # collapse duplicate fpath entries so OMZ's compdump cache stays valid (fast new-tab startup)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  asdf
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting  # must be last
)

source $ZSH/oh-my-zsh.sh
setopt NO_SHARE_HISTORY

# --- Environment ---
export EDITOR=nvim
export VISUAL=nvim

# --- ASDF ---
. /opt/homebrew/opt/asdf/libexec/asdf.sh
. ~/.asdf/plugins/java/set-java-home.zsh
# Speed: set-java-home.zsh registers asdf_update_java_home as a *precmd* hook, so it
# forks `asdf which java` before every single prompt. Resolve JAVA_HOME only when the
# directory actually changes (chpwd) instead, and once now for the initial directory.
add-zsh-hook -d precmd asdf_update_java_home
add-zsh-hook chpwd asdf_update_java_home
asdf_update_java_home

# --- PATH (non-ASDF, non-Homebrew managed) ---
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.shorebird/bin:$PATH"
export PATH="$HOME/.claude/local:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# --- Functions ---

# Launch nvim with OpenAI API key loaded
vi() {
  export OPENAI_API_KEY=$(cat ~/.config/openai.token)
  nvim "$@"
}

# pnpm shorthand
p() {
  pnpm "$@"
}

# Cypress E2E runner: e2e <pr-number> <cypress-args...>
e2e() {
  CYPRESS_BASE_URL="https://collide-pr-$1.herokuapp.com" \
  REACT_APP_API_ROOT_PATH="https://api.staging-v3.powernoodle.com" \
  npx cypress "${@:2}"
}

# --- Plot dev ---
export PLOT_API_URL=http://localhost:8787 PLOT_SITE_URL=http://localhost:5173
export PLOT_API_URL=http://localhost:8787 PLOT_SITE_URL=http://localhost:5173
alias plot-prod='unset PLOT_API_URL PLOT_SITE_URL'

# --- Powerlevel10k ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Local overrides ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/kris.braun/.dart-cli-completion/zsh-config.zsh ]] && . /Users/kris.braun/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export GITHUB_PAT=$(cat ~/.github_pat)

PATH="/Users/kris.braun/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/kris.braun/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/kris.braun/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/kris.braun/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/kris.braun/perl5"; export PERL_MM_OPT;
