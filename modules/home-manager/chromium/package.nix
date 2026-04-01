{ pkgs, enableWideVine, ... }:

pkgs.ungoogled-chromium.override {
  inherit enableWideVine;
}
