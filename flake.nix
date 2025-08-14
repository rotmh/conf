{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "nixos-hardware";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # fenix = {
    #   url = "github:nix-community/fenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    helix-git.url = "github:helix-editor/helix";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";

      lib' = import ./lib { inherit (nixpkgs) lib; };
    in
    {
      nixosConfigurations = {
        flamingo = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs lib';
          };

          modules = [
            ./hosts/flamingo
            ./users/rotmh
            ./devices/lenovo-thinkpad-p1-gen7
          ];
        };
      };
    };
}
