{ config, ... }:
let
  username = config.home.username;
  user = import ../info.nix;
  storeDir = ".password-store";
in
{
  home.persistence."/persistent/home/${username}".directories = [
    storeDir
  ];

  programs.password-store = {
    enable = true;

    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/${storeDir}";
      PASSWORD_STORE_KEY = user.gpg;
    };
  };
}
