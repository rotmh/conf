{ lib, extensions, ... }:
{
  "3rdparty" = {
    Extensions =
      let
        hasDefaultSettings = _name: value: value ? defaultSettings && value.defaultSettings != { };
      in
      (lib.mapAttrs' (
        _name: value:
        lib.nameValuePair value.id (
          lib.setAttrByPath [ value.defaultSettingsKey or "adminSettings" ] value.defaultSettings
        )
      ) (lib.filterAttrs hasDefaultSettings extensions));
  };
  BlockAboutConfig = true;
  AppUpdateURL = "https://localhost";
  DisableAppUpdate = true;
  OverrideFirstRunPage = "";
  OverridePostUpdatePage = "";
  DisableSystemAddonUpdate = true;
  DisableProfileImport = false;
  DisableFirefoxStudies = true;
  DisableTelemetry = true;
  DisableFeedbackCommands = true;
  DisablePocket = true;
  DisableDeveloperTools = false;
  DisableFirefoxAccounts = true;
  DisableAccounts = true;
  DisableFirefoxScreenshots = true;
  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
  };
  Extensions = {
    Uninstall = [
      "google@search.mozilla.org"
      "bing@search.mozilla.org"
      "amazondotcom@search.mozilla.org"
      "ebay@search.mozilla.org"
      "twitter@search.mozilla.org"
    ];
  };
  ExtensionSettings =
    let
      privateAllowed = _n: v: v ? privateAllowed && v.privateAllowed;
    in
    lib.mapAttrs' (
      _name: value:
      lib.nameValuePair value.id {
        private_browsing = true;
      }
    ) (lib.filterAttrs privateAllowed extensions);
}
