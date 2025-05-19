{ config, pkgs, lib, ... }:

{
  # ========== IMPORTS ==========
  imports = [
    ./hardware-configuration.nix  # Hardware-specific settings
    ../../modules/core.nix        # Additional custom modules
  ];

  # ========== SYSTEM IDENTITY ==========
  networking.hostName = "nixos";  # Hostname for this machine
  system.stateVersion = "24.05";  # Don't change this

  # ========== LOCALE SETTINGS ==========
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
    font = "Lat2-Terminus16";  # Console font
    keyMap = "us";             # Keyboard layout
  };

  time.timeZone = "America/Toronto";  # System timezone

  # ========== NIX CONFIGURATION ==========
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];  # Enable new Nix features
      auto-optimise-store = true;  # Automatically optimize storage
    };
    gc = {
      automatic = true;    # Automatic garbage collection
      dates = "weekly";    # Run weekly
      options = "--delete-older-than 7d";  # Keep 7 days of generations
    };
  };

  # ========== BOOTLOADER ==========
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";   # Disk to install GRUB
      useOSProber = true;    # Detect other OSes for dual-boot
    };
    systemd-boot.enable = false;  # Disable UEFI bootloader
    efi.canTouchEfiVariables = lib.mkForce false;  # Disable EFI
  };

  # ========== USER CONFIGURATION ==========
  users.users.dhuynh = {
    isNormalUser = true;
    group = "dhuynh";
    extraGroups = ["wheel"];  # Grant sudo access
    home = "/home/dhuynh";
    shell = pkgs.zsh;
  };

  users.groups.dhuynh = {};

  # ========== HOME MANAGER ==========
  home-manager = {
    useGlobalPkgs = true;     # Use system packages
    useUserPackages = true;   # Allow user-specific packages
    users.dhuynh = import ../../users/dhuynh.nix;  # User config
  };
}
