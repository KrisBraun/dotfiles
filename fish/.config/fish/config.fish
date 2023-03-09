function vi
  nvim $argv
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

test -e {$HOME}/.config/fish/config.fish.local ; and source {$HOME}/.config/fish/config.fish.local

for snippet in conf.d/*
    source $snippet
end

source /usr/local/opt/asdf/libexec/asdf.fish
