{ inputs, config, ... }:
let
  username = config.home.username;
in
{
  imports = [
    inputs.impermanence.homeManagerModules.default
  ];

  home.persistence."/persistent/home/${username}" = {
    directories = [
      "projects"
      "forks"

      "conf"

      "bin"
      "media"
      "downloads"
      "documents"

      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"

      ".mozilla"
      ".cache/mozilla"
    ];
    files = [
      "Justfile"
    ];
    allowOther = true;
  };
}
