{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
  ];

  # System identification
  networking.hostName = "nixos";
  system.stateVersion = "24.05";

  # Locale settings (fixes the perl warnings)
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = ["en_CA.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];
    extraLocaleSettings = {
      LC_ADDRESS = "en_CA.UTF-8";
      LC_IDENTIFICATION = "en_CA.UTF-8";
      LC_MEASUREMENT = "en_CA.UTF-8";
      LC_MONETARY = "en_CA.UTF-8";
      LC_NAME = "en_CA.UTF-8";
      LC_NUMERIC = "en_CA.UTF-8";
      LC_PAPER = "en_CA.UTF-8";
      LC_TELEPHONE = "en_CA.UTF-8";
      LC_TIME = "en_CA.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "America/Toronto";

  # Nix configuration
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Boot configuration for BIOS/MBR systems
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";  # Your main disk
      useOSProber = true;   # If dual-booting
    };
    # Explicitly disable EFI bootloaders
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = lib.mkForce false;
  };

  # Services
  services.openssh.enable = true;

  # User configuration
  users.users.dhuynh = {
    isNormalUser = true;
    group = "dhuynh";
    extraGroups = ["wheel"];
    home = "/home/dhuynh";
    shell = pkgs.zsh;
  };

  users.groups.dhuynh = {};

  # Home Manager
  environment.systemPackages = with pkgs; [ 
    home-manager
    glibcLocales  # For complete locale support
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dhuynh = import ../../users/dhuynh.nix;
  };
}
