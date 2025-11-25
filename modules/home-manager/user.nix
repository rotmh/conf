{
  config,
  lib,
  lib',
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.user;
in
{
  options.${ns}.user = {
    fullname = lib.mkOption {
      type = lib.types.str;
      example = "John Doe";
    };

    email = lib.mkOption {
      type = lib.types.str;
      example = "user@example.com";
    };

    gpg = lib.mkOption {
      type = lib.types.str;
    };

    editor = lib.mkOption {
      type = lib.types.str;
      example = "nvim";
    };
  };

  config = { };
}
