{
  pkgs,
  pkgs',
  lib,
  config,
  inputs,
  ...
}:
let
  profileName = "default";
  extensions = import ./extensions.nix;
in
{
  imports = [
    (import ./persistence.nix profileName)
  ];

  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    policies = import ./policies.nix { inherit lib extensions; };

    profiles.${profileName} = {
      extensions = {
        force = true;
        packages =
          let
            exts = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
          in
          map (ext: exts.${ext}) (builtins.attrNames extensions);
        settings =
          let
            hasSettings = _name: value: value ? settings && value.settings != { };
          in
          lib.mapAttrs' (
            _name: value:
            lib.nameValuePair value.id {
              inherit (value) settings;
              force = true;
            }
          ) (lib.filterAttrs hasSettings extensions);
      };

      settings = import ./settings.nix { inherit config; };
      search = import ./search.nix { inherit lib; };
      bookmarks = import ./bookmarks.nix;

      userChrome = "${pkgs'.gwfox}/chrome/userChrome.css";
      userContent = "${pkgs'.gwfox}/chrome/userContent.css";
    };

    profiles.guest.id = 10;
    profiles.guest.extensions.force = true;
  };
}
