{
  pkgs,
  pkgs',
  lib,
  inputs,
  config,
  ...
}:
let
  profileName = "default";
  homeDir = config.home.homeDirectory;
in
{
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    policies = {
      BlockAboutConfig = true;
      DisableTelemetry = true;
      DefaultDownloadDirectory = "${homeDir}/downloads";
    };

    profiles.${profileName} = {
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
            "ddg" = {
              urls = [
                {
                  template = "https://duckduckgo.com";
                  params = lib.attrsToList {
                    "q" = "{searchTerms}";
                  };
                }
              ];
              definedAliases = [ ",d" ];
            };
            "google" = {
              urls = [
                {
                  template = "https://google.com/search";
                  params = lib.attrsToList {
                    "q" = "{serachTerms}";
                  };
                }
              ];
              definedAliases = [ ",g" ];
            };
            "nixpkgs" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = lib.attrsToList {
                    "type" = "packages";
                    "query" = "{searchTerms}";
                  };
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ ",np" ];
            };
            "youtube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = lib.attrsToList {
                    "search_query" = "{searchTerms}";
                  };
                }
              ];
              definedAliases = [ ",yt" ];
            };
            "wikipedia" = {
              urls = [
                {
                  template = "https://en.wikipedia.org/wiki/Special:Search";
                  params = lib.attrsToList {
                    "search" = "{searchTerms}";
                  };
                }
              ];
              definedAliases = [ ",w" ];
            };
            "github" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = lib.attrsToList {
                    "q" = "{serachTerms}";
                  };
                }
              ];
              definedAliases = [ ",gh" ];
            };
            "github-code" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = lib.attrsToList {
                    "q" = "{serachTerms}";
                    "type" = "code";
                  };
                }
              ];
              definedAliases = [ ",ghc" ];
            };
          }
          // builtins.listToAttrs (map mkHidden hiddenEngines);
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
            name = "Netflix";
            tags = [ "entertainment" ];
            keyword = "ne";
            url = "https://netflix.com";
          }
          {
            name = "ChatGPT";
            tags = [
              "llm"
              "ai"
            ];
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
          return-youtube-dislikes
        ];
      };

      containersForce = true;

      containers = {
        "Personal" = {
          id = 0;
          color = "blue";
          icon = "fingerprint";
        };

        "Guest" = {
          id = 2;
          color = "green";
          icon = "chill";
        };
      };
    };
  };

  home.file.".mozilla/firefox/${profileName}/chrome".source = "${pkgs'.gwfox}/chrome";
}
