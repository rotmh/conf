{
  lib,
  lib',
  inputs,
  pkgs,
  pkgs',
  config,
  ...
}:
let
  ns = lib'.modulesNamespace;

  extensions = import ./extensions.nix { inherit lib; };
  chromeSrc = "${pkgs'.gwfox}/chrome";

  cfg = config.${ns}.firefox;
in
{
  options.${ns}.firefox = {
    enable = lib.mkEnableOption "Firefox";

    defaultProfileName = lib.mkOption {
      default = "default";
      type = lib.types.str;
    };

    createGuestProfile = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence =
      let
        profile = ".mozilla/firefox/${cfg.defaultProfileName}";
      in
      {
        directories = [
          "${profile}/storage/default/"
        ];

        files = [
          "${profile}/cookies.sqlite"
          "${profile}/favicons.sqlite"
          "${profile}/permissions.sqlite"
          "${profile}/content-prefs.sqlite"
          "${profile}/places.sqlite"
          "${profile}/storage.sqlite"

          "${profile}/prefs.js"

          ".cache/mozilla/firefox/${cfg.defaultProfileName}"
        ];
      };

    programs.firefox = {
      enable = true;

      languagePacks = [ "en-US" ];

      policies = import ./policies.nix { inherit lib extensions; };

      profiles.${cfg.defaultProfileName} = {
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

        userChrome = builtins.readFile "${chromeSrc}/userChrome.css";
        userContent = builtins.readFile "${chromeSrc}/userContent.css";
      };

      profiles.guest = lib.mkIf cfg.createGuestProfile {
        id = 10;
        extensions.force = true;
      };
    };
  };
}
