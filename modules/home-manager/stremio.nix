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

  cfg = config.${ns}.stremio;

  stremioPkgs = import inputs.nixpkgs-for-stremio {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  options.${ns}.stremio = {
    enable = lib.mkEnableOption "Stremio";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories.symlink = [
      ".stremio-server"
      ".local/share/Smart Code ltd/Stremio"
    ];

    home.packages = [ stremioPkgs.stremio ];
  };
}
