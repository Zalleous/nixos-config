{ config, pkgs, ... }:

{
  # Sway Wayland Compositor - lightweight and stable

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      # Wayland utilities
      wayland
      wl-clipboard

      # Sway utilities
      swaylock
      swayidle
      swaybg

      # Application launcher
      wofi

      # Status bar
      waybar

      # Notifications
      dunst
      libnotify

      # Screenshots
      grim
      slurp
      swappy

      # Terminal
      alacritty

      # File manager
      xfce.thunar

      # Additional utilities
      wlogout
      brightnessctl
    ];
  };

  # Enable required services
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
    jetbrains-mono
  ];
}
