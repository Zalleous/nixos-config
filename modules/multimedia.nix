{ config, pkgs, ... }:

{
  # Multimedia applications and tools

  environment.systemPackages = with pkgs; [
    # Video players
    vlc
    mpv

    # Video editing
    # kdenlive  # Temporarily disabled - package issue
    davinci-resolve  # Professional video editor
    obs-studio       # Streaming and recording

    # Audio editing
    audacity
    ardour          # DAW (Digital Audio Workstation)

    # Image editing
    gimp            # Raster graphics editor
    inkscape        # Vector graphics editor
    krita           # Digital painting

    # Photography
    darktable       # Photo workflow
    rawtherapee     # RAW processor

    # Media converters
    ffmpeg
    handbrake

    # Audio tools
    pavucontrol     # PulseAudio volume control
    easyeffects     # Audio effects for PipeWire
    helvum          # PipeWire patchbay

    # Screen recording
    simplescreenrecorder
    peek            # GIF recorder

    # Office suite
    libreoffice-fresh

    # PDF tools
    okular          # PDF viewer/editor
    evince          # Document viewer
    xournalpp       # PDF annotation

    # Note-taking
    obsidian        # Knowledge base
    notion-app-enhanced

    # Communication
    slack
    telegram-desktop
    zoom-us

    # Music
    spotify

    # Image viewers
    feh
    imv
  ];

  # OBS Studio plugins
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };
}
