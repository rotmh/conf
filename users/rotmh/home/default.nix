{ inputs, pkgs, ... }:
{
  imports = [
    ./impermanence.nix

    ./alacritty.nix
    ./hyprland
    ./zoxide.nix
    ./firefox.nix
    ./waybar
    ./fonts.nix
    ./helix.nix
    ./git.nix
    ./fish.nix
    ./starship.nix
    ./vlc.nix
    ./sops.nix
    ./gpg.nix
    ./ssh.nix
    ./pass.nix
    ./dev
  ];

  home.packages =
    let
      stremioPkgs = import inputs.nixpkgs-for-stremio {
        inherit (pkgs) system;
      };
    in
    with pkgs;
    [
      (stremioPkgs.stremio)

      avizo

      discord
      spotify
      tor-browser-bundle-bin

      chafa
      ueberzugpp
    ];

  programs.tofi = {
    enable = true;

    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      font = "monospace";
      background-color = "#000A";
    };
  };

  programs.bat.enable = true;

  programs.yazi = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.ripgrep.enable = true;

  programs.nh.enable = true;

  home.stateVersion = "25.05";
}
