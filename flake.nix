{
  description = "My systems";

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

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix-git.url = "github:helix-editor/helix";

    # qt5 has been flagged as unmaintained and insecure, so we must explicitly
    # permit its usage to run Stremio. However, since insecure packages are not
    # built by Hydra once marked with known vulnerabilities, we use a pinned,
    # older nixpkgs revision from before that change. This ensures Hydra can
    # provide prebuilt binaries, since building qt5 locally is too heavy.
    nixpkgs-for-stremio.url = "nixpkgs/fdaf9ac0214d7dea1b3e573434cd96c0d10c9d76";

    nixohess.url = "gitlab:fazzi/nixohess/352e5b16030355ee81b1d4971ffa5a83b7ca8dfc";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs' = self.packages.${system};
      lib' = import ./lib { inherit pkgs; };
    in
    {
      packages.${system} = pkgs.lib.packagesFromDirectoryRecursive {
        callPackage = pkgs.lib.callPackageWith pkgs;
        directory = ./pkgs;
      };

      nixosConfigurations = {
        flamingo = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs pkgs' lib'; };

          modules = [
            ./hosts/flamingo
            ./users/rotmh
            ./devices/lenovo-thinkpad-p1-gen7
          ];
        };
      };

      homeManagerModules.default = import ./modules/home-manager { inherit inputs pkgs' lib'; };
      nixosModules.default = import ./modules/nixos { inherit inputs pkgs' lib'; };

      maintainers = {
        rotmh = {
          name = "Rotem Horesh";
          github = "rotmh";
          githubId = 148942120;
        };
      };
    };
}
