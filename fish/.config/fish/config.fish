function vi
  nvim $argv
end
function composer
  php ~/bin/composer.phar $argv
end
function homestead
  pushd ~/Homestead; and vagrant $argv; popd
end

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Set iTerm2 titlebar colour
echo -n -e "\033]6;1;bg;red;brightness;60\a"
echo -n -e "\033]6;1;bg;green;brightness;56\a"
echo -n -e "\033]6;1;bg;blue;brightness;54\a"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
test -e {$HOME}/.config/fish/config.fish.local ; and source {$HOME}/.config/fish/config.fish.local

for snippet in conf.d/*
    source $snippet
end

source /usr/local/opt/asdf/libexec/asdf.fish
