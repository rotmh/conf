{
  lib,
  lib',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.impermanence;
in
{
  options.${ns}.impermanence = {
    enable = lib.mkEnableOption "Impermanence";

    path = lib.mkOption {
      type = lib.types.str;
      default = "/persistent";
      description = ''
        Path to persist to.
      '';
    };

    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Directories to persist.
      '';
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Files to persist.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence.${cfg.path} = {
      inherit (cfg) directories files;
    };
  };
}
