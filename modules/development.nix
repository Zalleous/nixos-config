{ config, pkgs, ... }:

{
  # Development tools and environments

  environment.systemPackages = with pkgs; [
    # Version Control (git already in common.nix)
    git-lfs
    github-cli
    lazygit

    # Editors and IDEs (vim already in common.nix)
    neovim

    # Programming Languages
    # Python
    python311
    python311Packages.pip
    python311Packages.virtualenv

    # Node.js
    nodejs_20
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm

    # Rust
    rustc
    cargo
    rustfmt
    clippy

    # Go
    go

    # C/C++
    gcc
    clang
    cmake
    gnumake

    # Java
    jdk17

    # Build tools
    meson
    ninja
    pkg-config

    # Container tools (docker enabled as service below)
    docker-compose

    # Database tools
    sqlite
    postgresql

    # API testing
    postman
    insomnia

    # Terminal tools
    tmux
    screen
    zellij

    # File comparison
    diff-so-fancy
    delta

    # Code search
    ripgrep
    fd
    fzf

    # Network tools (curl/wget already in common.nix)
    httpie
    nmap

    # System monitoring (btop already in common.nix)
    bottom
    procs
  ];

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Add user to docker group
  users.users.zalleous.extraGroups = [ "docker" ];

  # Podman as alternative (commented out to avoid conflict with Docker)
  # Uncomment and disable Docker if you prefer Podman
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   defaultNetwork.settings.dns_enabled = true;
  # };

  # Enable PostgreSQL (optional - uncomment if needed)
  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = [ "zalleous" ];
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     local all all trust
  #     host all all 127.0.0.1/32 trust
  #     host all all ::1/128 trust
  #   '';
  # };
}
