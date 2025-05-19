{ config, pkgs, lib, ... }:

{
  # Basic user configuration
  home.username = "dhuynh";
  home.homeDirectory = "/home/dhuynh";
  home.stateVersion = "24.05";

  # Shell configuration
  programs.zsh = {
    enable = true;
    # Basic zsh config that will work even without dotfiles
    initExtra = ''
      HISTFILE=~/.zsh_history
      HISTSIZE=10000
      SAVEHIST=10000
      setopt appendhistory
    '';
  };

  # Dotfiles management (only if files exist)
  home.file = let
    dotfilesDir = ./dotfiles;
  in lib.optionalAttrs (builtins.pathExists dotfilesDir) {
    ".zshrc".source = "${dotfilesDir}/.zshrc";
    ".p10k.zsh".source = "${dotfilesDir}/.p10k.zsh";
    ".gitconfig".source = "${dotfilesDir}/.gitconfig";
  };

  # Packages
  home.packages = with pkgs; [
    # Add your user packages here
    htop
    neovim
  ];
}
