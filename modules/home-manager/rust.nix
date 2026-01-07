{
  config,
  pkgs,
  lib,
  lib',
  inputs,
  ...
}:
let
  ns = lib'.modulesNamespace;

  cfg = config.${ns}.dev.rust;
in
{
  options.${ns}.dev.rust = {
    enable = lib.mkEnableOption "Rust";
  };

  config = lib.mkIf cfg.enable {
    ${ns}.impermanence.directories = [
      ".cargo"
    ];

    home.packages = with pkgs; [
      (inputs.fenix.packages.${stdenv.hostPlatform.system}.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rust-std"
        "rustc"
        "rustfmt"
      ])
      (inputs.fenix.packages.${stdenv.hostPlatform.system}.rust-analyzer)

      cargo-expand
      cargo-watch
      cargo-flamegraph
    ];
  };
}
