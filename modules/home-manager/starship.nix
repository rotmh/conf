{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.starship;
in
{
  options.${ns}.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableFishIntegration = config.${ns}.fish.enable;

      enableTransience = true;

      settings = {
        add_newline = true;
      };
    };
  };
}
