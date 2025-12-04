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
      update = "cd /etc/nixos && sudo git pull && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      upgrade = "cd /etc/nixos && sudo git pull && sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
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

      # Disable default bar (using Waybar instead)
      bars = [];

      # Startup commands
      startup = [
        { command = "waybar"; }
        { command = "mako"; }
      ];
    };
  };

  # Waybar - Modern status bar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "network" "cpu" "memory" "battery" "clock" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "sway/window" = {
          max-length = 50;
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " Connected";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = false;
        };

        "memory" = {
          format = " {}%";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          states = {
            warning = 30;
            critical = 15;
          };
        };

        "clock" = {
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #1a1b26;
        color: #a9b1d6;
      }

      #workspaces button {
        padding: 0 8px;
        background: transparent;
        color: #565f89;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.focused {
        color: #7aa2f7;
        border-bottom: 2px solid #7aa2f7;
      }

      #workspaces button.urgent {
        color: #f7768e;
      }

      #workspaces button:hover {
        background: #24283b;
        color: #a9b1d6;
      }

      #mode {
        background: #f7768e;
        color: #1a1b26;
        padding: 0 10px;
        margin: 0 5px;
      }

      #window {
        color: #a9b1d6;
        font-weight: normal;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network {
        padding: 0 10px;
        margin: 0 2px;
      }

      #battery.charging {
        color: #9ece6a;
      }

      #battery.warning:not(.charging) {
        color: #e0af68;
      }

      #battery.critical:not(.charging) {
        color: #f7768e;
      }
    '';
  };

  # Mako - Notification daemon
  services.mako = {
    enable = true;
    backgroundColor = "#1a1b26";
    textColor = "#a9b1d6";
    borderColor = "#7aa2f7";
    borderRadius = 8;
    borderSize = 2;
    width = 300;
    height = 100;
    margin = "10";
    padding = "10";
    defaultTimeout = 5000;
    font = "JetBrainsMono Nerd Font 10";
  };

  # Wofi - App launcher styling
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: 2px solid #7aa2f7;
        background-color: #1a1b26;
        border-radius: 8px;
      }

      #input {
        margin: 10px;
        padding: 10px;
        border: none;
        background-color: #24283b;
        color: #a9b1d6;
        border-radius: 4px;
      }

      #inner-box {
        margin: 10px;
        background-color: transparent;
      }

      #outer-box {
        margin: 10px;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
      }

      #text {
        margin: 5px;
        color: #a9b1d6;
      }

      #entry:selected {
        background-color: #7aa2f7;
        color: #1a1b26;
        border-radius: 4px;
      }

      #entry:selected #text {
        color: #1a1b26;
        font-weight: bold;
      }
    '';
  };

  # Improved GTK theme - Tokyo Night inspired
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # QT theme to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
