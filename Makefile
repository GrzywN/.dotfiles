OS := $(shell uname -s)
STOW := stow --no-folding -d $(CURDIR) -t $(HOME)

COMMON_PACKAGES := agents alacritty claude git gnhf herdr nvim opencode proto scripts tmux
LINUX_PACKAGES := i3 i3blocks picom rofi
MACOS_PACKAGES := ghostty aerospace borders sketchybar

ifeq ($(OS),Darwin)
PACKAGES := $(COMMON_PACKAGES) $(MACOS_PACKAGES)
else
PACKAGES := $(COMMON_PACKAGES) $(LINUX_PACKAGES)
endif

.PHONY: stow unstow restow list plugins skills bootstrap doctor

stow:
	$(STOW) $(PACKAGES)

unstow:
	$(STOW) -D $(PACKAGES)

restow:
	$(STOW) -R $(PACKAGES)

list:
	@printf "%s\n" $(PACKAGES)

plugins:
	jq -r '.extraKnownMarketplaces[].source.repo' claude/.claude/settings.json | xargs -n1 claude plugin marketplace add
	jq -r '.enabledPlugins | to_entries[] | select(.value) | .key' claude/.claude/settings.json | while read plugin; do claude plugin install "$$plugin" || echo "skipped $$plugin"; done

skills:
	cd $(HOME) && pnpm dlx skills experimental_install

bootstrap:
	./bootstrap.sh

doctor:
	./setup/doctor.sh
