{ pkgs, lib, ... }:

let
  nerdFont = pkgs.nerd-fonts.jetbrains-mono;
in
{
  home.packages = [ nerdFont ];

  fonts.fontconfig.enable = pkgs.stdenv.isLinux;

  # macOS ignores fonts symlinked from the Nix store, so copy real files.
  home.activation.installNerdFont = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/Library/Fonts"
      run find ${nerdFont}/share/fonts -name '*.ttf' \
        -exec install -m 644 {} "$HOME/Library/Fonts/" \;
    ''
  );
}
