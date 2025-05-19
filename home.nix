# ~/GitHub/nixos-config/home.nix

{ config, pkgs, ... }:

{
  home.stateVersion = "24.05"; # Make sure this matches your NixOS version (e.g., "23.11")

  home.packages = with pkgs; [
    # Add any user-specific packages you want installed
    htop
    neofetch
    tmux
  ];

  # --- Shell Configuration (Zsh) ---
  programs.zsh = {
    enable = true;
    enableOhMyZsh = true;
    ohMyZsh.theme = "robbyrussell";
    # You can configure plugins here too, e.g.:
    # ohMyZsh.plugins = [ "git" "z" "fzf" ];

    # Point to your custom .zshrc
    dotDir = ".config/zsh"; # Home Manager can create this directory for you
    # If using dotDir, the main config goes here:
    # initExtra = ''
    #   source "${config.home.homeDirectory}/.p10k.zsh"
    # '';
    # Or, if you want full control of .zshrc:
    # home.file.".zshrc".source = ./dotfiles/.zshrc;

    # Point to your custom .p10k.zsh
    # This assumes .p10k.zsh is sourced by your .zshrc if you manage both explicitly
    home.file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
  };

  # --- Git Configuration ---
  programs.git = {
    enable = true;
    userName = "Danny Huynh";
    userEmail = "danny@nextsemi.com";
    extraConfig = {
      # Add any extra git configs you have in .gitconfig
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
    # If you have custom config beyond simple options, you can source it:
    # home.file.".gitconfig".source = ./dotfiles/.gitconfig;
  };

  # --- Neovim Configuration (if you have one) ---
  # If you manage neovim through Home Manager's specific options:
  # programs.neovim = {
  #  enable = true;
  #   # You can configure plugins, options, etc., directly here
  #   # For a complete init.vim:
  #   # extraConfig = ''
  #   #   source ${./dotfiles/nvim/init.vim}
  #   # '';
  # };
  # If you just want to copy your existing nvim config directory:
  # home.file.".config/nvim".source = ./dotfiles/nvim; # Copies the whole directory

  # --- PulseAudio Configuration (if you customized it) ---
  # services.pulseaudio = {
  #   enable = true;
  #   # If you copy the entire directory:
  #   # home.file.".config/pulse".source = ./dotfiles/pulse;
  # };

  # --- SSH Configuration (for known_hosts, config) ---
  # Home Manager can manage ~/.ssh/config and known_hosts, but NOT your private keys (`id_ed25519`).
  # programs.ssh = {
  #   enable = true;
  #   # If you want to manage your ssh config file:
  #   # extraConfig = ''
  #   #   Host github.com
  #   #     User git
  #   #     IdentityFile ~/.ssh/id_ed25519
  #   # '';
  #   # If you want to manage known_hosts:
  #   # knownHosts = {
  #   #   "github.com" = {
  #   #     keys = [
  #   #       "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkhtFVikzDKkmooBHFLkOj"
  #   #       # ... paste other public keys from known_hosts or trusted sources
  #   #     ];
  #   #   };
  #   # };
  # };

  # You can continue adding many more program configurations here!
}
