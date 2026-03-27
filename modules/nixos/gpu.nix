{
  config,
  pkgs',
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.gpu;
in
{
  options.${ns}.gpu = {
    symlinks = {
      enable = lib.mkEnableOption "Create symlinks for GPUs";

      gpus = lib.mkOption {
        type =
          with lib.types;
          listOf (submodule {
            options = {
              vendor = lib.mkOption {
                type = str;
              };

              symlink = lib.mkOption {
                type = str;
                default = "${cfg.symlinks.gpus.vendor}-gpu";
                description = ''
                  The name for the symlink filename. e.g., if it's GPU, the
                  symlink will be at {path}`/dev/dri/GPU`.
                '';
              };
            };
          });
        default = [ ];
        description = ''
          List of GPU names to create symlinks for.
        '';
      };
    };
  };

  config = (
    lib.mkMerge [
      (lib.mkIf cfg.symlinks.enable {
        services.udev.packages =
          let
            symlinkFor =
              { vendor, symlink }:
              pkgs'.gpu-udev-finder.override {
                gpuVendorName = vendor;
                symlinkName = symlink;
              };
          in
          map symlinkFor cfg.symlinks.gpus;
      })
    ]
  );
}
