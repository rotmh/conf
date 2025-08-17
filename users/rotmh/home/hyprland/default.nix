{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprcursor.nix
  ];

  home.packages = with pkgs; [
    clipse
    wl-clipboard
  ];
}
