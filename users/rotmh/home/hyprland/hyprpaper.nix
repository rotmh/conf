let
  info = import ./info.nix;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [ "${info.wallpaper}" ];
      wallpaper = [ ",${info.wallpaper}" ];
    };
  };
}
