{
  config,
  pkgs,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.dev.nix;
in
{
  options.${ns}.dev.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories = [
      ".cache/nix"
    ];

    home.packages = with pkgs; [
      nixd
      nil
      nixfmt
    ];
  };
}
