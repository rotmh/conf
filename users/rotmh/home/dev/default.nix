{ pkgs, ... }:
{
  imports = [
    ./rust.nix
    ./c.nix
    ./nix.nix
    ./go.nix
  ];

  home.packages = with pkgs; [
    gnumake
  ];
}
