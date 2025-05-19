{
  description = "My NixOS configurations";

  inputs = {
    # Stable NixOS 24.05 (matches your running system)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager (release-24.05 branch)
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Utility functions
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, flake-utils, ... }@inputs:
    let
      # System architecture (x86_64 unless you have ARM devices)
      system = "x86_64-linux";

      # Common modules shared across all machines
      commonModules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dhuynh = import ./users/dhuynh.nix;
        }
        ./modules/core.nix  # Your shared base configuration
      ];
    in {
      nixosConfigurations = {
        # Primary machine (matches your actual hostname 'nixos')
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ./hosts/nixos/default.nix
            # Intel-specific optimizations (remove if not applicable)
            nixos-hardware.nixosModules.common-cpu-intel
          ];
        };

        # Example server configuration
        myserver = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ./hosts/myserver/default.nix
          ];
        };
      };

      # Optional: Development shells
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra  # Nix formatter
          statix     # Nix linter
        ];
      };
    };
}
