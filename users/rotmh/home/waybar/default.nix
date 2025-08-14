{ pkgs, config, lib, inputs, ... }:
let
  flake = "/persistent/nixconf123123";
  mkMutableSymlink = path:
    config.lib.file.mkOutOfStoreSymlink (
      flake + lib.strings.removePrefix (toString inputs.self) (toString path)
    );
in
{
  home.packages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar" = {
    source = mkMutableSymlink ./waybar;
    recursive = true;
  };
}
