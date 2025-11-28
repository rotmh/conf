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
      type = lib'.types.sopsKey;
    };

    passphrase = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib'.types.sopsKey;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.enable || config.${ns}.sops.enable;
        message = "`${ns}.gpg.enable = true` requires `${ns}.sops.enable = true`.";
      }
    ];

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
                        --passphrase-file "${config.sops.secrets.${cfg.passphrase}.path}" \
                      ''
                    else
                      ""
                  } --import "${config.sops.secrets.${cfg.privateKey}.path}"
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
