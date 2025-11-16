{
  inputs,
  config,
  lib,
  ...
}:
let
  username = config.home.username;
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
    ];
    allowOther = true;
  };
}
