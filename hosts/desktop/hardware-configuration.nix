# This is a placeholder hardware configuration for your desktop.
# During NixOS installation, run this command to generate the real hardware config:
# nixos-generate-config --show-hardware-config > /etc/nixos/hosts/desktop/hardware-configuration.nix
#
# Then copy it to your config repo.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # You'll need to fill this in based on your actual hardware
  # The real hardware-configuration.nix will include:
  # - File systems configuration
  # - Boot loader settings
  # - Kernel modules
  # - CPU microcode
  # - Swap configuration

  # Placeholder - replace with your actual configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
