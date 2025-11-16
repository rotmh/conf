{
  lib,
  config,
  inputs,
  ...
}:
let
  ns = import ../namespace.nix;

  cfg = config.${ns}.impermanence;
  username = config.home.username;
in
{
  options.${ns}.impermanence = {
    enable = lib.mkEnableOption "Impermanence";

    path = lib.mkOption {
      type = lib.types.str;
      default = "/persistent/home/${username}";
      description = ''
        Path to persist in.
      '';
    };

    directories = {
      bindfs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Directories to persist using bindfs.
        '';
      };
      symlink = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Directories to persist via a symlink.
        '';
      };
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Files to persist.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [
      inputs.impermanence.homeManagerModules.default
    ];

    # https://github.com/nix-community/impermanence/issues/256#issue-2825793622
    home.activation.fixPathForImpermanence = lib.hm.dag.entryBefore [ "cleanEmptyLinkTargets" ] ''
      PATH=$PATH:/run/wrappers/bin
    '';

    home.persistance.${cfg.path} = {
      directories =
        let
          withMethod = method: directory: { inherit directory method; };
        in
        lib.flatten [
          (map (withMethod "symlink") cfg.directories.symlink)
          (map (withMethod "bindfs") cfg.directories.bindfs)
        ];

      files = cfg.files;

      allowOther = true;
    };
  };
}
