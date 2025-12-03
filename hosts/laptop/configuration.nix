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

  # Intel graphics - early KMS to avoid CRTC conflicts
  boot.kernelParams = [ "i915.modeset=1" ];
  boot.initrd.kernelModules = [ "i915" ];

  # Enable Intel graphics driver
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];

  # Laptop-specific settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };
}
