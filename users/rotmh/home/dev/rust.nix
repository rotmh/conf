{
  pkgs,
  inputs,
  ...
}:
{
  nix.settings = {
    extra-substituters = [ "https://nix-community.cachix.org/" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
