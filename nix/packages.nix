{ pkgs, lib, ... }:

let
  languageServers = with pkgs; [
    lua-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    typescript-language-server
    typescript
    astro-language-server
    vue-language-server
    intelephense
    pyright
    harper
  ];

  cliTools = with pkgs; [
    ansible
    curl
    fd
    fzf
    gcc
    gh
    git
    jq
    neovim
    proto
    ripgrep
    stow
    tmux
    tree-sitter
  ];

  linuxTools = with pkgs; [ xclip ];

  macosTools = with pkgs; [ colima docker-client docker-compose ];
in
{
  home.packages =
    languageServers
    ++ cliTools
    ++ lib.optionals pkgs.stdenv.isLinux linuxTools
    ++ lib.optionals pkgs.stdenv.isDarwin macosTools;
}
