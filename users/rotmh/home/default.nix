{
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
    inputs.self.homeManagerModules.default

    ./hyprland
    ./waybar
    ./vlc.nix
    ./dev
  ];

  sops.secrets = {
    "gpg/private-key".sopsFile = ../secrets/system.yaml;
    "gpg/passphrase".sopsFile = ../secrets/system.yaml;

    "ssh/public-key".sopsFile = ../secrets/system.yaml;
    "ssh/private-key".sopsFile = ../secrets/system.yaml;
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

      directories = [
        "projects"
        "forks"
        "conf"
        "bin"
        "media"
        "downloads"
        "documents"
        "VirtualBox VMs"

        ".local/state/wireplumber"
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
      privateKey = "gpg/private-key";
      passphrase = "gpg/passphrase";
    };

    ssh = {
      enable = true;

      publicKey = "ssh/public-key";
      privateKey = "ssh/private-key";
    };

    clipse.enable = true;
    fish.enable = true;
    git.enable = true;
    alacritty.enable = true;
    helix.enable = true;
    password-store.enable = true;
    stremio.enable = true;
    zoxide.enable = true;
    starship.enable = true;
    direnv.enable = true;

    vscode.enable = true;
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

  services.dunst.enable = true;

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
