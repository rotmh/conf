{ ... }:
let
  user = import ../info.nix;
in
{
  programs.git = {
    enable = true;

    userName = user.username;
    userEmail = user.email;

    ignores = [
      ".direnv/"
    ];

    signing = {
      signByDefault = true;

      key = user.gpg;
    };

    extraConfig = {
      core.editor = "hx";
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
}
