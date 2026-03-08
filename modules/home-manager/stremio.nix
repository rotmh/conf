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
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  options.${ns}.stremio = {
    enable = lib.mkEnableOption "Stremio";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories = [
      # Cache
      ".stremio-server"

      ".local/share/Smart Code ltd/Stremio"

      # Credentials (user auth) among others
      ".local/share/stremio"
    ];

    home.packages = [
      # inputs.nixohess.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell
      stremioPkgs.stremio
    ];
  };
}
