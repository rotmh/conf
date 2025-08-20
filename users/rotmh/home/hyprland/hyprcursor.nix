{ pkgs', ... }:
let
  cursorName = "Apple-Hyprcursor";
  cursorSize = 24;
in
{
  home.packages = [ pkgs'.apple-hyprcursor ];

  xdg.dataFile."icons/${cursorName}".source = "${pkgs'.apple-hyprcursor}/share/icons/${cursorName}";

  home.sessionVariables = {
    HYPRCURSOR_THEME = cursorName;
    HYPRCURSOR_SIZE = cursorSize;
  };
}
