{ config, lib, ... }:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.fonts;
in
{
  options.${ns}.fonts = {
    monospace = lib.mkOption {
      type = lib.types.str;
      example = "JetBrainsMonoNL Nerd Font";
    };

    packages = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf [ package ];
      example = lib.literalExpression ''
        [ nerd-fonts.jetbrains-mono ]
      '';
    };
  };

  config = {
    home.packages = cfg.packages;

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ cfg.monospace ];
      };
    };
  };
}
