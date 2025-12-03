{ config, pkgs, inputs, ... }:

{
  # Hyprland Wayland Compositor Configuration

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # Enable required services for Hyprland
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Polkit for authentication
  security.polkit.enable = true;

  # Packages needed for Hyprland ecosystem
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wayland
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlr-randr

    # Hyprland utilities
    hyprpaper         # Wallpaper daemon
    hypridle          # Idle daemon
    hyprlock          # Lock screen
    hyprpicker        # Color picker

    # Application launcher
    wofi              # Wayland native launcher
    rofi-wayland      # Rofi for Wayland

    # Status bar
    waybar            # Highly customizable bar

    # Notifications
    dunst             # Notification daemon
    libnotify         # Send notifications

    # Screenshots
    grim              # Screenshot tool
    slurp             # Region selector
    swappy            # Screenshot editor

    # Terminal emulator
    alacritty         # GPU accelerated terminal

    # Additional utilities
    cliphist          # Clipboard manager
    wlogout           # Logout menu
    swayosd           # OSD for brightness/volume
  ];

  # Environment variables for Hyprland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Hint electron apps to use Wayland
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Fonts for better UI
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
}
