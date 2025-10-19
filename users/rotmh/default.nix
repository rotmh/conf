{
  inputs,
  pkgs,
  pkgs',
  config,
  ...
}:
let
  user = import ./info.nix;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./sops.nix
  ];

  users.groups.${user.group} = { };
  users.users.${user.username} = {
    name = user.username;
    description = user.fullname;
    group = user.group;

    isNormalUser = true;

    hashedPasswordFile = config.sops.secrets."users/${user.username}/passwordHash".path;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    shell = pkgs.fish;

    packages = with pkgs; [
      just
      tree
      coreutils
      man-pages
      man-pages-posix
      curl

      networkmanager
    ];
  };

  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs'; };
    users.${user.username} = import ./home;
  };
}
