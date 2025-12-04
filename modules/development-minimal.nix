{ config, pkgs, ... }:

{
  # Minimal development environment - only essentials

  environment.systemPackages = with pkgs; [
    # Version Control (git already in common.nix)
    git-lfs
    github-cli
    lazygit

    # Editor (vim already in common.nix)
    neovim

    # Programming Languages - uncomment what you need
    python311
    python311Packages.pip
    python311Packages.virtualenv

    nodejs_20
    nodePackages.npm

    # Uncomment if you need these:
    # rustc
    # cargo
    # go
    # gcc
    # clang
    # cmake
    # gnumake

    # Docker
    docker-compose

    # Terminal tools
    tmux
    ripgrep
    fd
    fzf

    # AI coding assistant
    # Install with: npm install -g @anthropic-ai/claude-code
    # Or add nodejs global packages here if needed

    # Network tools (curl/wget already in common.nix)
    httpie

    # System monitoring (btop already in common.nix)
    procs
  ];

  # Docker - minimal setup
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;  # Start only when needed to save resources
  };

  users.users.zalleous.extraGroups = [ "docker" ];
}
