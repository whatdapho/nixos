{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix  # Hardware specifics
    ../../modules/core.nix        # Shared base config (create this next)
  ];

  # REQUIRED: Must exactly match your hostname
  networking.hostName = "nixos"; 

  # REQUIRED: Must match your running OS version
  system.stateVersion = "24.05"; 

  # Host-specific customizations go here:
  boot.loader.systemd-boot.enable = true;
  services.openssh.enable = true;
}
