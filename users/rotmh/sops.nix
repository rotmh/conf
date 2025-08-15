{ inputs, ... }:
let
  user = import ./info.nix;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.keyFile = "/persistent/var/lib/sops-nix/keys.txt";

    secrets = {
      "users/${user.username}/passwordHash" = {
        key = "passwordHash";
        neededForUsers = true;
        sopsFile = ./secrets/system.yaml;
      };
    };
  };
}
