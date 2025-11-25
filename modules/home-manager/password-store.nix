{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  homeDir = config.home.homeDirectory;
  storeDir = "${homeDir}/.password-store";

  cfg = config.${ns}.password-store;
in
{
  options.${ns}.password-store = {
    enable = lib.mkEnableOption "password-store";
  };

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;

      settings = {
        PASSWORD_STORE_DIR = storeDir;
        PASSWORD_STORE_KEY = config.${ns}.user.gpg;
      };
    };
  };
}
