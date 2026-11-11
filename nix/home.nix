{ ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./fonts.nix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
