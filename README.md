# GrzywN's dotfiles

One command sets up a new machine.
It works on Debian-based Linux and on macOS (Apple silicon).

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/GrzywN/.dotfiles/<release-tag>/bootstrap.sh | DOTFILES_REF=<release-tag> bash
```

Use a release tag, not `main`, so the script cannot change under you.
Write the same tag in both places, so the script and the cloned repo come from one tag.
The script asks for every password first.
You need the sudo password and the Ansible Vault password for the SSH key.
After that it runs without questions.

## What it does

1. Installs git on Linux (on macOS, run `xcode-select --install` first), then clones this repo over HTTPS.
2. Installs Nix (pinned version).
3. Builds the home configuration from `flake.nix` with home-manager.
4. Installs Docker, desktop apps and flatpaks on Linux (`setup/linux-system.sh`).
5. Decrypts the SSH key from `secrets/` with ansible-vault.
6. Links the configs with GNU Stow.
7. Installs Node and pnpm with proto.
8. Installs the agent tools (`setup/agents.sh`), Claude Code plugins and skills.
9. Installs the Neovim plugins and parsers.

## What Nix provides

- Neovim nightly, pinned in `flake.lock`.
- The language servers that Neovim enables.
- The JetBrainsMono Nerd Font.
- bash on Linux and zsh on macOS, with starship and zoxide.
- Common command line tools.

Update the pins with `nix flake update`.

## Manual steps after install

- Sign in to `claude`, `gh` and any other agent you use.
- Open a new terminal.
- Run `make doctor`.

## Make targets

- `make bootstrap` runs the full setup.
- `make doctor` checks the result.
- `make stow`, `make unstow` and `make restow` manage the config links.
- `make plugins` installs the Claude Code plugins.
- `make skills` restores the agent skills from `skills-lock.json`.

The package lists for Linux and macOS are in the `Makefile`.

## Not tracked

- Secrets, tokens and login state.
- Files that tools generate for themselves.
- `GALLUP.md`, because this repo is public.

## Notes

- i3 is configured to use Alacritty and rofi.
- rofi needs rofi-emoji and rofi-calc.
