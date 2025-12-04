# Laptop Installation Guide

This guide documents the actual installation process on a ThinkPad T480 with lessons learned.

## Hardware Specs

- **Model**: ThinkPad T480
- **GPU**: Intel UHD Graphics 620
- **Storage**: NVMe SSD (nvme0n1)
- **WiFi**: Requires `wlp3s0` interface

## Pre-Installation Steps

### 1. Boot from USB

Choose: **NixOS Installer GNOME (Linux 6.17.9)** - NOT LTS
- Latest kernel has better hardware support for modern laptops

### 2. Partition NVMe Drive

**IMPORTANT**: Use `nvme0n1` not `sda` (sda is your USB key!)

```bash
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary 512MiB 100%

# Format
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2

# Mount
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 3. Generate Hardware Config

```bash
sudo nixos-generate-config --root /mnt
```

### 4. Connect to WiFi

**CRITICAL**: WiFi interface might be DOWN by default!

```bash
# Check if WiFi is blocked
rfkill list
sudo rfkill unblock wifi

# Bring up WiFi interface (usually wlp3s0 on T480)
ip link show  # Find your WiFi interface name
sudo ip link set wlp3s0 up

# Connect using nmtui
nmtui
```

### 5. Clone Config and Install

```bash
# Install git
sudo nix-shell -p git

# Save hardware config
sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix

# Clone repo
sudo rm -rf /mnt/etc/nixos
git clone https://github.com/Zalleous/nixos-config.git /mnt/etc/nixos

# Copy hardware config
sudo cp /tmp/hardware-configuration.nix /mnt/etc/nixos/hosts/laptop/hardware-configuration.nix

# Install
sudo nixos-install --flake /mnt/etc/nixos#laptop
```

### 6. Set Password and Reboot

```bash
sudo nixos-enter --root /mnt
passwd zalleous
exit

sudo reboot
```

## Post-Installation

### First Boot

You'll get a **text login prompt** (TTY) - this is correct!
- Login as `zalleous`
- Type `sway` to start the desktop

### Sway Keybindings

- `Super + Return` - Terminal (Alacritty)
- `Super + D` - App launcher (Wofi)
- `Super + Shift + Q` - Close window
- `Super + Shift + C` - Reload Sway
- `Super + Shift + E` - Exit Sway
- `Super + 1-9` - Switch workspaces
- `Super + Arrows` - Move focus
- `Super + Shift + Arrows` - Move windows

### Auto-start Sway on Login (Optional)

```bash
echo 'exec sway' >> ~/.zprofile
```

Now Sway starts automatically when you login.

## Issues Fixed During Installation

### 1. Package Name Changes

Several packages had been renamed in nixpkgs:
- `noto-fonts-emoji` → `noto-fonts-color-emoji`
- `nerdfonts` → Use `jetbrains-mono` directly
- `kdenlive` - Had issues, commented out

### 2. XDG Portal Configuration

Old syntax `xdg.portal.wlroots.enable` was deprecated:
```nix
# Fixed version
xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
  ];
};
```

### 3. Intel Graphics CRTC Error

**Problem**: Sway showed black screen with "failed to disable CRTC 53" error

**Root causes**:
1. Missing seat manager (seatd)
2. User not in correct groups
3. Intel i915 driver needed early KMS

**Solution**:
```nix
# Enable seat manager
services.seatd.enable = true;

# Add user to groups
extraGroups = [ "video" "audio" "input" "render" "seat" ];

# Intel graphics early KMS
boot.kernelParams = [ "i915.modeset=1" ];
boot.initrd.kernelModules = [ "i915" ];
```

### 4. Unexpected Display Manager

**Problem**: LightDM display manager appeared unexpectedly

**Cause**: `services.xserver.enable = true` in laptop config enabled a display manager

**Solution**: Remove X server entirely - Sway doesn't need it:
```nix
# Don't enable xserver for pure Wayland
# services.xserver.enable = true;  # REMOVED
```

### 5. Sway Config Issues

**Problem**: Custom Sway config caused black screen

**Cause**: Wrong syntax in custom config file

**Solution**: Let home-manager generate the config properly:
```nix
wayland.windowManager.sway = {
  enable = true;
  config = {
    modifier = "Mod4";
    terminal = "alacritty";
    menu = "wofi --show drun";
    # ... proper keybindings structure
  };
};
```

Don't manually create `~/.config/sway/config` - let home-manager do it!

## WiFi After Installation

WiFi should work automatically after installation, but if it doesn't:

```bash
# Check interface status
ip link show

# If down, bring it up
sudo ip link set wlp3s0 up

# Connect
nmtui
```

## Updating the System

```bash
# Update flake inputs and rebuild
nix flake update ~/.config/nixos
sudo nixos-rebuild switch --flake ~/.config/nixos#laptop

# Or use the alias
upgrade
```

## Known Working Configuration

- **NixOS**: 25.11 (unstable)
- **Kernel**: 6.17.9 (NOT LTS - better for modern hardware)
- **Sway**: Configured via home-manager
- **Graphics**: Intel UHD 620 with i915 driver
- **Seat Manager**: seatd

## Tips

1. **Always check your WiFi interface** - it might be down by default
2. **Use latest kernel** for laptops (6.17.9, not LTS)
3. **Let home-manager configure Sway** - don't create manual configs
4. **Remove X server** from Wayland-only setups
5. **Enable seatd** for proper graphics access on Wayland

## Troubleshooting

### Black screen in Sway?

1. Check logs: `journalctl -xe | grep -i sway`
2. Look for CRTC errors: `sway -d 2>&1 | grep -i crtc`
3. Verify seatd is running: `systemctl status seatd`
4. Check groups: `groups` should show `seat video input render`

### Can't connect to WiFi?

1. Check if blocked: `rfkill list`
2. Unblock if needed: `sudo rfkill unblock wifi`
3. Bring interface up: `sudo ip link set wlp3s0 up`
4. Use nmtui or nmcli to connect

### Display manager appearing unexpectedly?

Check for `services.xserver.enable = true` in your config and remove it.
