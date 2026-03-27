{ inputs, lib', ... }:
let
  host = "flamingo";

  ns = lib'.modulesNamespace;
in
{
  imports = [
    inputs.self.nixosModules.default

    ./impermanence.nix
    ./bluetooth.nix
    ./audio.nix
    ./sops.nix
    ./gpg.nix
    ./network.nix
    ./tlp.nix
    ./interception
    # ./clamav.nix
  ];

  ${ns} = {
    gpu = {
      gpus = {
        intel-igpu = {
          id = "00:02.0";
        };
        # XXX: What's the ID?
        # nvidia-dgpu = {
        #   id = "01:00.0";
        # };
      };
    };
  };

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

  services.thermald.enable = true;

  services.upower.enable = true;

  # services.printing.enable = true;
  # services.printing.drivers = with pkgs; [ hplip ];

  # virtualisation.virtualbox.host.enable = true;

  # virtualisation.libvirtd = {
  #   enable = true;

  #   # Enable TPM emulation (for Windows 11)
  #   qemu = {
  #     swtpm.enable = true;
  #   };
  # };

  # Enable USB redirection
  # virtualisation.spiceUSBRedirection.enable = true;

  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
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
