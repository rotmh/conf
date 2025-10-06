{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprcursor.nix
  ];

  services.avizo.enable = true;

  home.packages = with pkgs; [
    clipse
    wl-clipboard
  ];
}
