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
in
{
  options.${ns}.stremio = {
    enable = lib.mkEnableOption "Stremio";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories = [
      # Cache
      ".stremio-server"
      # Credentials (user auth) among others
      ".local/share/stremio"
    ];

    home.packages = [
      inputs.nixohess.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell
    ];
  };
}
