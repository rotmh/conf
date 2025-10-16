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
  };
}
