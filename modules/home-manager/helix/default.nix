{
  inputs,
  pkgs,
  lib,
  lib',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  extractThemesFromDir =
    dir:
    let
      isRegularFile = _name: type: type == "regular";
      files = dir |> builtins.readDir |> lib.filterAttrs isRegularFile |> lib.attrNames;
      themeName = lib.removeSuffix ".toml";
      themeText = filename: builtins.readFile "${dir}/${filename}";
      toThemeAttrs = p: {
        name = themeName p;
        value = themeText p;
      };
      themes = builtins.listToAttrs (map toThemeAttrs files);
    in
    themes;

  cfg = config.${ns}.helix;
in
{
  options.${ns}.helix = {
    enable = lib.mkEnableOption "Helix";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.files = [
      ".local/share/helix/trusted_workspaces"
    ];

    programs.helix = {
      enable = true;

      package = inputs.helix-git.packages.${pkgs.stdenv.hostPlatform.system}.default;

      defaultEditor = true;

      ignores = [
        "target/"
        "Cargo.lock"

        "go.sum"

        "node_modules/"

        "flake.lock"
      ];

      settings = {
        theme = "github_dark";
        editor = {
          line-number = "relative";
          mouse = false;
          rulers = [ 80 ];
          bufferline = "multiple";
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "hint";
        };

        keys =
          let
            keys = [
              "up"
              "down"
              "left"
              "right"
              "pageup"
              "pagedown"
              "home"
              "end"
            ];
            disabledKeys = builtins.listToAttrs (
              map (k: {
                name = k;
                value = "no_op";
              }) keys
            );
          in
          {
            insert = { } // disabledKeys;
            select = { } // disabledKeys;
            normal = {
              space = {
                # Git mode
                g = {
                  c = "changed_file_picker";
                  b = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
                };
              };

              "A-j" = [
                "move_visual_line_down"
                "scroll_down"
              ];
              "A-k" = [
                "move_visual_line_up"
                "scroll_up"
              ];
            }
            // disabledKeys;
          };
      };

      themes =
        let
          alabaster = pkgs.fetchFromGitHub {
            owner = "wolf";
            repo = "alabaster-for-helix";
            rev = "c312ff984000d3d0b6d20c04c39749efc1f7a7f2";
            sha256 = "sha256-CSOx6Das35WLSxUBWNYSTRs3lWFWMy6oewbo1QX1P7Y=";
          };
        in
        extractThemesFromDir "${alabaster}/helix/dot-config/helix/themes";

      languages = {
        language = lib.mapAttrsToList (name: cfg: cfg // { inherit name; }) {
          nix = {
            auto-format = true;
          };
        };

        language-server = {
          rust-analyzer.config.cargo = {
            # Make r-a use a different target directory, to prevent from locking
            # `Cargo.lock` at the expense of duplicating build artifacts.
            targetDir = true;
            features = "all";
          };
        };
      };
    };

    # Reload the configs of all active Helix instances.
    xdg.configFile."helix/config.toml".onChange = ''
      ${lib.getExe' pkgs.procps "pkill"} -u $USER -USR1 hx || true
    '';
  };
}
