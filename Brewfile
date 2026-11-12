# Rebuilt 2026-11 from what was actually installed. `brew bundle --file ~/dotfiles/Brewfile`
# Commented lines were installed before but look legacy; uncomment if you still need them.
# Homebrew 7 refuses third-party tap formulas until trusted: install.sh runs `brew trust` on each tap below.

tap "ariga/tap"
tap "aws/tap"
tap "btwld/fvm"
tap "cloudflare/cloudflare"
tap "fsouza/prettierd"
tap "oven-sh/bun"
tap "stripe/stripe-cli"
tap "universal-ctags/universal-ctags"

# --- Shell & core CLI ---
brew "git"
brew "stow"
brew "coreutils"
brew "bash"
brew "curl"
brew "wget"
brew "jq"
brew "fzf"
brew "fd"
brew "ripgrep"
brew "the_silver_searcher"
brew "ast-grep"
brew "lazygit"
brew "httpie"
brew "hyperfine"
brew "rename"
brew "zip"
brew "gnu-tar"
brew "gnupg"
brew "mas"
brew "dockutil"
brew "uv"
brew "pipx"
brew "mackup"
brew "syncthing", restart_service: :changed   # syncs ~/Notes with the phone

# --- Version managers & languages (versions come from ~/.tool-versions) ---
brew "asdf"
brew "fvm"
brew "oven-sh/bun/bun"
# Build deps for asdf python / ruby
brew "openssl@3"
brew "readline"
brew "libyaml"
brew "xz"
brew "zlib"
brew "tcl-tk"
brew "pkgconf"

# --- Editors / LSP ---
brew "lua-language-server"
brew "luajit"
brew "luarocks"
brew "typescript-language-server"
brew "universal-ctags/universal-ctags/universal-ctags", args: ["HEAD"]
brew "fsouza/prettierd/prettierd"

# --- Git / GitHub / CI ---
brew "gh"
brew "git-filter-repo"
brew "gitleaks"
brew "actionlint"

# --- Cloud & infra ---
brew "awscli"
brew "aws-sam-cli"
brew "cfn-lint"
brew "azure-cli"
brew "cloud-sql-proxy"
brew "cloudflared"
brew "flyctl"
brew "caddy"
brew "ariga/tap/atlas"
brew "stripe/stripe-cli/stripe"
brew "livekit-cli"
brew "bundletool"
brew "mcp-toolbox"

# --- Databases & clients ---
brew "libpq"
brew "postgresql@17"
brew "pgformatter"
brew "mysql-client"
brew "redis"

# --- Media ---
brew "imagemagick"
brew "librsvg"
brew "sox"
brew "yt-dlp"

# --- Legacy (installed before; uncomment if needed) ---
# brew "postgresql@14", restart_service: true   # had a 281 MB data dir; dev DBs now run in Docker
# brew "postgresql@15"
# brew "postgresql@16"
# brew "mysql@8.0"            # runQL
# brew "unixodbc"             # runQL
# brew "python@3.8"           # python comes from asdf
# brew "python@3.9"
# brew "python@3.10"
# brew "python@3.11"
# brew "openssl@1.1"          # disabled in Homebrew
# brew "openvpn"
# brew "easy-rsa"
# brew "fish"
# brew "llvm"
# brew "gcc"
# brew "bison"
# brew "re2c"
# brew "docutils"
# brew "cookiecutter"
# brew "wimlib"               # Windows ISO tooling (UTM)
# brew "mailhog"
# brew "emacs"
# brew "unbound"

# --- Fonts ---
cask "font-fira-code"
cask "font-fira-code-nerd-font"
cask "font-symbols-only-nerd-font"
cask "font-monaspace"

# --- Apps: core ---
cask "1password"
cask "1password-cli"
cask "google-chrome"
cask "zen"
cask "microsoft-edge"
cask "firefox"
cask "google-drive"
cask "kitty"
cask "zed"
cask "visual-studio-code"
cask "raycast"
cask "alfred"
cask "amethyst"
cask "karabiner-elements"
cask "docker-desktop"
cask "gcloud-cli"
cask "android-studio"
cask "claude"
cask "chatgpt"
cask "obsidian"
cask "linear-linear"
cask "notion"
cask "notion-calendar"
cask "slack"
cask "discord"
cask "beeper"
cask "signal"
cask "zoom"
cask "tuple"
cask "loom"
cask "granola"
cask "superlist"
cask "sunsama"
cask "todoist-app"
cask "httpie-desktop"
cask "tableplus"
cask "dbeaver-community"
cask "sequel-ace"
cask "ngrok"
cask "appcleaner"
cask "obs"
cask "descript"
cask "caldigit-docking-utility"

# --- Apps: occasional (uncomment if needed) ---
# cask "microsoft-office"
# cask "microsoft-teams"
# cask "onedrive"
# cask "adobe-acrobat-reader"
# cask "beekeeper-studio"
# cask "popsql"
# cask "utm"                  # had a 23 GB Windows 11 VM; rebuild with CrystalFetch if needed
# cask "protonvpn"
# cask "aws-vpn-client"
# cask "hubstaff"
# cask "fellow"
# cask "twist"
# cask "raspberry-pi-imager"
# cask "macsvg"
# cask "mjml-app"

# --- Mac App Store (sign in to the App Store first) ---
mas "Xcode", id: 497799835
mas "TestFlight", id: 899247664
mas "Developer", id: 640199958
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "GarageBand", id: 682658836
mas "iMovie", id: 408981434
mas "Irvue", id: 1039633667
mas "Flow", id: 1423210932
mas "Session", id: 1521432881
mas "Color Picker", id: 1545870783
mas "CrystalFetch", id: 6454431289
mas "Speedtest", id: 1153157709
mas "Prime Video", id: 545519333

# Not available via Homebrew/App Store, install by hand if wanted:
# Logi Tune, Papiers, Kinso, GlidePane, RunQL, Pommedoro, Transformer Lab, Adobe Acrobat DC
