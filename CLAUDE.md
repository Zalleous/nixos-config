# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based configuration repository with two distinct system configurations:
- **Desktop**: Minimal Sway-based setup with NVIDIA drivers, gaming, and multimedia
- **Laptop**: Minimal Sway-based setup optimized for programming and battery life

Both configs use the same minimalist desktop environment (Sway + Waybar + Mako) with Tokyo Night theme.

## Architecture

### Flake Structure

The `flake.nix` is the entry point and defines two `nixosConfigurations`:
- `desktop` - uses Sway, includes NVIDIA drivers, gaming, multimedia, and minimal development modules
- `laptop` - uses Sway, includes only minimal development modules

Both configurations use home-manager for user-level configuration and share `home/home-minimal.nix`.

### Module System

Modules are composable Nix files in `modules/`:
- **common.nix**: Shared system configuration (networking, users, base packages, SSH, passwordless sudo)
- **sway.nix**: Sway window manager configuration (used by both desktop and laptop)
- **nvidia.nix**: NVIDIA driver setup (desktop only)
- **laptop.nix**: TLP power management and battery optimization (laptop only)
- **gaming.nix**: Steam, Lutris, GameMode, PS4 controller support (desktop only)
- **development-minimal.nix**: Minimal dev tools (Python, Node.js, Docker, Neovim, Claude Code)
- **multimedia.nix**: Video/audio editing, OBS (desktop only)

**Note**: The `hyprland.nix` and `development.nix` modules are no longer used - both systems now use Sway and minimal development setup.

### Host-Specific Configuration

Each host in `hosts/<hostname>/` contains:
- `configuration.nix`: Host-specific settings (hostname, hardware-specific boot params)
- `hardware-configuration.nix`: Auto-generated hardware config (NOT committed to repo as placeholder)

### Home Manager Integration

User configuration is managed through home-manager:
- `home/home-minimal.nix`: Shared configuration for both desktop and laptop with:
  - Sway window manager configuration
  - Waybar status bar with Tokyo Night theme
  - Mako notification daemon
  - Wofi app launcher styling
  - Alacritty terminal with Tokyo Night colors
  - ZSH with Oh My ZSH, Zoxide, and useful aliases
  - Git configuration
  - GTK/QT theming (Papirus Dark icons, Adwaita Dark theme)

**CRITICAL**: Sway configuration is managed via home-manager's `wayland.windowManager.sway` module. Do NOT create manual `~/.config/sway/config` files - this will break the setup and cause conflicts.

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
# Using aliases (configured in home-minimal.nix) - RECOMMENDED
update   # Pull git changes and rebuild
upgrade  # Pull git changes, update flake inputs, and rebuild

# Manual commands (if needed)
cd /etc/nixos && sudo git pull && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
cd /etc/nixos && sudo git pull && sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
```

**Note**: Passwordless sudo is configured for git, nix, and nixos-rebuild commands for the `zalleous` user, enabling seamless updates.

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

### Desktop (Sway + NVIDIA)

NVIDIA configuration requires:
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.modesetting.enable = true;
```

Sway-specific NVIDIA env vars are set in `modules/nvidia.nix`.

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
- `hardware.pulseaudio` → `services.pulseaudio`

### Deprecated Configuration Options (NixOS 26.05)

Recent home-manager and NixOS option renames:
- `programs.git.userName` → `programs.git.settings.user.name`
- `programs.git.userEmail` → `programs.git.settings.user.email`
- `programs.git.extraConfig` → `programs.git.settings`
- `services.mako.*` → `services.mako.settings.*` (with hyphenated keys)
- `services.logind.lidSwitch` → `services.logind.settings.Login.HandleLidSwitch`
- `services.logind.lidSwitchExternalPower` → `services.logind.settings.Login.HandleLidSwitchExternalPower`

### Development Tools

- `development-minimal.nix`: Minimal toolset used by both desktop and laptop
  - Languages: Python 3.11, Node.js 20
  - Tools: Git LFS, GitHub CLI, Lazygit, Neovim, Ripgrep, fd, fzf, tmux
  - AI: Claude Code CLI tool
  - Containers: Docker with compose (enabled as service, not package)

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

### Sway (Both Desktop and Laptop)

Configuration is managed in `home/home-minimal.nix` via `wayland.windowManager.sway.config`. Key points:
- Terminal: `alacritty` with Tokyo Night theme
- Menu: `wofi --show drun` with custom styling
- All keybindings use `Mod4` (Super/Windows key)
- Status bar: Waybar with Tokyo Night theme (shows workspaces, window title, network, CPU, memory, battery, clock)
- Notifications: Mako with Tokyo Night theme
- Gaps: 5px inner and outer
- Border: 2px with Tokyo Night colors
- Background: Solid Tokyo Night background color (#1a1b26)

### Startup Applications

Sway automatically starts:
- Waybar (status bar)
- Mako (notification daemon)

### Keybindings

All Sway keybindings use `Mod4` (Super/Windows key):
- `Mod4 + Return` - Open terminal (Alacritty)
- `Mod4 + D` - App launcher (Wofi)
- `Mod4 + Shift + Q` - Close window
- `Mod4 + 1-9` - Switch to workspace
- `Mod4 + Shift + 1-9` - Move window to workspace
- `Mod4 + Arrow Keys` - Focus window
- `Mod4 + Shift + Arrow Keys` - Move window
- `Mod4 + H` - Split horizontal
- `Mod4 + V` - Split vertical
- `Mod4 + F` - Fullscreen toggle
- `Mod4 + Space` - Floating toggle
- `Mod4 + Shift + C` - Reload Sway config
- `Mod4 + Shift + E` - Exit Sway

## Minimalist Desktop Environment (Tokyo Night Theme)

The entire desktop environment uses a consistent Tokyo Night color scheme:

### Waybar (Status Bar)
- Top bar with workspace indicators, window title, and system info
- Shows: Network (WiFi SSID), CPU usage, Memory usage, Battery status, Clock
- Click clock to toggle date display
- Blue accent color (#7aa2f7) for focused workspace

### Wofi (App Launcher)
- Centered window with search functionality
- Blue selection highlight matching Tokyo Night theme
- Shows application icons (Papirus Dark icon theme)
- Case-insensitive search

### Mako (Notifications)
- Top-right corner notifications
- 5 second timeout by default
- Blue border (#7aa2f7) matching theme
- Dismissible with click

### GTK/QT Theming
- GTK Theme: Adwaita Dark
- Icon Theme: Papirus Dark
- Font: JetBrainsMono Nerd Font
- Both GTK3 and GTK4 prefer dark theme
- QT apps match GTK theme via qt.platformTheme

### Color Palette (Tokyo Night)
- Background: #1a1b26
- Foreground: #a9b1d6
- Blue (accent): #7aa2f7
- Red: #f7768e
- Green: #9ece6a
- Yellow: #e0af68
- Magenta: #bb9af7
- Cyan: #0db9d7

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
