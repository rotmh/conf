{ config, lib, ... }:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.zoxide;
in
{
  options.${ns}.zoxide = {
    enable = lib.mkEnableOption "Zoxide";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories.symlink = [
      ".local/share/zoxide"
    ];

    programs.zoxide = {
      enable = true;

      enableFishIntegration = config.${ns}.fish;
    };
  };
}
