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

      "bin"
      "media"
      "downloads"
      "documents"

      "conf"

      ".gnupg"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"

      # XXX: temporary solution
      ".mozilla"
    ];
    files = [
      "Justfile"
    ];
    allowOther = true;
  };
}
