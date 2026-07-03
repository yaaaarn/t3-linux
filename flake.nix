{
  description = "tung tung tung linux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        systems = import inputs.systems;

        perSystem = { config, pkgs, system, ... }: {
          packages.default = self.nixosConfigurations.default.config.system.build.isoImage;
        };

        flake.nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            inputs.home-manager.nixosModules.home-manager
            inputs.mangowc.nixosModules.mango
            ./modules/nixos.nix
          ];
        };
      }
    );
}
