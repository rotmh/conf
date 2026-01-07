let
  info = import ./info.nix;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      wallpaper = [
        {
          monitor = "";
          path = toString info.wallpaper;
        }
      ];
    };
  };
}
