{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.gpg = {
    enable = true;
  };

  # home.activation = {
  #   importGpgKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     ${lib.getExe pkgs.gnupg} --import ${config.sops.secrets."gpg/private-key".path}
  #   '';
  # };
}
