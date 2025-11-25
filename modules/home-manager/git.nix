{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

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

      settings = {
        user = {
          email = user.email;
          name = user.fullname;
        };

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

      ignores = [
        ".direnv/"
      ];

      signing = {
        signByDefault = true;

        key = user.gpg;
      };
    };
  };
}
