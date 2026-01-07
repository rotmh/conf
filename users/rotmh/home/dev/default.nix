{ pkgs, ... }:
{
  imports = [
    ./c.nix
    ./nix.nix
    ./go.nix
  ];

  home.packages = with pkgs; [
    gnumake
  ];
}
