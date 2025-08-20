{ inputs, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops.age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";
}
