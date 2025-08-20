{
  pkgs,
  inputs,
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
    rust-analyzer-nightly

    cargo-expand
    cargo-watch
    cargo-flamegraph
  ];
}
