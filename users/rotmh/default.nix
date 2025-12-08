{
  inputs,
  pkgs,
  pkgs',
  lib',
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

      gnome-boxes # VM management
      dnsmasq # VM networking
      phodav # (optional) Share files with guest VMs
    ];
  };

  users.extraGroups.vboxusers.members = [ user.username ];

  users.groups.libvirtd.members = [ user.username ];
  users.groups.kvm.members = [ user.username ];

  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  programs.hyprland.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs' lib'; };
    users.${user.username} = import ./home;
    # backupFileExtension = "hmbackup";
  };
}
