
i{ config, pkgs, lib, ... }:
{
  # Only specify username (let HM auto-detect homeDirectory)
  home.username = "dhuynh";
  
  # Required version lock
  home.stateVersion = "24.05";

  # Shell configuration
  programs.zsh = {
    enable = true;
    # Add your zsh config here instead of via dotfiles if possible
    initExtra = builtins.readFile ./dotfiles/.zshrc;
  };

  # Dotfile management (simplified)
  home.file = {
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".gitconfig".source = ./dotfiles/.gitconfig;
  };

  # User packages
  home.packages = with pkgs; [
    # List your user packages here
  ];
}
