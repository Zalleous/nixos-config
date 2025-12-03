# Customization Guide

This guide covers everything in your NixOS configuration that you might want to customize before or after installation.

## Essential Changes (Do Before Installing)

### 1. User Information
**File:** `home/home.nix`

```nix
# Line 17: Update your Git email
userEmail = "your-email@example.com";  # <-- CHANGE THIS
```

### 2. Timezone
**File:** `modules/common.nix`

```nix
# Line 11: Change to your timezone
time.timeZone = "America/New_York";  # <-- CHANGE THIS
```

Common timezones:
- US East: `America/New_York`
- US West: `America/Los_Angeles`
- US Central: `America/Chicago`
- US Mountain: `America/Denver`
- UK: `Europe/London`
- EU Central: `Europe/Berlin`
- Find yours: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

### 3. Username
**Files:** `flake.nix`, `home/home.nix`, `modules/common.nix`, `modules/development.nix`, `modules/laptop.nix`

Current username: `zalleous`

If you want to change it, search and replace `zalleous` in all files with your preferred username.

## Appearance & Desktop

### Terminal (Alacritty)
**File:** `home/home.nix` (starting line 202)

```nix
# Change font
font.normal.family = "JetBrainsMono Nerd Font";  # Try: FiraCode, Hack, etc.
font.size = 12;  # Adjust size

# Change opacity
window.opacity = 0.9;  # 0.0 (transparent) to 1.0 (opaque)

# Change colors
# Tokyo Night is currently set - search for other Alacritty themes online
```

### Hyprland (Window Manager)
**File:** `home/home.nix` (starting line 50)

```nix
# Monitor configuration (line ~53)
monitor = ",preferred,auto,1";
# For specific setup: "DP-1,1920x1080@144,0x0,1"

# Gaps (line ~83)
gaps_in = 5;   # Inner gaps between windows
gaps_out = 10; # Outer gaps from screen edges

# Border colors (line ~86-87)
"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
"col.inactive_border" = "rgba(595959aa)";

# Rounding (line ~94)
rounding = 10;  # Corner roundness in pixels

# Blur (line ~95-99)
blur.enabled = true;
blur.size = 3;
blur.passes = 1;

# Animations (line ~107-118)
# Set enabled = false to disable all animations
animations.enabled = true;
```

### Keybindings
**File:** `home/home.nix` (line ~130)

Current main keybinds:
- `SUPER + Return` - Terminal
- `SUPER + D` - App launcher
- `SUPER + Q` - Close window
- `SUPER + E` - File manager
- `SUPER + F` - Fullscreen
- `SUPER + L` - Lock screen

Change `$mod = "SUPER"` to `$mod = "ALT"` if you prefer Alt key.

### Themes & Colors
**File:** `home/home.nix`

```nix
# GTK theme (line ~259)
theme.name = "Adwaita-dark";  # Try: "Adwaita", "Arc-Dark", etc.

# Icon theme (line ~263)
iconTheme.name = "Adwaita";   # Try: "Papirus", "Numix", etc.

# Cursor (line ~276)
name = "Bibata-Modern-Classic";  # Try: "Adwaita", "Breeze", etc.
size = 24;
```

### ZSH Shell
**File:** `home/home.nix` (line ~30)

```nix
# Theme (line ~44)
theme = "robbyrussell";  # Try: agnoster, powerlevel10k, etc.

# Plugins (line ~45)
plugins = [ "git" "sudo" "docker" "kubectl" ];
# Add more: "zoxide", "fzf", "python", "rust", etc.

# Custom aliases (line ~37-40)
shellAliases = {
  ll = "ls -la";
  # Add your own aliases here
};
```

## Hardware Configuration

### Desktop (NVIDIA)
**File:** `modules/nvidia.nix`

```nix
# Line 14: Open source drivers (experimental)
open = false;  # Set to true for open-source NVIDIA drivers

# Line 23: Driver version
package = config.boot.kernelPackages.nvidiaPackages.stable;
# Options: stable, beta, legacy_470, legacy_390
```

### Laptop (Power Management)
**File:** `modules/laptop.nix`

```nix
# CPU governor (line ~30-31)
CPU_SCALING_GOVERNOR_ON_AC = "performance";
CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

# Battery thresholds (line ~41-42) - for battery health
START_CHARGE_THRESH_BAT0 = 40;  # Start charging at 40%
STOP_CHARGE_THRESH_BAT0 = 80;   # Stop charging at 80%
```

## Software & Packages

### Remove Unwanted Software

To remove categories of software, edit `flake.nix` and comment out module imports:

```nix
# Line ~22-26 for desktop, ~43-47 for laptop
modules = [
  # ./modules/gaming.nix      # Comment out to remove gaming
  # ./modules/multimedia.nix  # Comment out to remove multimedia
  ./modules/development.nix    # Keep this one
];
```

### Development Tools
**File:** `modules/development.nix`

```nix
# Remove languages you don't use (line ~24-50)
# Comment out what you don't need:
# python311
# nodejs_20
# rustc
# go
# jdk17

# Database (line ~110-118) - commented by default
# Uncomment to enable PostgreSQL
```

### Gaming
**File:** `modules/gaming.nix`

```nix
# Steam (line ~7-12)
programs.steam.enable = true;  # Set to false to disable

# Emulators (line ~41)
retroarch  # Remove if you don't need it

# PS4 controller (line ~65-76)
# Already configured - udev rules are commented
# Uncomment if you need better PS4 controller support
```

### Multimedia
**File:** `modules/multimedia.nix`

Remove any packages you don't need (line ~6-61):
- Video editors: kdenlive, davinci-resolve, obs-studio
- Audio: audacity, ardour
- Graphics: gimp, inkscape, krita
- Office: libreoffice-fresh
- Communication: slack, telegram-desktop, zoom-us

### Browser Choice
**File:** `modules/common.nix`

```nix
# Line ~67-68
firefox
google-chrome  # Or add: brave, chromium, microsoft-edge
```

## Display Manager & Login

### Auto-login (Optional)
**File:** Create `modules/autologin.nix`

```nix
{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  };
}
```

Then add `./modules/autologin.nix` to your flake.nix modules list.

## Networking

### Hostname
**Files:** `hosts/desktop/configuration.nix` and `hosts/laptop/configuration.nix`

```nix
# Line 5 in each file
networking.hostName = "nixos-desktop";  # Change to your preference
networking.hostName = "nixos-laptop";
```

### Firewall
**File:** `modules/common.nix` - Add after line 9:

```nix
# Open specific ports
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 80 443 ];  # HTTP, HTTPS
  allowedUDPPorts = [ ];
};
```

### WireGuard VPN
**Already enabled!** WireGuard is configured in `modules/common.nix` (lines 11-12)

To set up a WireGuard connection, create a config file:

**Option 1: Using wg-quick**
```bash
# After installing NixOS, create /etc/wireguard/wg0.conf
sudo nano /etc/wireguard/wg0.conf
```

Add your WireGuard config (get from your VPN provider):
```ini
[Interface]
PrivateKey = YOUR_PRIVATE_KEY
Address = 10.0.0.2/24

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = vpn.example.com:51820
AllowedIPs = 0.0.0.0/0
```

Then enable:
```bash
sudo systemctl enable --now wg-quick@wg0
```

**Option 2: NetworkManager integration**
NetworkManager has built-in WireGuard support - you can add VPN connections through the GUI or nmcli.

**For Mullvad/commercial VPNs:**
Most VPN providers have their own apps or provide WireGuard configs. Download configs and use wg-quick or import into NetworkManager.

## Boot Configuration

### Bootloader Timeout
**File:** `modules/common.nix` - Add after line 7:

```nix
boot.loader.timeout = 3;  # Seconds to show boot menu
```

### Kernel
**File:** `modules/common.nix` - Add after line 5:

```nix
# Use latest kernel
boot.kernelPackages = pkgs.linuxPackages_latest;
# Or LTS: pkgs.linuxPackages
# Or Zen (gaming optimized): pkgs.linuxPackages_zen
```

## System Settings

### Swap File Size
**File:** `modules/common.nix` - Add after line 90:

```nix
# Create swap file (useful if you don't have swap partition)
swapDevices = [{
  device = "/swapfile";
  size = 8192;  # Size in MB (8GB)
}];
```

### Automatic Updates
**File:** `modules/common.nix` - Add after line 52:

```nix
# Auto-upgrade (use with caution)
system.autoUpgrade = {
  enable = false;  # Set to true to enable
  allowReboot = false;
  dates = "weekly";
};
```

## Docker vs Podman

**File:** `modules/development.nix` (line ~93-108)

Currently using Docker. To switch to Podman:

```nix
# Disable Docker (comment out lines 93-100)
# virtualisation.docker = {
#   enable = true;
#   enableOnBoot = true;
# };

# Enable Podman (uncomment lines 102-108)
virtualisation.podman = {
  enable = true;
  dockerCompat = true;
  defaultNetwork.settings.dns_enabled = true;
};
```

## Additional Tools Already Included

- **Zoxide** - Smart directory navigation (`z` command)
- **Oh-My-Zsh** - Enhanced shell with plugins
- **Git** with GitHub CLI (`gh`)
- **Docker** - Container runtime
- **Waybar** - Status bar
- **Dunst** - Notifications
- **Wofi** - Application launcher

## Color Schemes

To change the entire color scheme, you'll need to update:
1. `home/home.nix` - Alacritty colors (line ~223-254)
2. `home/home.nix` - Hyprland border colors (line ~86-87)
3. `home/home.nix` - GTK theme (line ~259-268)

Popular color schemes:
- Tokyo Night (current)
- Catppuccin
- Nord
- Dracula
- Gruvbox
- One Dark

Search for "Alacritty [scheme name]" and "Hyprland [scheme name]" to find color configs.

## Performance Tuning

### For Gaming Desktop
**File:** `modules/common.nix` - Add after line 5:

```nix
boot.kernelPackages = pkgs.linuxPackages_zen;  # Gaming-optimized kernel
```

### For Laptop Battery Life
Already configured in `modules/laptop.nix` with TLP and powersaving settings.

## Getting Help

- NixOS Options: https://search.nixos.org/options
- Home Manager Options: https://nix-community.github.io/home-manager/options.xhtml
- Hyprland Wiki: https://wiki.hyprland.org/
- NixOS Discourse: https://discourse.nixos.org/

## Testing Changes

After editing, validate your config:
```bash
# From WSL before installing
wsl -d NixOS -- bash -c "cd /mnt/c/Users/Zachary/code/nixos-config && nix flake check --extra-experimental-features 'nix-command flakes' --no-build"

# After installing NixOS
sudo nixos-rebuild test --flake ~/.config/nixos#desktop  # or #laptop
# If it works, make it permanent:
sudo nixos-rebuild switch --flake ~/.config/nixos#desktop
```
