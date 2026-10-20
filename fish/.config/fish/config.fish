if test -e /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
else
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    ! set -q MANPATH; and set MANPATH ''
    set -gx MANPATH /opt/homebrew/share/man $MANPATH
    ! set -q INFOPATH; and set INFOPATH ''
    set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

test -e {$HOME}/.config/fish/config.fish.local; and source {$HOME}/.config/fish/config.fish.local

set -g EDITOR nvim
function vi
    set -x OPENAI_API_KEY (cat ~/.config/openai.token)
    nvim $argv
end

function p
    pnpm $argv
end

function e2e
    CYPRESS_BASE_URL=https://collide-pr-$argv[1].herokuapp.com REACT_APP_API_ROOT_PATH=https://api.staging-v3.powernoodle.com npx cypress $argv[2]
end

for snippet in conf.d/*
    source $snippet
end

alias plot-local 'set -gx PLOT_API_URL http://localhost:8787; set -gx PLOT_SITE_URL http://localhost:5173'

source /opt/homebrew/opt/asdf/libexec/asdf.fish

source ~/.asdf/plugins/java/set-java-home.fish

# pnpm
set -gx PNPM_HOME "/Users/kris.braun/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

