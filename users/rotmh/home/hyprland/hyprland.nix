{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # -- Variables --
      "$mainMod" = "SUPER";
      "$menu" = "${lib.getExe' pkgs.tofi "tofi-drun"} --fuzzy-match=true --drun-launch=true";
      "$browser" = lib.getExe pkgs.firefox;
      "$terminal" = lib.getExe pkgs.alacritty;

      # -- Looks --
      animations.enabled = false;

      decoration = {
        rounding = 0;

        blur = {
          enabled = true;

          size = 5;
          passes = 2;
          ignore_opacity = false;
          noise = 0.0200;
          contrast = 1;
          brightness = 0.8172;
          vibrancy = 0.1696;
        };

        shadow.enabled = false;
      };

      general = {
        border_size = 0;

        gaps_in = 0;
        gaps_out = 0;
      };

      # -- Binds --
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, R, exec, $menu"
        "$mainMod, E, exec, $browser"
        "$mainMod, V, exec, $terminal --class clipse -e '${lib.getExe pkgs.clipse}'"

        # Switch keyboard layout
        "$mainMod, Z, exec, hyprctl switchxkblayout all next"

        "$mainMod, M, exec, hyprlock"

        "$mainMod, C, killactive"
        "$mainMod, T, togglesplit"
        "$mainMod, F, fullscreen, 0"

        # Move between windows
        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"
        "$mainMod, left, movefocus, l"
        "$mainMod, down, movefocus, d"
        "$mainMod, up, movefocus, u"
        "$mainMod, right, movefocus, r"

        # Move to workspace
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move current window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        # "$mainMod, PRINT, exec, hyprshot -m window"
        # ", PRINT, exec, hyprshot -m output"
        # "$mainMod SHIFT, PRINT, exec, hyprshot -m region"

        # Move windows
        "bindm = $mainMod, mouse:272, movewindow"
        "bindm = $mainMod, mouse:273, resizeactive"
        # https://www.reddit.com/r/hyprland/comments/11c2lie/comment/jak96fw
        "bind = $mainMod SHIFT, H, movewindow, l"
        "bind = $mainMod SHIFT, L, movewindow, r"
        "bind = $mainMod SHIFT, K, movewindow, u"
        "bind = $mainMod SHIFT, J, movewindow, d"
      ];

      binde = [
        # Volume and Brightness
        ", XF86MonBrightnessUp, exec, lightctl up"
        ", XF86MonBrightnessDown, exec, lightctl down"
        ", XF86AudioRaiseVolume, exec, volumectl -u up"
        ", XF86AudioLowerVolume, exec, volumectl -u down"
        ", XF86AudioMute, exec, volumectl toggle-mute"
        ", XF86AudioMicMute, exec, volumectl -m toggle-mute"
      ];

      exec-once = [
        # https://github.com/nix-community/home-manager/issues/7242#issuecomment-2961230589
        "systemctl --user start hyprpaper"
      ];

      env = [
        # Try to force applications to use wayland
        "GDK_BACKEND, wayland,x11,*"
        "QT_QPA_PLATFORM, wayland;xcb"
        "SDL_VIDEODRIVER, wayland"
        "CLUTTER_BACKEND, wayland"
        "NIXOS_OZONE_WL, 1"

        # "HYPRSHOT_DIR, /home/rotmh/media/images/screenshots"
      ];

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      input = {
        touchpad = {
          natural_scroll = true;
        };

        follow_mouse = 1;
        kb_layout = "us,il";
        repeat_delay = 300;
        repeat_rate = 60;
      };

      master = {
        new_status = "master";
      };

      misc = {
        vfr = true;
      };

      layerrule = [
        "blur on, match:namespace waybar"
        "blur on, match:namespace dunst"
        "blur on, match:namespace gtk4-layer-shell"
      ];

      windowrulev2 = [
        "match:class clipse, float on, size 622 652"
      ];
    };

    extraConfig =
      let
        mkSubmap =
          {
            name,
            enterBinds,
            escapeBind ? ", Escape",
            parent ? "reset",
            settings ? { },
            nested ? [ ],
          }:
          let
            patchNested = s: s // { parent = name; };
            mkNested =
              s:
              lib.pipe s [
                patchNested
                mkSubmap
              ];
            mkEnterBind = b: "bind = ${b}, submap, ${name}";
          in
          ''
            ${lib.concatMapStringsSep "\n" mkEnterBind enterBinds}
            submap = ${name}

            ${lib.hm.generators.toHyprconf { attrs = settings; }}

            ${lib.concatMapStringsSep "\n" mkNested nested}

            bind = ${escapeBind}, submap, ${parent}
            submap = ${parent}
          '';
      in
      mkSubmap {
        name = "general";
        enterBinds = [ "SHIFT, SPACE" ];

        nested = [
          {
            name = "goto";
            enterBinds = [
              ", G"
              "SHIFT, G"
            ];

            settings = {
              bind = [
                ", A, workspace, 1"
                ", S, workspace, 2"
                ", D, workspace, 3"
                ", F, workspace, 4"
                ", G, workspace, 5"
                ", H, workspace, 6"
                ", J, workspace, 7"
                ", K, workspace, 8"
                ", L, workspace, 9"
                ", ;, workspace, 10"
              ];
            };
          }

          {
            name = "move";
            enterBinds = [
              ", M"
              "SHIFT, M"
            ];

            settings = {
              bind = [
                ", A, movetoworkspace, 1"
                ", S, movetoworkspace, 2"
                ", D, movetoworkspace, 3"
                ", F, movetoworkspace, 4"
                ", G, movetoworkspace, 5"
                ", H, movetoworkspace, 6"
                ", J, movetoworkspace, 7"
                ", K, movetoworkspace, 8"
                ", L, movetoworkspace, 9"
                ", ;, movetoworkspace, 10"
              ];
            };
          }

          {
            name = "resize";
            enterBinds = [
              ", R"
              "SHIFT, R"
            ];

            settings = {
              binde = [
                ", right, resizeactive, 10 0"
                ", left, resizeactive, -10 0"
                ", up, resizeactive, 0 -10"
                ", down, resizeactive, 0 10"

                ", L, resizeactive, 10 0"
                ", H, resizeactive, -10 0"
                ", K, resizeactive, 0 -10"
                ", J, resizeactive, 0 10"
              ];
            };
          }
        ];

        settings = {
          bind = [
            ", V, exec, $terminal start clipse --class clipse"
            ", V, submap, reset"

            ", W, exec, $terminal"
            ", W, submap, reset"

            ", U, exec, $menu"
            ", U, submap, reset"

            ", E, exec, $browser"
            ", E, submap, reset"

            ", T, exec, tor-browser"
            ", T, submap, reset"

            ", F, fullscreen, 0"
            ", C, killactive"

            ", H, movefocus, l"
            ", J, movefocus, d"
            ", K, movefocus, u"
            ", L, movefocus, r"

            ", left, movefocus, l"
            ", down, movefocus, d"
            ", up, movefocus, u"
            ", right, movefocus, r"

            ", 1, workspace, 1"
            ", 2, workspace, 2"
            ", 3, workspace, 3"
            ", 4, workspace, 4"
            ", 5, workspace, 5"
            ", 6, workspace, 6"
            ", 7, workspace, 7"
            ", 8, workspace, 8"
            ", 9, workspace, 9"
            ", 0, workspace, 10"
          ];
        };
      };
  };
}
