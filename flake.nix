{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, flake-utils, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      
      commonModules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dhuynh = import ./users/dhuynh.nix;
        }
      ];
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ./hosts/nixos/default.nix
            nixos-hardware.nixosModules.common-cpu-intel
          ];
        };
      };

      # Fixed devShells section
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          statix
        ];
      };
    };
}
