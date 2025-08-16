{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";
}
