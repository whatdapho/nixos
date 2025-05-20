{ config, pkgs, lib, ... }:

{
  # Host-specific settings
  networking.hostName = "nixos";
  system.stateVersion = "24.05";

  # Bootloader configuration
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = false;
      support32bit = false;
    };
  };

  # User configuration
  users.users.dhuynh = {
    isNormalUser = true;
    description = "Danny Huynh";
    group = "dhuynh";
    extraGroups = ["wheel" "networkmanager" "docker"];
    home = "/home/dhuynh";
    shell = pkgs.zsh;
  };
  users.groups.dhuynh = {};
}
