{ config, pkgs, ... }:

{
  home.username = "zalleous";
  home.homeDirectory = "/home/zalleous";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "zalleous";
    userEmail = "your-email@example.com"; # Update this with your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Zoxide - smarter cd command
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ZSH configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)";
      upgrade = "nix flake update ~/.config/nixos && sudo nixos-rebuild switch --flake ~/.config/nixos#$(hostname)";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "docker" ];
    };
  };

  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11;
      };

      # Tokyo Night color scheme
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#a9b1d6";
        };

        normal = {
          black = "#32344a";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#ad8ee6";
          cyan = "#449dab";
          white = "#787c99";
        };

        bright = {
          black = "#444b6a";
          red = "#ff7a93";
          green = "#b9f27c";
          yellow = "#ff9e64";
          blue = "#7da6ff";
          magenta = "#bb9af7";
          cyan = "#0db9d7";
          white = "#acb0d0";
        };

        selection = {
          background = "#33467C";
          text = "#a9b1d6";
        };
      };
    };
  };

  # Sway configuration
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";  # Super/Windows key
      terminal = "alacritty";
      menu = "wofi --show drun";

      # Keybindings
      keybindings = let
        modifier = "Mod4";
      in {
        # Basics
        "${modifier}+Return" = "exec alacritty";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec wofi --show drun";

        # Focus
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";

        # Move windows
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        # Workspaces
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Move to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Splits and layouts
        "${modifier}+h" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+space" = "floating toggle";

        # Reload and exit
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
      };

      # Gaps and appearance
      gaps = {
        inner = 5;
        outer = 5;
      };

      # Window borders
      window = {
        border = 2;
      };

      # Output configuration (monitor)
      output = {
        "*" = {
          bg = "#1a1b26 solid_color";
        };
      };

      # Status bar
      bars = [{
        position = "top";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        colors = {
          background = "#1a1b26";
          statusline = "#a9b1d6";
        };
      }];
    };
  };

  # Minimal GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
