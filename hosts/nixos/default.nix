{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
  ];

  # REQUIRED: Must exactly match your hostname
  networking.hostName = "nixos";

  # REQUIRED: Must match your running OS version
  system.stateVersion = "24.05";

  # Enable flakes permanently
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # Optional but recommended for better performance
    auto-optimise-store = true;
  };

  # Host-specific customizations
  boot.loader.systemd-boot.enable = true;
  services.openssh.enable = true;

  # Optional: Enable garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
