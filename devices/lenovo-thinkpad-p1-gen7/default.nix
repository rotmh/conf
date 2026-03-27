{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p1
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-laptop

    inputs.disko.nixosModules.default
    (import ./disk.nix { device = "/dev/nvme0n1"; })

    ./hardware.nix
    ./nvidia.nix
  ];

  # Fingerprint scanner
  # services.fprintd.enable = true;
  # security.pam.services = {
  #   login.fprintAuth = true;
  #   sudo.fprintAuth = true;
  # };
}
