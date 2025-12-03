{ config, pkgs, ... }:

{
  # NVIDIA Driver Configuration
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Enable power management (can help with stability)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the open source kernel module (not nouveau)
    # Only available from driver 515.43.04+
    # Set to false if you have issues
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version
    # Use "stable" for most users, "beta" for latest features
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Graphics settings for NVIDIA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Optionally enable nvidia-drm modeset
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Environment variables for NVIDIA with Wayland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix for cursor issues on some setups
  };
}
