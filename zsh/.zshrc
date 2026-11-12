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
[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh
if [[ -f ~/.asdf/plugins/java/set-java-home.zsh ]]; then
  . ~/.asdf/plugins/java/set-java-home.zsh
  # Speed: set-java-home.zsh registers asdf_update_java_home as a *precmd* hook, so it
  # forks `asdf which java` before every single prompt. Resolve JAVA_HOME only when the
  # directory actually changes (chpwd) instead, and once now for the initial directory.
  add-zsh-hook -d precmd asdf_update_java_home
  add-zsh-hook chpwd asdf_update_java_home
  asdf_update_java_home() {
    local java_path
    java_path="$(asdf which java 2>/dev/null)"
    if [[ -n "${java_path}" ]]; then
      export JAVA_HOME
      JAVA_HOME="$(dirname "$(dirname "${java_path:A}")")"
      export JDK_HOME=${JAVA_HOME}
    fi
  }
  asdf_update_java_home
fi

# --- PATH (non-ASDF, non-Homebrew managed) ---
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.shorebird/bin:$PATH"
export PATH="$HOME/.claude/local:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# --- Functions ---

# Launch nvim with OpenAI API key loaded
vi() {
  export OPENAI_API_KEY=$(cat ~/.config/openai.token 2>/dev/null)
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
export PLOT_API_URL=http://localhost:8787
export PLOT_SITE_URL=http://localhost:5173
alias plot-prod='unset PLOT_API_URL PLOT_SITE_URL'

# --- Perl local::lib (cpan installs into ~/perl5) ---
if [[ -d ~/perl5 ]]; then
  export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
  export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
  export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
  export PERL_MB_OPT="--install_base \"$HOME/perl5\""
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
fi

# --- Dart CLI completion ---
[[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true

# --- Powerlevel10k ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Local overrides and secrets (API keys, GITHUB_PAT, ASC IDs): not in this repo ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
