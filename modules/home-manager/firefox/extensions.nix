# To find settings in Firefox, make changes to the extension, go to
# about:debugging#/runtime/this-firefox, inspect the extension, then run:
#
#  await browser.storage.sync.get(null);
#  await browser.storage.local.get(null);

{ lib }:
{
  ublock-origin = {
    id = "uBlock0@raymondhill.net";
    privateAllowed = true;
    settings = {
      selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "ublock-quick-fixes"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
      ];
    };
    permissions = [
      "alarms"
      "dns"
      "menus"
      "privacy"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "http://*/*"
      "https://*/*"
      "file://*/*"
      "https://easylist.to/*"
      "https://*.fanboy.co.nz/*"
      "https://filterlists.com/*"
      "https://forums.lanik.us/*"
      "https://github.com/*"
      "https://*.github.io/*"
      "https://github.com/uBlockOrigin/*"
      "https://ublockorigin.github.io/*"
      "https://*.reddit.com/r/uBlockOrigin/*"
    ];
  };

  vimium-c = {
    id = "vimium-c@gdh1995.cn";
    privateAllowed = true;
    settings = {
      exclusionRules = [
        {
          passKeys = "f";
          pattern = "^https?://[^/]*netflix.com/watch";
        }
        {
          passKeys = "f";
          pattern = "^https?://[^/]*youtube.com/watch";
        }
      ];
    };
  };

  sponsorblock =
    let
      categorySkipOption = {
        fallbackToDefault = -2;
        disabled = -1;
        showOverlay = 0;
        manualSkip = 1;
        autoSkip = 2;
      };
      categorySelections = {
        sponsor = categorySkipOption.autoSkip;
        interaction = categorySkipOption.autoSkip;
        selfpromo = categorySkipOption.autoSkip;

        poi_highlight = categorySkipOption.showOverlay;
        intro = categorySkipOption.showOverlay;
        outro = categorySkipOption.showOverlay;
      };
    in
    {
      id = "sponsorBlocker@ajay.app";
      settings = {
        alreadyInstalled = true;
        categorySelections = lib.mapAttrsToList (name: option: { inherit name option; }) categorySelections;
      };
      permissions = [
        "storage"
        "scripting"
        "https://sponsor.ajay.app/*"
        "https://*.youtube.com/*"
        "https://www.youtube-nocookie.com/embed/*"
      ];
    };

  simple-translate = {
    id = "simple-translate@sienori";
    settings = {
      Settings = {
        ifChangeSecondLang = true;
        ifChangeSecondLangOnPage = true;
        ifCheckLang = true;
        ifShowCandidate = true;
        ifShowMenu = true;
        isShowOptionsPageWhenUpdated = false;
        panelReferencePoint = "bottomSelectedText";
        targetLang = "en";
        secondTargetLang = "he";
        theme = "system";
        translationApi = "google";
        waitTime = 300;
        whenSelectText = "showButton";
      };
    };
  };

  refined-github = {
    id = "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}";
    settings = {
      welcomed = true;
      personalToken = "";
    };
  };

  return-youtube-dislikes = {
    id = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
  };

  youtube-shorts-block = {
    id = "{34daeb50-c2d2-4f14-886a-7160b24d66a4}";
  };
}
