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
in
{
  imports = [
    ../../../modules/home-manager

    ./hyprland
    ./waybar
    ./vlc.nix
    ./dev
    ./ssh.nix
  ];

  sops.secrets = {
    "gpg/private-key" = {
      sopsFile = ../secrets/system.yaml;
    };
  };

  ${ns} = {
    user = {
      fullname = "Rotem Horesh";
      email = "rotmh@proton.me";
      gpg = "B9106DFDF57A3F5A";
      editor = lib.getExe inputs.helix-git.packages.${pkgs.stdenv.hostPlatform.system}.helix;
    };

    fonts = {
      monospace = "JetBrainsMonoNL Nerd Font";

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

    sops.enable = true;

    impermanence = {
      enable = true;

      directories.symlink = [
        "projects"
        "forks"
        "conf"
        "bin"
        "media"
        "downloads"
        "documents"
      ];
    };

    firefox = {
      enable = true;
      createGuestProfile = true;
    };

    hledger = {
      enable = true;
      journal = "~/.hledger.journal";
    };

    gpg = {
      enable = true;

      publicKey = ../0xB9106DFDF57A3F5A.gpg;
      privateKey = config.sops.secrets."gpg/private-key".path;
    };

    fish.enable = true;
    # ssh.enable = true;
    git.enable = true;

    alacritty.enable = true;
    helix.enable = true;
    password-store.enable = true;
    stremio.enable = true;
    zoxide.enable = true;
    starship.enable = true;
  };

  home.packages = with pkgs; [
    avizo

    discord
    tor-browser

    chafa
    ueberzugpp

    syncthing
  ];

  programs.asciinema.enable = true;

  programs.tofi = {
    enable = true;

    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      font = "monospace";
      background-color = "#000A";
    };
  };

  programs.bat.enable = true;

  programs.yazi = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.ripgrep.enable = true;

  programs.nh.enable = true;

  home.stateVersion = "25.05";
}
