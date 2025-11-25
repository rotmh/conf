{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.alacritty;
in
{
  options.${ns}.alacritty = {
    enable = lib.mkEnableOption "Alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      theme = "github_dark_tritanopia";

      settings = {
        window.decorations = "None";

        font = {
          normal.family = config.${ns}.fonts.monospace;
          size = 10.5;
        };
      };
    };
  };
}
