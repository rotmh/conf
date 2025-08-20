{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (inputs.fenix.packages.${system}.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rust-std"
      "rustc"
      "rustfmt"
    ])
    (inputs.fenix.packages.${system}.rust-analyzer)

    cargo-expand
    cargo-watch
    cargo-flamegraph
  ];
}
