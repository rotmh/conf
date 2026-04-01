{
  pkgs,
  lib,
  lib',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.kakoune;
in
{
  options.${ns}.kakoune = {
    enable = lib.mkEnableOption "Kakoune";
  };

  config = lib.mkIf cfg.enable {
    programs.kakoune = {
      enable = true;
      plugins = [ pkgs.kakounePlugins.kakoune-lsp ];
      extraConfig = builtins.readFile ./kakrc;
    };
  };
}
