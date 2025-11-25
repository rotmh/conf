{
  lib,
  lib',
  config,
  inputs,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.sops;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.${ns}.sops = {
    enable = lib.mkEnableOption "Sops secrets manager";
  };

  config = lib.mkIf cfg.enable {
    sops.age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";
  };
}
