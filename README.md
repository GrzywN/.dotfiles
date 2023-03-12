# GrzywN's dotfiles

Uses GNU Stow – https://www.gnu.org/software/stow/

## WARNING:

- i3 is configured to use Alacritty, rofi and bumblebee-status by default. If you want to use something else, you need to change i3 config file.
- rofi requires rofi-emoji and rofi-calc.
- nvim requires packer.nvim (AUR nvim-packer-git).

## Usage: 

```bash
cd ~
git clone git@github.com:GrzywN/.dotfiles.git
cd .dotfiles
rm README.md
stow * 
```
