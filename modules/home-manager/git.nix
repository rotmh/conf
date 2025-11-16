{ config, lib, ... }:
let
  ns = import ../namespace.nix;

  user = config.${ns}.user;

  cfg = config.${ns}.git;
in
{
  options.${ns}.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = user.fullname;
      userEmail = user.email;

      ignores = [
        ".direnv/"
      ];

      signing = {
        signByDefault = true;

        key = user.gpg;
      };

      extraConfig = {
        core.editor = user.editor;

        init.defaultBranch = "main";
        url = {
          "ssh://git@github.com" = {
            insteadOf = "https://github.com";
          };
          "ssh://git@gitlab.com" = {
            insteadOf = "https://gitlab.com";
          };
        };
      };
    };
  };
}
