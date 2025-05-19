{ config, pkgs, lib, ... }:

let
  # Import Home Manager from the official release tarball
  home-manager = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
  }) {
    pkgs = pkgs;
  };
in

{
  # Import NixOS and Home Manager modules
  imports = [
    ./hardware-configuration.nix
    home-manager.nixos
  ];

  # Host and locale settings
  networking.hostName = "nixos";
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true;
  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Kernel and boot
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 1;
  };
  boot.tmp.cleanOnBoot = true;

  # Networking and firewall
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  # SSH
  services.openssh.enable = true;

  # GNOME Desktop
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # System packages (merged)
  environment.systemPackages = with pkgs; [
    # GNOME apps
    gnome.gnome-tweaks
    gnome.gnome-terminal
    gnome.nautilus
    gnome.gnome-keyring

    # CLI tools
    wget curl git neovim zsh firefox htop neofetch btop unzip file killall
    fzf
    zsh-powerlevel10k
    tree
  ];

  # User setup
  users.users.dhuynh = {
    isNormalUser = true;
    description = "Danny Huynh";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;

  # Printing
  services.printing.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Shell config
  programs.zsh.enable = true;

  # GPG Agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Sudo config
  security.sudo.wheelNeedsPassword = false;

  # Home Manager user config
  home-manager.users.dhuynh = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  # NixOS version
  system.stateVersion = "24.05";
}

