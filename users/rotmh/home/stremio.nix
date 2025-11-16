{
  pkgs,
  inputs,
  config,
  ...
}:
let
  username = config.home.username;

  stremioPkgs = import inputs.nixpkgs-for-stremio {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  home.persistence."/persistent/home/${username}".directories = [
    ".stremio-server"
    ".local/share/Smart Code ltd/Stremio"
  ];

  home.packages = [ stremioPkgs.stremio ];
}
