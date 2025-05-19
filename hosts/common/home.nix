{ config, pkgs, lib, ... }:

{
  # Username and home directory
  home.username = "dhuynh";
  home.homeDirectory = "/home/dhuynh";

  # Required: Home Manager state version (match your NixOS version)
  home.stateVersion = "24.05";

  # Enable zsh shell
  programs.zsh.enable = true;

  # Link your dotfiles from your repo
  home.file = {
    ".zshrc".source = ./dotfiles/.zshrc;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".gitconfig".source = ./dotfiles/.gitconfig;
  };

  # Add powerlevel10k package for the user
  home.packages = with pkgs; [
  ];

  # Remove the invalid 'promptInit' attribute completely
}

