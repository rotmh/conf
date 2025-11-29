{
  config,
  pkgs,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.clipse;
in
{
  options.${ns}.clipse = {
    enable = lib.mkEnableOption "Clipse clipboard manager";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence = {
      files = [
        ".config/clipse/clipboard_history.json"
      ];
    };

    services.clipse = {
      enable = true;

      historySize = 1000;
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
