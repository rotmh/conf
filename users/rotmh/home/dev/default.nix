{ pkgs, ... }:
{
  imports = [
    ./rust.nix
    ./c.nix
    ./nix.nix
  ];

  home.packages = with pkgs; [
    gnumake
  ];
}
