{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  sops.secrets = {
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
  };

  services.ssh-agent = {
    enable = true;
  };
}
