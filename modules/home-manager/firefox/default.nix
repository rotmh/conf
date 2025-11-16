{
  lib,
  inputs,
  pkgs,
  pkgs',
  config,
  ...
}:
let
  ns = import ../namespace.nix;

  extensions = import ./extensions.nix { inherit lib; };
  chromeSrc = "${pkgs'.gwfox}/chrome";

  cfg = config.${ns}.firefox;
in
{
  options.${ns}.firefox = {
    enable = lib.mkEnableOption "Firefox";

    defaultProfileName = lib.mkOption {
      defualt = "default";
      type = lib.types.str;
    };

    createGuestProfile = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [
      (import ./persistence.nix {
        inherit (cfg) defaultProfileName;
        inherit ns;
      })
    ];

    programs.firefox = {
      enable = true;

      languagePacks = [ "en-US" ];

      policies = import ./policies.nix { inherit lib extensions; };

      profiles.${cfg.defaultProfileName} = {
        extensions = {
          force = true;
          packages =
            let
              exts = inputs.firefox-addons.packages.${pkgs.system};
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

        userChrome = "${chromeSrc}/userChrome.css";
        userContent = "${chromeSrc}/userContent.css";
      };

      profiles.guest = lib.mkIf cfg.createGuestProfile {
        id = 10;
        extensions.force = true;
      };
    };
  };
}
