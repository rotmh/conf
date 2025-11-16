{ pkgs', config, ... }:
let
  username = config.home.username;
  symlink = path: {
    directory = path;
    method = "symlink";
  };
in
{
  home.persistence."/persistent/home/${username}".directories = [
    (symlink ".config/spotify")
    (symlink ".cache/spotify")
  ];

  home.packages = [ pkgs'.spotify-spotx ];
}
