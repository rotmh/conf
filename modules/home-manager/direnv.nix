{
  lib,
  lib',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.direnv;
in
{
  options.${ns}.direnv = {
    enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories.symlink = [
      ".local/share/direnv"
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
