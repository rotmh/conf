{
  config,
  lib,
  pkgs,
  ...
}:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.gpg;
in
{
  options.${ns}.gpg = {
    enable = lib.mkEnableOption "gpg";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "gpg/private-key" = {
        sopsFile = ../secrets/system.yaml;
      };
      "gpg/public-key" = {
        sopsFile = ../secrets/system.yaml;
      };
    };

    programs.gpg = {
      enable = true;

      publicKeys = [
        {
          source = config.sops.secrets."gpg/public-key".path;
          trust = "ultimate";
        }
      ];
    };

    home.activation.importPrivateGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" "importGpgKeys" ] ''
      ${lib.getExe pkgs.gnupg} --import ${config.sops.secrets."gpg/private-key".path}
    '';
  };
}
