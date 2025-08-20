{ config, ... }:
let
  user = import ../info.nix;
in
{
  programs.password-store = {
    enable = true;

    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      PASSWORD_STORE_KEY = user.gpg;
    };
  };
}
