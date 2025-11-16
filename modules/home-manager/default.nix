{ lib, ... }:

with builtins;

let
  dir = ./.;
  entries = readDir dir;
  validFile = name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";
  validDir = name: type: type == "directory" && pathExists "${dir}/${name}/default.nix";
  mapEntry =
    name: type:
    if validFile name type then
      [ "${dir}/${name}" ]
    else if validDir name type then
      [ "${dir}/${name}/default.nix" ]
    else
      [ ];
in

{
  imports = concatLists (map mapEntry entries);
}
