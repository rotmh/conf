{ pkgs, ... }:
{
  modulesNamespace = "custom";

  types = {
    sopsKey = pkgs.lib.types.str;
  };
}
