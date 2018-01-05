function vi
  nvim $argv
end
function composer
  php ~/bin/composer.phar $argv
end
function homestead
  pushd ~/Homestead; and vagrant $argv; popd
end

# Set iTerm2 titlebar colour
echo -n -e "\033]6;1;bg;red;brightness;60\a"
echo -n -e "\033]6;1;bg;green;brightness;56\a"
echo -n -e "\033]6;1;bg;blue;brightness;54\a"

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
test -e {$HOME}/.config/fish/config.fish.local ; and source {$HOME}/.config/fish/config.fish.local
