{
  programs.fish = {
    enable = true;

    generateCompletions = true;

    interactiveShellInit = ''
      set -U fish_greeting
    '';

    shellAbbrs = {
      h = "hx .";
    };

    shellAliases = {
      grep = "grep --color=auto";

      ls = "ls --color=auto --hyperlink=auto -F";
      ll = "ls -lAh";
    };
  };
}
