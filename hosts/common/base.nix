{ config, pkgs, lib, ... }:

let
  # Import Home Manager from the official release tarball
  home-manager = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  }) { inherit pkgs; };
in

{
  # ========== SYSTEM PACKAGES ==========
  environment.systemPackages = with pkgs; [
    # ----- Core Utilities -----
    wget       # CLI download utility
    curl       # Powerful HTTP client
    git        # Version control system
    neovim     # Modern Vim fork
    zsh        # Z shell interpreter
    firefox    # Web browser
    htop       # Interactive process viewer
    neofetch   # System information tool
    btop       # Resource monitor (better htop)
    unzip      # Archive extraction utility
    file       # File type identification
    killall    # Process killing utility

    # ----- Fuzzy Finding -----
    fzf        # Fuzzy finder for CLI
    fd         # Fast alternative to find

    # ----- Filesystem Tools -----
    tree       # Directory listing in tree format
    ripgrep    # Fast grep alternative

    # ----- Development -----
    home-manager  # User environment manager
    glibcLocales  # Locale support for development

    # ----- GNOME Applications -----
    gnome.gnome-tweaks    # GNOME customization tool
    gnome.gnome-terminal  # GNOME terminal emulator
    gnome.nautilus        # GNOME file manager
    gnome.gnome-keyring   # Password management system

    # ----- Shell Enhancements -----
    zsh-powerlevel10k  # Zsh theme framework
    bat                # Cat clone with syntax highlighting
  ];

  # ========== SYSTEM CONFIGURATION ==========
  # Host and locale settings
  networking.hostName = "nixos";
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true;
  };

  # ========== BOOT CONFIGURATION ==========
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # Kernel settings
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;  # Reduce swap usage
    "kernel.sysrq" = 1;    # Enable magic SysRq keys
  };
  boot.tmp.cleanOnBoot = true;

  # ========== NETWORKING ==========
  networking.networkmanager.enable = true;  # Network management
  networking.firewall.allowedTCPPorts = [ 22 ];  # SSH

  # ========== SERVICES ==========
  services.openssh.enable = true;  # Enable SSH server

  # GNOME Desktop
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts        # Google's font family
    noto-fonts-cjk    # Asian language support
    noto-fonts-emoji  # Color emoji support
  ];

  # ========== USER CONFIGURATION ==========
  users.users.dhuynh = {
    isNormalUser = true;
    description = "Danny Huynh";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;

  # ========== SYSTEM SERVICES ==========
  services.printing.enable = true;  # CUPS printing support

  # Sound configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ========== VIRTUALIZATION ==========
  virtualisation.docker.enable = true;  # Docker container support

  # ========== SHELL CONFIGURATION ==========
  programs.zsh.enable = true;  # Enable Zsh system-wide

  # ========== SECURITY ==========
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;  # Use GPG for SSH authentication
  };

  security.sudo.wheelNeedsPassword = false;  # Passwordless sudo for wheel group

  # ========== HOME MANAGER ==========
  home-manager.users.dhuynh = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  # System version (don't change this)
  system.stateVersion = "24.05";
}
