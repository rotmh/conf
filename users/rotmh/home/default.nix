{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  ns = import ../../../modules/namespace.nix;
in
{
  imports = [
    ../../../modules/home-manager

    ./hyprland
    ./waybar
    ./vlc.nix
    ./dev
  ];

  ${ns} = {
    user = {
      fullname = "Rotem Horesh";
      email = "rotmh@proton.me";
      gpg = "B9106DFDF57A3F5A";
      editor = lib.getExe inputs.helix-git.packages.${pkgs.system}.default;
    };

    fonts = {
      monospace = "JetBrainsMonoNL Nerd Font";

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

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

    sops.enable = true;

    fish.enable = true;
    ssh.enable = true;
    gpg.enable = true;
    git.enable = true;

    alacritty.enable = true;
    helix.enable = true;
    password-store.enable = true;
    stremio.enable = true;
    hledger.enable = true;
    zoxide.enable = true;
    starship.enable = true;
  };

  home.packages = with pkgs; [
    avizo

    discord
    tor-browser-bundle-bin

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
