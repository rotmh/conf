{ lib, ... }:
{
  default = "ddg";
  force = true;
  engines =
    let
      hiddenEngines = [
        "amazondotcom-us"
        "bing"
        "ebay"
      ];
      mkHidden = name: {
        name = name;
        value.metaData.hidden = true;
      };
    in
    {
      ddg.metaData.alias = ",d";
      google.metaData.alias = ",g";
      wikipedia.metaData.alias = ",w";

      nixos-wiki = {
        name = "NixOS Wiki";
        urls = [
          {
            template = "https://wiki.nixos.org/w/index.php";
            params = lib.attrsToList { "search" = "{searchTerms}"; };
          }
        ];
        definedAliases = [ ",nw" ];
        iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
      };

      nix-packages = {
        name = "Nixpkgs";
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = lib.attrsToList { "query" = "{searchTerms}"; };
          }
        ];
        definedAliases = [ ",np" ];
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
      };

      nixos-options = {
        name = "NixOS Options";
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = lib.attrsToList { "query" = "{searchTerms}"; };
          }
        ];
        definedAliases = [ ",no" ];
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
      };

      nix-flakes = {
        name = "Nix Flakes";
        urls = [
          {
            template = "https://search.nixos.org/flakes";
            params = lib.attrsToList { "query" = "{searchTerms}"; };
          }
        ];
        definedAliases = [ ",nf" ];
        iconMapObj."16" = "https://search.nixos.org/favicon.png";
      };

      youtube = {
        urls = [
          {
            template = "https://www.youtube.com/results";
            params = lib.attrsToList { "search_query" = "{searchTerms}"; };
          }
        ];
        definedAliases = [ ",yt" ];
        iconMapObj."16" = "https://youtube.com/favicon.ico";
      };

      github = {
        name = "GitHub";
        urls = [
          {
            template = "https://github.com/search";
            params = lib.attrsToList { "q" = "{searchTerms}"; };
          }
        ];
        iconMapObj."16" = "https://github.com/favicon.ico";
        definedAliases = [ ",gh" ];
      };

      github-code = {
        name = "GitHub Code";
        urls = [
          {
            template = "https://github.com/search";
            params = lib.attrsToList {
              "q" = "{searchTerms}";
              "type" = "code";
            };
          }
        ];
        iconMapObj."16" = "https://github.com/favicon.ico";
        definedAliases = [ ",ghc" ];
      };

      chatgpt = {
        name = "ChatGPT";
        urls = [
          {
            template = "https://chatgpt.com/";
            params = lib.attrsToList { "q" = "{searchTerms}"; };
          }
        ];
        iconMapObj."16" = "https://chatgpt.com/favicon.ico";
        definedAliases = [ ",ch" ];
      };

      crates-io = {
        name = "Crates.io";
        urls = [
          {
            template = "https://crates.io/search";
            params = lib.attrsToList { "q" = "{searchTerms}"; };
          }
        ];
        icon = "https://crates.io/assets/cargo.png";
        definedAliases = [ ",cr" ];
      };
    }
    // builtins.listToAttrs (map mkHidden hiddenEngines);
}
