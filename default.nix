{ config, pkgs, lib, ... }:

let
  # Import Home Manager from the official release tarball with pkgs passed in
  home-manager = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  }) { pkgs = pkgs; };
in

{
  # Import NixOS and Home Manager modules
  imports = [
    ./hardware-configuration.nix
    home-manager.nixos       # Correct module to enable Home Manager integration with NixOS
  ];

  # Hostname and Locale settings
  networking.hostName = "nixos";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true;
  };

  # Boot loader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Kernel settings
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 1;
  };
  boot.tmp.cleanOnBoot = true;

  # Networking services
  networking.networkmanager.enable = true;

  # SSH service and firewall rules
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # User definitions
  users.users.dhuynh = {
    isNormalUser = true;
    description = "Danny Huynh";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;

  # Hardware services
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Virtualization
  virtualisation.docker.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget curl git neovim zsh firefox htop neofetch btop unzip file killall gnome.gnome-keyring fzf zsh-powerlevel10k
  ];

  # Shell and GPG agent programs
  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Security: sudo settings
  security.sudo.wheelNeedsPassword = false;

  # Enable Home Manager for user 'dhuynh' by importing home.nix
  home-manager.users.dhuynh = import ./home.nix;
  
  # Set backup extension for conflicting files
  home-manager.backupFileExtension = "backup"; 

  # Set system state version to match NixOS release
  system.stateVersion = "24.05";
}

