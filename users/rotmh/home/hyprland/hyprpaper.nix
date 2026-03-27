let
  info = import ./info.nix;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = toString info.wallpaper;
        }
      ];
    };
  };
}
