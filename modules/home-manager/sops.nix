{
  lib,
  config,
  inputs,
  ...
}:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.sops;
in
{
  options.${ns}.sops = {
    enable = lib.mkEnableOption "Sops secrets manager";
  };

  config = lib.mkIf cfg.enable {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    sops.age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";
  };
}
