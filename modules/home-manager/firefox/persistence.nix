{ defaultProfileName, ns, ... }:
{
  ${ns}.impermanence =
    let
      profile = ".mozilla/firefox/${defaultProfileName}";
    in
    {
      directories.symlink = [
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

        ".cache/mozilla/firefox/${defaultProfileName}"
      ];
    };
}
