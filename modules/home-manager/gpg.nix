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

    passphrase = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;

      mutableKeys = false;
      mutableTrust = false;
      publicKeys = [
        {
          source = cfg.publicKey;
          trust = "ultimate";
        }
      ];
    };

    systemd.user.services = {
      import-gpg-keys = {
        Unit = {
          Description = "Import GPG secret keys";
          After = [ "sops-nix.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart =
            let
              importGpgKeys = pkgs.writeShellScript "import-gpg-keys" ''
                while [ ! -f "${config.programs.gpg.homedir}/pubring.kbx" ]; do
                  sleep 1;
                done;

                ${lib.getExe pkgs.gnupg} \
                  ${
                    if cfg.passphrase != null then
                      ''
                        --pinentry-mode loopback \
                        --passphrase-file "${cfg.passphrase}" \
                      ''
                    else
                      ""
                  } --import ${cfg.privateKey}
              '';
            in
            "${importGpgKeys}";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
