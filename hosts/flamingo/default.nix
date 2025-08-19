{ ... }:
let
  host = "flamingo";
in
{
  imports = [
    ./impermanence.nix
    ./bluetooth.nix
    ./audio.nix
    ./console.nix
    ./sops.nix
    ./gpg.nix
    ./network.nix
    ./interception
  ];

  networking.hostName = host;

  users.mutableUsers = false;

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";

  services.libinput.enable = true;
  services.openssh.enable = true;

  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Don't touch this if you don't know what you're doing. For more information
  # see https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion.
  system.stateVersion = "25.05";
}
