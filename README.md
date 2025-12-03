# NixOS Configuration

My personal NixOS configuration with support for both desktop (with NVIDIA) and laptop systems.

## Features

- **Window Manager**: Hyprland (Wayland compositor) - XWayland enabled for compatibility
- **Terminal**: Alacritty with Tokyo Night theme
- **Shell**: ZSH with Oh My ZSH and Zoxide
- **Development**: Full dev environment (Docker, VSCode, multiple languages)
- **Gaming**: Steam, Lutris, GameMode, MangoHud, PS4 controller support
- **Multimedia**: Video/audio editing, OBS, media players
- **Office**: LibreOffice and PDF tools

## Structure

```
.
├── flake.nix                 # Flake configuration (entry point)
├── hosts/
│   ├── desktop/              # Desktop-specific config (with NVIDIA)
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop/               # Laptop-specific config (power management)
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── common.nix            # Shared configuration
│   ├── hyprland.nix          # Hyprland setup
│   ├── nvidia.nix            # NVIDIA drivers (desktop only)
│   ├── laptop.nix            # Laptop power management
│   ├── gaming.nix            # Gaming software
│   ├── development.nix       # Development tools
│   └── multimedia.nix        # Multimedia applications
└── home/
    └── home.nix              # User configuration (home-manager)
```

## Installation

### 1. Download NixOS

Download the latest NixOS ISO from [nixos.org](https://nixos.org/download.html) and create a bootable USB drive.

### 2. Boot into NixOS installer

Boot from the USB drive. You'll be in a live environment.

### 3. Partition your disk

Example for UEFI systems:

```bash
# Create partitions
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 512MiB 100%

# Format partitions
sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# Mount
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### 4. Generate hardware configuration

```bash
sudo nixos-generate-config --root /mnt
```

### 5. Clone this repository

```bash
nix-shell -p git
cd /mnt
git clone https://github.com/yourusername/nixos-config.git /mnt/etc/nixos
```

### 6. Copy hardware configuration

For desktop:
```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/desktop/hardware-configuration.nix
```

For laptop:
```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/laptop/hardware-configuration.nix
```

### 7. Edit configuration

Update these before installing:
- `home/home.nix` - Set your git email (line 14)
- `modules/common.nix` - Set your timezone (line 11)

### 8. Install NixOS

For desktop:
```bash
sudo nixos-install --flake /mnt/etc/nixos#desktop
```

For laptop:
```bash
sudo nixos-install --flake /mnt/etc/nixos#laptop
```

### 9. Set user password

```bash
sudo nixos-enter --root /mnt
passwd zalleous
exit
```

### 10. Reboot

```bash
sudo reboot
```

## Post-Installation

### Move config to home directory (recommended)

After logging in:

```bash
mkdir -p ~/.config
mv /etc/nixos ~/.config/nixos
sudo ln -s ~/.config/nixos /etc/nixos
```

### Updating the system

```bash
# Rebuild with current config
sudo nixos-rebuild switch --flake ~/.config/nixos#desktop  # or #laptop

# Update flake inputs and rebuild
nix flake update ~/.config/nixos
sudo nixos-rebuild switch --flake ~/.config/nixos#desktop
```

Or use the aliases defined in ZSH:
```bash
update   # Rebuild with current config
upgrade  # Update inputs and rebuild
```

## Hyprland Keybindings

- `Super + Return` - Open terminal (Alacritty)
- `Super + D` - Application launcher (Wofi)
- `Super + Q` - Close window
- `Super + M` - Exit Hyprland
- `Super + E` - File manager (Thunar)
- `Super + V` - Toggle floating
- `Super + F` - Fullscreen
- `Super + L` - Lock screen
- `Super + 1-9` - Switch workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + Arrow keys` - Move focus
- `Super + Mouse drag` - Move window
- `Super + Right mouse drag` - Resize window
- `Print` - Screenshot (select area)

## Customization

**See [CUSTOMIZATION.md](CUSTOMIZATION.md) for a complete guide** on everything you can customize!

Quick overview:

### Change desktop environment

Edit `flake.nix` and replace `./modules/hyprland.nix` with your preferred DE:
- KDE Plasma: Create `modules/plasma.nix`
- GNOME: Create `modules/gnome.nix`

### Add more packages

System-wide packages: Edit the relevant module in `modules/`
User packages: Edit `home/home.nix`

### Disable modules

Remove the module import from `flake.nix`. For example, to disable gaming:
```nix
# Remove or comment out this line:
./modules/gaming.nix
```

## Troubleshooting

### NVIDIA issues

If you have NVIDIA problems on desktop:
- Try setting `hardware.nvidia.open = true` in `modules/nvidia.nix`
- Or use `package = config.boot.kernelPackages.nvidiaPackages.beta`

### Hyprland not starting

Check logs:
```bash
journalctl -u display-manager
```

Try starting manually:
```bash
Hyprland
```

### Build fails

Clean and retry:
```bash
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake ~/.config/nixos#desktop
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [NixOS Options Search](https://search.nixos.org/)

## License

MIT License - See LICENSE file for details
