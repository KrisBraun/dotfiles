if test -e /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
else
    eval (/opt/homebrew/bin/brew shellenv)
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

test -e {$HOME}/.config/fish/config.fish.local; and source {$HOME}/.config/fish/config.fish.local

if test (which nvim)
    set EDITOR nvim
    function vi
        nvim $argv
    end
end

function e2e
    CYPRESS_BASE_URL=https://collide-pr-$argv[1].herokuapp.com REACT_APP_API_ROOT_PATH=https://api.staging-v3.powernoodle.com npx cypress $argv[2]
end

for snippet in conf.d/*
    source $snippet
end

if test -e /usr/local/opt/asdf/libexec/asdf.fish
    source /usr/local/opt/asdf/libexec/asdf.fish
end
if test -e /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end
