{
  lib,
  lib',
  pkgs,
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.chromium;
in
{
  options.${ns}.chromium = {
    enable = lib.mkEnableOption "Chromium";

    enableWideVine = lib.mkEnableOption "Support DRM content";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      package = import ./package.nix {
        inherit pkgs;
        inherit (cfg) enableWideVine;
      };

      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      ];
    };
  };
}
