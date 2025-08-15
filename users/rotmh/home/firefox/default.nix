{
  pkgs,
  inputs,
  config,
  ...
}:
let
  username = config.home.username;

  gwfox = pkgs.stdenv.mkDerivation {
    pname = "gwfox-patched";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "akkva";
      repo = "gwfox";
      rev = "2ea734ce0ee65b31bcc57a58a8956c0db9a15f2c"; # 2.7.19
      sha256 = "sha256-p8eNbGNy/sxMBJ0GEJ3sFMCCehqMwrzs9rhFb6Vg6pY=";
    };

    patches = [
      ./gwfox-remove-window-padding.patch
    ];

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in
{
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    policies = {
      BlockAboutConfig = true;
      DisableTelemetry = true;
    };

    profiles.${username} = {
      settings = {
        # Settings for gwfox
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "widget.windows.mica" = true;
        "widget.windows.mica.toplevel-backdrop" = 2;
        "sidebar.animation.enabled" = false;
        "gwfox.plus" = true;
        "gwfox.atbc" = true;

        "browser.bookmarks.restore_default_bookmarks" = false; # don't restore default bookmarks
        "browser.quitShortcut.disabled" = true; # disable ctrl+q
        "browser.shell.checkDefaultBrowser" = false; # don't check if default browser

        "browser.tabs.warnOnClose" = true;
        "browser.tabs.warnOnCloseOtherTabs" = true;
        "browser.tabs.warnOnQuit" = true;
      };

      search = {
        default = "ddg";
        force = true;
        engines = {
          "amazondotcom-us".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;

          "ddg" = {
            urls = [
              {
                template = "https://duckduckgo.com";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",d" ];
          };
          "google" = {
            urls = [
              {
                template = "https://google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",g" ];
          };
          "nixpkgs" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",ns" ];
          };
          "youtube" = {
            urls = [
              {
                template = "https://www.youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",yt" ];
          };
          "wikipedia" = {
            urls = [
              {
                template = "https://en.wikipedia.org/wiki/Special:Search";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",w" ];
          };
          "github" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ ",gh" ];
          };
        };
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "GitHub";
            tags = [
              "git"
              "scm"
            ];
            keyword = "gh";
            url = "https://github.com";
          }
          {
            name = "YouTube";
            tags = [ "entertainment" ];
            keyword = "yo";
            url = "https://youtube.com";
          }
          {
            name = "ChatGPT";
            tags = [ "llm" ];
            keyword = "ch";
            url = "https://chatgpt.com";
          }
        ];
      };

      extensions = {
        force = true;

        packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          sponsorblock
          youtube-shorts-block
          # darkreader
          vimium
          refined-github
          simple-translate
        ];

        settings = {
        };
      };
    };
  };

  home.file.".mozilla/firefox/${username}/chrome".source = "${gwfox}/chrome";
}
