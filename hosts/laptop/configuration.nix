{ config, pkgs, ... }:

{
  # Laptop-specific configuration
  networking.hostName = "nixos-laptop";

  # Hardware configuration - you'll need to generate this during installation
  # Run: nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
  imports = [
    ./hardware-configuration.nix
  ];

  # Sway is pure Wayland - no X server needed

  # Laptop-specific settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };
}
