profileName:
{ config, ... }:
{
  home.persistence."/persistent/home/${config.home.username}" =
    let
      profile = ".mozilla/firefox/${profileName}";
    in
    {
      directories = [
        "${profile}/extensions/"
        "${profile}/storage/default/"
      ];
      files = [
        "${profile}/cookies.sqlite"
        "${profile}/favicons.sqlite"
        "${profile}/permissions.sqlite"
        "${profile}/content-prefs.sqlite"
        "${profile}/places.sqlite"
        "${profile}/prefs.js"
        "${profile}/storage.sqlite"

        ".cache/mozilla/firefox/default"
      ];
    };
}
