{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
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

        # https://www.reddit.com/r/hyprland/comments/11c2lie/comment/jak96fw/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        # "bindm = $mainMod, mouse:272, movewindow"
        # "bindm = $mainMod, mouse:273, resizewindow"
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
    };

    # -- Submaps --
    extraConfig = ''
      bind = SHIFT, SPACE, submap, main
      submap = main

        bind = , V, exec, $terminal start clipse --class clipse
        bind = , V, submap, reset

        bind = , W, exec, $terminal
        bind = , W, submap, reset

        bind = , U, exec, $menu
        bind = , U, submap, reset

        bind = , E, exec, $browser
        bind = , E, submap, reset

        bind = , T, exec, tor-browser
        bind = , T, submap, reset

        bind = , F, fullscreen, 0
        bind = , C, killactive

        bind = , H, movefocus, l
        bind = , J, movefocus, d
        bind = , K, movefocus, u
        bind = , L, movefocus, r

        bind = , left, movefocus, l
        bind = , down, movefocus, d
        bind = , up, movefocus, u
        bind = , right, movefocus, r

        bind = , 1, workspace, 1
        bind = , 2, workspace, 2
        bind = , 3, workspace, 3
        bind = , 4, workspace, 4
        bind = , 5, workspace, 5
        bind = , 6, workspace, 6
        bind = , 7, workspace, 7
        bind = , 8, workspace, 8
        bind = , 9, workspace, 9
        bind = , 0, workspace, 10

        bind = , G, submap, goto
        bind = SHIFT, G, submap, goto
        submap = goto
          bind = , A, workspace, 1
          bind = , S, workspace, 2
          bind = , D, workspace, 3
          bind = , F, workspace, 4
          bind = , G, workspace, 5
          bind = , H, workspace, 6
          bind = , J, workspace, 7
          bind = , K, workspace, 8
          bind = , L, workspace, 9
          bind = , ;, workspace, 10

          bind = , Escape, submap, main
        submap = main

        bind = , M, submap, move
        submap = move
          bind = , A, movetoworkspace, 1
          bind = , S, movetoworkspace, 2
          bind = , D, movetoworkspace, 3
          bind = , F, movetoworkspace, 4
          bind = , G, movetoworkspace, 5
          bind = , H, movetoworkspace, 6
          bind = , J, movetoworkspace, 7
          bind = , K, movetoworkspace, 8
          bind = , L, movetoworkspace, 9
          bind = , ;, movetoworkspace, 10

          bind = , Escape, submap, main
        submap = main

        bind = , R, submap, resize
        submap = resize
          binde = , right, resizeactive, 10 0
          binde = , left, resizeactive, -10 0
          binde = , up, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10

          binde = , L, resizeactive, 10 0
          binde = , H, resizeactive, -10 0
          binde = , K, resizeactive, 0 -10
          binde = , J, resizeactive, 0 10

          bind = , Escape, submap, main
        submap = main

        bind = , Escape, submap, reset
      submap = reset
    '';

    settings = {
      exec-once = [
        "${lib.getExe pkgs.waybar}"
        "${lib.getExe pkgs.clipse} -listen"

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
        "blur, waybar"
        "blur, dunst"
        "blur, gtk4-layer-shell"
      ];

      windowrulev2 = [
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
      ];
    };
  };
}
