{ pkgs, ... }:
{
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  environment.systemPackages = with pkgs; [
    pinentry-curses
  ];
}
