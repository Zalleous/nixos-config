{ config, pkgs, ... }:

{
  # Laptop-specific configuration
  networking.hostName = "nixos-laptop";

  # Hardware configuration - you'll need to generate this during installation
  # Run: nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable X11 for laptop (no NVIDIA driver needed)
  services.xserver = {
    enable = true;
  };

  # Laptop-specific settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };
}
