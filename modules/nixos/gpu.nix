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
    { name, ... }:
    {
      options = {
        id = lib.mkOption {
          type = lib.types.str;
          example = "00:02.0";
        };

        symlinkPath = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
        };
      };

      config = {
        symlinkPath = "/dev/dri/${name}";
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

  config = {
    services.udev.packages =
      let
        symlinkFor =
          name:
          { id, ... }:
          pkgs'.gpu-udev-finder.override {
            gpuId = id;
            symlinkName = name;
          };
      in
      lib.mapAttrsToList symlinkFor cfg.gpus;
  };
}
