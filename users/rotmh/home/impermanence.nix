{
  inputs,
  config,
  lib,
  ...
}:
let
  username = config.home.username;
  symlink = path: {
    directory = path;
    method = "symlink";
  };
in
{
  imports = [
    inputs.impermanence.homeManagerModules.default
  ];

  # https://github.com/nix-community/impermanence/issues/256#issue-2825793622
  home.activation.fixPathForImpermanence = lib.hm.dag.entryBefore [ "cleanEmptyLinkTargets" ] ''
    PATH=$PATH:/run/wrappers/bin
  '';

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

      ".stremio-server"
      ".local/share/Smart Code ltd/Stremio"

      (symlink ".config/spotify")
      (symlink ".cache/spotify")

      ".password-store"

      ".local/share/fish"
      (symlink ".local/share/zoxide")
    ];
    allowOther = true;
  };
}
