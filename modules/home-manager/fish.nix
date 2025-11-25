{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.fish;
in
{
  options.${ns}.fish = {
    enable = lib.mkEnableOption "Fish";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence = {
      directories.symlink = [
        # Do we want those?
        # ".local/share/fish/generated_completions"
        # ".cache/fish/generated_completions"
      ];

      files = [
        ".local/share/fish/fish_history"
      ];
    };

    programs.fish = {
      enable = true;

      generateCompletions = true;

      interactiveShellInit = ''
        set -U fish_greeting
      '';

      shellAbbrs = {
        h = "hx .";
      };

      shellAliases = {
        grep = "grep --color=auto";

        ls = "ls --color=auto --hyperlink=auto -F";
        ll = "ls -lAh";
      };
    };
  };
}
