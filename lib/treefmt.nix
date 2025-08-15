{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt = {
      enable = true;
      # strict = true;
    };
  };

  settings = {
    global.includes = [
      "*.nix"
    ];
  };
}
