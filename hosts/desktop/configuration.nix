{ config, pkgs, ... }:

{
  # Desktop-specific configuration
  networking.hostName = "nixos-desktop";

  # Hardware configuration - you'll need to generate this during installation
  # Run: nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
  imports = [
    ./hardware-configuration.nix
  ];

  # Desktop-specific services
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  # Additional desktop settings can go here
}
