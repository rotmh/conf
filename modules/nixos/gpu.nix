{
  config,
  pkgs',
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  gpuType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        id = lib.mkOption {
          type = lib.types.str;
          example = "00:02.0";
        };
        cardPath = lib.mkOption {
          type = lib.types.str;
          default = "/dev/dri/by-path/pci-0000:${config.id}-card";
        };
      };
    }
  );

  cfg = config.${ns}.gpu;
in
{
  options.${ns}.gpu = {
    gpus = lib.mkOption {
      type = lib.types.attrsOf gpuType;
      default = { };
      description = ''
        GPU entries.
      '';
    };
  };
}
