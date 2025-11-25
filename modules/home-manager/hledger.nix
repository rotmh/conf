{
  pkgs,
  lib,
  lib',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.hledger;
in
{
  options.${ns}.hledger = {
    enable = lib.mkEnableOption "Hledger";

    journal = lib.mkOption {
      example = "~/.hledger.journal";
      type = lib.types.str;
      description = ''
        Path for the hledger journal file.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ hledger ];

    home.sessionVariables = lib.mkIf (cfg.journal != null) {
      LEDGER_FILE = cfg.journal;
    };
  };
}
