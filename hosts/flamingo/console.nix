{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  console = {
    font = "JetBrainsMonoNL Nerd Font";
    keyMap = "us";
  };
}
