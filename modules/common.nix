{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # WireGuard VPN support
  networking.wireguard.enable = true;

  # Timezone and locale
  time.timeZone = "America/Toronto"; # Change this to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define user account
  users.users.zalleous = {
    isNormalUser = true;
    description = "Zalleous";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "render" "seat" ];
    shell = pkgs.zsh;
  };

  # Enable ZSH system-wide
  programs.zsh.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (needed for many apps including Steam, Discord, etc.)
  nixpkgs.config.allowUnfree = true;

  # System packages that should be available everywhere
  environment.systemPackages = with pkgs; [
    # Essential tools
    vim
    wget
    curl
    git
    htop
    btop
    unzip
    zip
    tree

    # File managers
    xfce.thunar

    # Browsers
    firefox

    # System utilities
    killall
    pciutils
    usbutils

    # VPN
    wireguard-tools  # wg, wg-quick commands
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Firmware updates
  services.fwupd.enable = true;

  # System state version
  system.stateVersion = "24.05";
}
