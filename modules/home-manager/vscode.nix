{
  config,
  pkgs,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.vscode;
in
{
  options.${ns}.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;

      profiles = {
        "default" = {
          userSettings = {
            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
            };
          };

          extensions = with pkgs.vscode-extensions; [
            asvetliakov.vscode-neovim
          ];
        };
      };
    };

    home.packages = with pkgs; [
      neovim
    ];
  };
}
