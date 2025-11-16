{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.helix = {
    enable = true;

    package = inputs.helix-git.packages.${pkgs.system}.default;

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
          normal = { } // disabledKeys;
        };
    };

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

    themes = {
      panda =
        let
          src = pkgs.fetchFromGitHub {
            owner = "blindseerstudios";
            repo = "panda_helix_theme";
            rev = "d809d6ac914c32e78bf8e1dd1dba4b7587a9c1db";
            sha256 = "sha256-hLKtMYP35Uvteigi9sgxgwFFDHyr3czpQhY4OV6619I=";
          };
        in
        builtins.readFile "${src}/panda.toml";
    };
  };

  # Reload the configs of all active Helix instances.
  xdg.configFile."helix/config.toml".onChange = ''
    ${lib.getExe' pkgs.procps "pkill"} -u $USER -USR1 hx || true
  '';
}
