# Kris' macOS setup

Three scripts, run in order around a wipe:

| When | Script | What it does |
|---|---|---|
| Before wiping | `backup.sh` | Saves everything that isn't already in GitHub / iCloud / Google Drive / 1Password to Google Drive, with credentials in an encrypted `secrets.dmg`. |
| Fresh Mac, first | `install.sh` | Command Line Tools, Homebrew + every app (`Brewfile`), Oh My Zsh + Powerlevel10k, dotfiles via `stow`, asdf runtimes, global CLIs, Claude Code, Dock. |
| Fresh Mac, second | `restore.sh` | Credentials, repos (incl. local-only branches and stashes), app settings, launch agents, Claude Code config/memory/plugins. |

Stow packages: `zsh git kitty nvim karabiner zed asdf mackup.cfg`. Secrets never go in this repo:
they live in `~/.zshrc.local` (sourced by `.zshrc`) and other files that `backup.sh` puts in `secrets.dmg`.

---

## 1. Before wiping

1. Push or bundle all code work. `backup.sh` bundles every local-only branch and stash, but pushing is better
   where you can. Check worktrees with `~/code/plot/nexus/scripts/worktree-status`.
2. Dry run, then the real backup (run in a normal terminal: it asks for a password and macOS asks to allow
   each signing key export):
   ```sh
   ~/dotfiles/backup.sh --dry-run
   ~/dotfiles/backup.sh                 # add --with-transcripts to keep Claude Code session history
   ```
   It writes to `Google Drive/My Drive/Mac Backup/<computer>-<date>/`.
3. Save the `secrets.dmg` password in 1Password.
4. Raycast: Settings → Advanced → **Export**, save the `.rayconfig` into the backup folder.
5. Wait until Google Drive's menu bar icon shows nothing pending. Then on **another device** open
   drive.google.com and check the folder is there, including `secrets.dmg` and `repos.tsv`.
6. Make sure you can sign in without this Mac: Apple Account password, 1Password Secret Key / Emergency Kit,
   and your phone for 2FA.
7. Music/TV: Account → Authorizations → **Deauthorize This Computer**.
8. Optional but tidy: System Settings → [your name] → **Sign Out** (turns off Find My / Activation Lock).
   Desktop & Documents are in iCloud; when asked, you don't need to keep a local copy.

## 2. Erase (fully reformat) the drive

This is an Apple silicon Mac with FileVault on. The problem is corruption inside the APFS container:
the Data volume reports ~956 GB used while the files on it add up to roughly 600 GB. A normal "Erase All
Content and Settings" only removes the volumes and keeps the container, so it may not clear that.
Use one of these, best first:

### Option A: Restore with Apple Configurator (best; needs a second Mac and a USB-C data cable)

This erases the **whole** internal SSD, re-creates every container, reinstalls firmware, recoveryOS and the
latest macOS. It's the most thorough reformat Apple offers.

1. On the other Mac install **Apple Configurator** (free, App Store).
2. Shut this Mac down. Connect the cable to its **DFU port**: Apple's article below shows which port that is
   for each MacBook model. Leave only power and that cable plugged in.
3. Press the power button, and while holding it, press and hold **left Control + left Option + right Shift**
   for about 10 seconds. Release those three keys but keep holding power until a **DFU** icon appears in
   Configurator on the other Mac. The screen of this Mac stays black.
4. In Configurator select the DFU icon → **Actions → Restore** → confirm. Takes 10 to 30 minutes.
5. The Mac restarts into Setup Assistant on a freshly partitioned disk.

Apple: [Revive or restore a Mac with Apple silicon](https://support.apple.com/guide/apple-configurator-mac/revive-or-restore-a-mac-with-apple-silicon-apdd5f3c75ad/mac)
and [How to revive or restore Mac firmware](https://support.apple.com/en-us/108900) (DFU port per model).
Any Apple Store can also do this restore for you.

### Option B: Disk Utility in macOS Recovery (no second Mac)

1. Shut down. Press and hold the power button until **Loading startup options** → **Options** → Continue.
   Pick your admin user and enter its password.
2. Disk Utility → **View → Show All Devices**.
3. Optional check first: select the **container** that holds "Macintosh HD" → **First Aid**.
4. Select **Macintosh HD** → **Erase**, Format **APFS**, then click **Erase Volume Group** (not plain
   Erase). Confirm **Erase Mac**; it restarts and activates over the internet.
5. Back in Recovery, choose **Reinstall macOS**.

Apple: [Use Disk Utility to erase a Mac with Apple silicon](https://support.apple.com/en-us/102506).

After the reinstall, check whether the space problem is gone: Finder's "Used" figure for the disk should
roughly match `sudo du -sh /System/Volumes/Data`. If they drift apart again, or Disk Utility can't erase,
use Option A (or an Apple Store). Repeated APFS corruption after a full restore points at the SSD hardware,
which only Apple can test.

## 3. Set up the fresh Mac

1. Setup Assistant: sign in with your Apple Account, turn on FileVault, and **don't** use Migration Assistant
   (that would bring the old state back).
2. Run phase 1 in Terminal:
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KrisBraun/dotfiles/master/install.sh)"
   ```
   It pauses once for the Command Line Tools dialog and once so you can sign in to the App Store.
3. Sign in to 1Password, Google Drive, Chrome profiles, Zen (Firefox Sync), Raycast, Slack and so on.
   Wait for Google Drive to show `My Drive/Mac Backup`.
4. Optionally edit `repos.tsv` in the backup folder: lines starting with `#` are skipped (repos untouched
   for a year start commented out).
5. Run phase 2:
   ```sh
   ~/dotfiles/restore.sh
   ```
6. Follow the "By hand" list it prints: Raycast import, `pnpm install && pnpm get-env` in each Plot repo,
   cloud CLI logins, Android SDK, Xcode.

Restored local-only branches appear as `pre-wipe/<branch>` (`git switch <branch>` picks them up) and stashes
as `refs/pre-wipe/stash-N` (`git stash apply refs/pre-wipe/stash-0`). Uncommitted work from worktrees is in
`~/code/.pre-wipe-wip/`.

## Keeping it current

`./save.sh` writes `Brewfile.current` (everything installed now) so you can diff it against `Brewfile`
and add anything new by hand.
