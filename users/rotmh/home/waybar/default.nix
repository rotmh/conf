{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
    };

    style = ./style.css;

    settings = {
      layer = "top";
      "position" = "top";
      "modules-left" = [
        "clock"
        "hyprland/workspaces"
      ];
      "modules-center" = [ "hyprland/window" ];
      "modules-right" = [
        "hyprland/submap"
        "hyprland/language"
        "bluetooth"
        "pulseaudio"
        "memory"
        "network#wifi"
        "battery"
      ];
      "hyprland/workspaces" = {
        "disable-scroll" = true;
      };
      "hyprland/language" = {
        "format-en" = "en";
        "format-he" = "he";
        "on-click" = "hyprctl switchxkblayout all next";
      };
      "hyprland/submap" = {
        "format" = "{}";
        "always-on" = true;
        "default-submap" = "";
        "tooltip" = false;
      };
      "hyprland/window" = {
        "rewrite" = {
          "h" = "Helix";
          "Stremio - Freedom to Stream" = "Stremio";
          "Spotify Premium" = "Spotify";
          ".*Mozilla Firefox" = "Firefox";
        };
      };
      "clock" = {
        "format" = "{=%b %d  %H=%M}";
        "tooltip" = false;
      };
      "pulseaudio" = {
        "format" = "  {volume}%";
        "format-muted" = " ";
      };
      "bluetooth" = {
        "format-off" = "󰂲";
        "format-disabled" = "󰂲";
        "format-on" = "󰂯";
        "format-connected" = "{num_connections}󰂱";
        "tooltip" = true;
        "tooltip-format" = "{device_enumerate}";
        "on-click" = "bluetooth toggle";
      };
      "memory" = {
        "format" = "󰍛 {}%";
      };
      "network#wifi" = {
        "format" = "{iframe}";
        "format-icons" = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        "format-disconnected" = "󰤮 ";
        "format-wifi" = "{icon}";
        "tooltip-format-wifi" = "{essid} ({signalStrength}%)";
        "tooltip-format-disconnected" = "Disconnected";
        "on-click" = "wifi toggle";
      };
      "battery" = {
        "states" = {
          "warning" = 30;
          "critical" = 10;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = "󰂄 {capacity}%";
        "format-plugged" = "󰂄 {capacity}%";
        "format-icons" = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
    };
  };
}
