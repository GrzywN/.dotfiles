{ pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    PROTO_HOME = "$HOME/.proto";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.proto/shims"
    "$HOME/.proto/bin"
    "$HOME/.opencode/bin"
  ];

  home.shellAliases = {
    ll = "ls -la";
    todo = "nvim ~/todo.md";
    vim = "nvim";
  };

  programs.bash.enable = pkgs.stdenv.isLinux;
  programs.zsh.enable = pkgs.stdenv.isDarwin;

  programs.starship.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "cd" ];
  };
}
