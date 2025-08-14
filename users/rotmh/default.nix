{ inputs, pkgs, ... }:
let
  username = "rotmh";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${username} = {
    name = username;
    shell = pkgs.fish;

    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      firefox
      just
      tree
      coreutils
      git
      curl

      # remove these
      nixd
      nixfmt-rfc-style

      networkmanager
    ];
  };

  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.${username} = import ./home;
  };
}
