{ lib, pkgs, ... }:
let
  config = ''
    { .from_key = KEY_CAPSLOCK, .to_key = KEY_ESC },
  '';
  c2e = pkgs.stdenv.mkDerivation {
    name = "c2e";

    src = pkgs.fetchFromGitHub {
      owner = "zsugabubus";
      repo = "interception-k2k";
      rev = "5746bf39a321610bb6019781034f82e4c6e21e97";
      hash = "sha256-q2zlOvyW5jlasEIPVc+k6jh2wJZ7sUEpvXh/leH/hKw=";
    };

    configurePhase = ''
      mkdir -p ./in/c2e
      echo "${config}" > ./in/c2e/map-rules.h.in
    '';

    makeFlags = [
      "OUT_DIR=$(out)"
      "INSTALL_DIR=$(out)/bin"
      "CONFIG_DIR=./in"
    ];

    meta = {
      description = "Map CAPSLOCK to ESC (without CTRL shenanigans)";
      mainProgram = "c2e";
    };
  };
in
{
  services.interception-tools = {
    enable = true;

    udevmonConfig =
      let
        intercept = lib.getExe' pkgs.interception-tools "intercept";
        uinput = lib.getExe' pkgs.interception-tools "uinput";
        plugin = lib.getExe c2e;
      in
      ''
        - JOB: "${intercept} -g $DEVNODE | ${plugin} | ${uinput} -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
  };
}
