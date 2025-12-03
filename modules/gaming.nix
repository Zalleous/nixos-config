{ config, pkgs, ... }:

{
  # Gaming configuration

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Enable GameMode for performance optimization
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Launchers
    lutris
    heroic
    bottles

    # Compatibility layers
    wine
    winetricks
    wine64

    # Emulators
    retroarch

    # Performance monitoring
    mangohud
    goverlay

    # Discord for gaming communication
    discord
    vesktop  # Alternative Discord client with better Wayland support

    # Game utilities
    gamemode
    gamescope

    # Controllers
    antimicrox  # Controller mapping
  ];

  # Enable MangoHud globally
  environment.sessionVariables = {
    MANGOHUD = "1";
  };

  # Enable PS4 controller support
  # PS4 controllers work out of the box with the hid-sony kernel module
  # Additional tools for better support
  boot.kernelModules = [ "hid-sony" ];

  # Optional: uncomment for additional DS4 features
  # services.udev.extraRules = ''
  #   # PS4 DualShock 4 controller over USB
  #   KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
  #   # PS4 DualShock 4 controller over Bluetooth
  #   KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
  # '';
}
