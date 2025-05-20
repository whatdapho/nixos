{ config, pkgs, lib, ... }:

{
  # ========== SYSTEM PACKAGES ==========
  environment.systemPackages = with pkgs; [
    # Core Utilities
    wget curl git neovim zsh
    htop neofetch btop unzip file killall
    
    # Fuzzy Finding
    fzf fd
    
    # Filesystem Tools
    tree ripgrep
    
    # Development
    glibcLocales
    
    # GNOME Applications
    gnome.gnome-tweaks gnome.gnome-terminal gnome.nautilus gnome.gnome-keyring
    
    # Shell Enhancements
    zsh-powerlevel10k bat
  ];

  # ========== SYSTEM CONFIGURATION ==========
  # Locale settings
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

  time.timeZone = "America/Toronto";

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true;
  };

  # ========== NETWORKING ==========
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # ========== SERVICES ==========
  services.openssh.enable = true;

  # GNOME Desktop
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # ========== NIX CONFIGURATION ==========
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

  # ========== SYSTEM SERVICES ==========
  services.printing.enable = true;

  # Sound configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ========== VIRTUALIZATION ==========
  virtualisation.docker.enable = true;

  # ========== SHELL CONFIGURATION ==========
  programs.zsh.enable = true;

  # ========== SECURITY ==========
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # System version (don't change this)
  system.stateVersion = "24.05";
}
