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
  ];

  home.packages = with pkgs; [
    tofi
    avizo
  ];

  programs.nh.enable = true;

  services.ssh-agent.enable = true;

  home.stateVersion = "25.05";
}
