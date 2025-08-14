{ ... }:
{
  programs.alacritty = {
    enable = true;

    theme = "github_dark_tritanopia";

    settings = {
      window.decorations = "None";
      font.size = 10.5;
    };
  };
}
