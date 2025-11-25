{
  config,
  lib,
  lib',
  pkgs,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.gpg;
in
{
  options.${ns}.gpg = {
    enable = lib.mkEnableOption "gpg";

    publicKey = lib.mkOption {
      type = lib.types.path;
    };

    privateKey = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;

      publicKeys = [
        {
          source = cfg.publicKey;
          trust = "ultimate";
        }
      ];
    };

    home.activation.importPrivateGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" "importGpgKeys" ] ''
      ${lib.getExe pkgs.gnupg} --import ${cfg.privateKey}
    '';
  };
}
