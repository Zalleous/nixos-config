# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based configuration repository with two distinct system configurations:
- **Desktop**: Full-featured with Hyprland, NVIDIA drivers, gaming, and multimedia
- **Laptop**: Minimal Sway-based setup optimized for programming and battery life

## Architecture

### Flake Structure

The `flake.nix` is the entry point and defines two `nixosConfigurations`:
- `desktop` - uses Hyprland, includes gaming/multimedia modules
- `laptop` - uses Sway, minimal development-only modules

Both configurations use home-manager for user-level configuration.

### Module System

Modules are composable Nix files in `modules/`:
- **common.nix**: Shared system configuration (networking, users, base packages)
- **hyprland.nix / sway.nix**: Window manager configurations (desktop vs laptop)
- **nvidia.nix**: NVIDIA driver setup (desktop only)
- **laptop.nix**: TLP power management and battery optimization
- **gaming.nix**: Steam, Lutris, GameMode (desktop only)
- **development.nix / development-minimal.nix**: Full vs minimal dev tools
- **multimedia.nix**: Video/audio editing, OBS (desktop only)

### Host-Specific Configuration

Each host in `hosts/<hostname>/` contains:
- `configuration.nix`: Host-specific settings (hostname, hardware-specific boot params)
- `hardware-configuration.nix`: Auto-generated hardware config (NOT committed to repo as placeholder)

### Home Manager Integration

User configuration is managed through home-manager:
- `home/home.nix`: Full desktop configuration with Hyprland keybindings
- `home/home-minimal.nix`: Laptop configuration with Sway keybindings

**CRITICAL**: Sway configuration is managed via home-manager's `wayland.windowManager.sway` module. Do NOT create manual `~/.config/sway/config` files - this will break the setup.

## Common Commands

### Testing Configuration (from Windows/WSL before installation)
```bash
# Check flake structure
nix flake show --extra-experimental-features 'nix-command flakes'

# Validate syntax (will fail on package downloads in WSL - this is expected)
nix flake check --extra-experimental-features 'nix-command flakes' --no-build
```

### Installation
```bash
# Desktop installation
sudo nixos-install --flake /mnt/etc/nixos#desktop

# Laptop installation
sudo nixos-install --flake /mnt/etc/nixos#laptop
```

### System Updates (from installed NixOS)
```bash
# Quick rebuild with current config
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

# Full update: pull git changes, update flake inputs, rebuild
cd /etc/nixos && sudo git pull && sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)

# Using aliases (configured in home-minimal.nix)
update   # Quick rebuild
upgrade  # Full update
```

### Garbage Collection
```bash
# Clean old generations
sudo nix-collect-garbage -d

# Clean and rebuild
sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
```

## Critical Platform-Specific Considerations

### Laptop (Sway + Intel Graphics)

**Required configuration for Intel UHD Graphics 620:**
```nix
# In hosts/laptop/configuration.nix
boot.kernelParams = [ "i915.modeset=1" ];
boot.initrd.kernelModules = [ "i915" ];
```

**Required services for Sway:**
```nix
# Must enable seatd for graphics access
services.seatd.enable = true;

# User must be in these groups
extraGroups = [ "video" "audio" "input" "render" "seat" ];
```

**Common Pitfall**: Enabling `services.xserver.enable = true` on a Sway-only system will cause LightDM to start unexpectedly. Sway is pure Wayland and does NOT need X server.

### Desktop (Hyprland + NVIDIA)

NVIDIA configuration requires:
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.modesetting.enable = true;
```

Hyprland-specific NVIDIA env vars are set in `modules/nvidia.nix`.

### WiFi on Laptop

**Critical**: On ThinkPad T480, WiFi interface `wlp3s0` may be DOWN by default:
```bash
sudo ip link set wlp3s0 up
```

This must be done before `nmtui` will show available networks during installation.

## Package Management Patterns

### Avoiding Duplicates

Base packages (git, vim, curl, wget, btop) are defined in `modules/common.nix`. Development modules should NOT redeclare these - only add their specific packages.

### Package Name Changes

Recent nixpkgs changes to be aware of:
- `noto-fonts-emoji` → `noto-fonts-color-emoji`
- `nerdfonts` → Use specific font packages like `jetbrains-mono`
- `hardware.opengl` → `hardware.graphics`
- `sound.enable` → Removed (use `services.pipewire` directly)

### Minimal vs Full Development

- `development.nix`: Full toolset (all languages, databases, containers)
- `development-minimal.nix`: Only Python, Node.js, Docker, Neovim

Docker is enabled as a service (`virtualisation.docker.enable = true`), not as a package.

## Testing Changes

### Before Committing Configuration Changes

1. **Never commit hardware-configuration.nix** - it's machine-specific
2. **Test syntax** with `nix flake show` (shows both configs are recognized)
3. **Package name verification** - if adding packages, search nixpkgs: `nix search nixpkgs <package>`
4. **Module conflicts** - check if `services.xserver.enable` or display managers are accidentally enabled

### Known Issues to Avoid

1. **Black screen in Sway**: Usually caused by manually creating `~/.config/sway/config` instead of using home-manager
2. **CRTC permission errors**: Missing `services.seatd.enable` or user not in `seat` group
3. **LightDM appearing unexpectedly**: `services.xserver.enable = true` is set when it shouldn't be
4. **WiFi not working**: Interface is down - check `ip link show` and bring up with `ip link set <interface> up`

## Wayland Compositor Configuration

### Sway (Laptop)

Configuration is managed in `home/home-minimal.nix` via `wayland.windowManager.sway.config`. Key points:
- Terminal is `alacritty` (explicitly set)
- Menu is `wofi --show drun`
- All keybindings use `Mod4` (Super/Windows key)
- Simple status bar with `i3status`

### Hyprland (Desktop)

Configuration is in `home/home.nix` via `wayland.windowManager.hyprland.settings`. Uses more advanced features:
- Animations and blur effects
- Custom border colors
- Workspace rules
- XWayland enabled for compatibility

## XDG Portal Configuration

**Important**: The old `xdg.portal.wlroots.enable` syntax is deprecated. Use:
```nix
xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gtk
  ];
};
```

## Updating This Configuration

When modifying the configuration:

1. **Add new modules**: Create in `modules/`, then import in `flake.nix` under the appropriate config
2. **Remove modules**: Comment out or remove from `flake.nix` imports
3. **Hardware-specific changes**: Put in `hosts/<hostname>/configuration.nix`, NOT in shared modules
4. **User-level changes**: Modify `home/home.nix` or `home/home-minimal.nix`

### Testing Module Changes

After making changes, rebuild with:
```bash
sudo nixos-rebuild test --flake /etc/nixos#$(hostname)
```

This creates a temporary boot entry without making it permanent. If it works, make it permanent:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
```

## Documentation Files

- **README.md**: General installation and usage guide
- **CUSTOMIZATION.md**: Detailed customization options (themes, packages, settings)
- **LAPTOP-INSTALL.md**: Complete laptop installation walkthrough with all known issues and fixes
- **CLAUDE.md** (this file): Architecture and development guide
