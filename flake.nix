{
  description = "Zalleous's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Desktop configuration with NVIDIA - minimal dev + gaming + multimedia
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/common.nix
          ./modules/sway.nix
          ./modules/nvidia.nix
          ./modules/gaming.nix
          ./modules/development-minimal.nix
          ./modules/multimedia.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zalleous = import ./home/home-minimal.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # Laptop configuration - minimal for programming
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/common.nix
          ./modules/sway.nix
          ./modules/laptop.nix
          ./modules/development-minimal.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zalleous = import ./home/home-minimal.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
