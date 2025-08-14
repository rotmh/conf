{ ... }:
{
  programs.git = {
    enable = true;

    userName = "rotmh";
    userEmail = "horesh.rotem@gmail.com";

    ignores = [
      ".direnv/"
    ];

    signing = {
      signByDefault = true;

      key = "FA5492BE76A4974A";
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
