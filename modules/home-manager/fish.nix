{ config, lib, ... }:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.fish;
in
{
  options.${ns}.fish = {
    enable = lib.mkEnableOption "Fish";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories.symlink = [
      ".local/share/fish"
    ];

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
