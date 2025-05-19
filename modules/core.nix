{ config, pkgs, ... }:

{
  # Shared across all machines
  environment.systemPackages = with pkgs; [
    vim wget curl git
    htop btop
  ];

  # Standard services for all hosts
  programs.zsh.enable = true;
  services.openssh.enable = true;
}
