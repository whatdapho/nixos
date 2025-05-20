{ config, pkgs, lib, ... }:

{
  # ========== BOOTLOADER CONFIGURATION ==========
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";    # Replace with your actual boot device
      useOSProber = true;     # For dual-boot detection
      efiSupport = false;     # Explicitly disable EFI support
    };
    efi = {
      canTouchEfiVariables = lib.mkForce false;  # Force-disable EFI
    };
    systemd-boot.enable = false;  # Disable systemd-boot
  };

  # ========== SYSTEM IDENTITY ==========
  networking.hostName = "nixos";
  system.stateVersion = "24.05";  # Don't change this

  # ========== USER CONFIGURATION ==========
  users.users.dhuynh = {
    isNormalUser = true;
    description = "Danny Huynh";
    group = "dhuynh";
    extraGroups = ["wheel" "networkmanager" "docker"];  # User privileges
    home = "/home/dhuynh";
    shell = pkgs.zsh;
  };
  users.groups.dhuynh = {};

  # ========== OPTIONAL SETTINGS ==========
  # Uncomment if you need these:
  # boot.kernelParams = [ "nomodeset" ];  # For some Nvidia cards
  # boot.initrd.kernelModules = [ "amdgpu" ];  # For AMD GPU
}
