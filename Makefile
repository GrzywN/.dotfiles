OS := $(shell uname -s)
STOW := stow -d $(CURDIR) -t $(HOME)

COMMON_PACKAGES := agents alacritty claude fish git gnhf herdr nvim opencode scripts tmux
LINUX_PACKAGES := i3 i3blocks picom rofi
MACOS_PACKAGES := ghostty aerospace borders sketchybar

ifeq ($(OS),Darwin)
PACKAGES := $(COMMON_PACKAGES) $(MACOS_PACKAGES)
else
PACKAGES := $(COMMON_PACKAGES) $(LINUX_PACKAGES)
endif

.PHONY: stow unstow restow list

stow:
	$(STOW) $(PACKAGES)

unstow:
	$(STOW) -D $(PACKAGES)

restow:
	$(STOW) -R $(PACKAGES)

list:
	@printf "%s\n" $(PACKAGES)
