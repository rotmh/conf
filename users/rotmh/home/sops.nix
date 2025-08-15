{ inputs, config, ... }:
let
  home = config.home.homeDirectory;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";

    secrets = {
      "ssh/private-key" = {
        sopsFile = ../secrets/system.yaml;
        path = "${home}/.ssh/id_ed25519";
        mode = "0400";
      };
      "ssh/public-key" = {
        sopsFile = ../secrets/system.yaml;
        path = "${home}/.ssh/id_ed25519.pub";
        mode = "0444";
      };

      "gpg/private-key" = {
        sopsFile = ../secrets/system.yaml;
        mode = "0400";
      };
      "gpg/public-key" = {
        sopsFile = ../secrets/system.yaml;
        mode = "0444";
      };
    };
  };
}
