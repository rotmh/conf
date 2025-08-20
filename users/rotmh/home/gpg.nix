{
  pkgs,
  lib,
  config,
  ...
}:
{
  sops.secrets = {
    "gpg/private-key" = {
      sopsFile = ../secrets/system.yaml;
      mode = "0400";
    };
    "gpg/public-key" = {
      sopsFile = ../secrets/system.yaml;
      mode = "0444";
    };
  };

  programs.gpg = {
    enable = true;
  };

  # home.activation = {
  #   importGpgKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     ${lib.getExe pkgs.gnupg} --import ${config.sops.secrets."gpg/private-key".path}
  #   '';
  # };
}
