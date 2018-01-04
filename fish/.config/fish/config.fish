function vi
  nvim $argv
end
function composer
  php ~/bin/composer.phar $argv
end
function homestead
  pushd ~/Homestead; and vagrant $argv; popd
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
test -e {$HOME}/.config/fish/config.fish.local ; and source {$HOME}/.config/fish/config.fish.local
