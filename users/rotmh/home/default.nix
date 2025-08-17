{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./hyprland
    ./zoxide.nix
    ./firefox
    ./waybar
    ./fonts.nix
    ./impermanence.nix
    ./helix.nix
    ./git.nix
    ./fish.nix
    ./starship.nix
    ./vlc.nix
    ./sops.nix
    ./gpg.nix
    ./ssh.nix
    # ./dev
  ];

  home.packages = with pkgs; [
    tofi
    avizo

    discord
    stremio
    spotify
    tor-browser-bundle-bin
  ];

  programs.nh.enable = true;

  home.stateVersion = "25.05";
}
