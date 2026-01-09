{ pkgs, ... }:
{
  imports = [
    ./c.nix
    ./go.nix
  ];

  home.packages = with pkgs; [
    gnumake
  ];
}
