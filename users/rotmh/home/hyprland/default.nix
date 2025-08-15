{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  flake = "/persistent/home/rotmh/conf";
  mkMutableSymlink =
    path:
    config.lib.file.mkOutOfStoreSymlink (
      flake + lib.strings.removePrefix (toString inputs.self) (toString path)
    );
in
{
  home.packages = with pkgs; [
    clipse
    wl-clipboard
  ];

  xdg.configFile."hypr" = {
    source = mkMutableSymlink ./hypr;
    recursive = true;
  };
}
