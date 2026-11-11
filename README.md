# GrzywN's dotfiles

Uses GNU Stow – https://www.gnu.org/software/stow/

## WARNING:

- i3 is configured to use Alacritty, rofi and bumblebee-status by default. If you want to use something else, you need to change i3 config file.
- rofi requires rofi-emoji and rofi-calc.
- nvim requires packer.nvim (AUR nvim-packer-git).

## Usage: 

Install stow
```bash
sudo apt-get install stow
```

Clone .dotfiles
```bash
git clone git@github.com:GrzywN/.dotfiles.git ~/.dotfiles
```

Stow files
```bash
cd $HOME/.dotfiles && ./popos
```

Stow the agent and tool packages
```bash
make stow
```

`make stow` picks packages for Linux or macOS by `uname`.
Package lists are in the Makefile.
Secrets and tool-generated files are not tracked.
