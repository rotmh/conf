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
    backupFileExtension = "home-manager-backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs'; };
    users.${user.username} = import ./home;
  };
}
