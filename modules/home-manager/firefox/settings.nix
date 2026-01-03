{ config, ... }:
{
  # Settings for gwfox
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "svg.context-properties.content.enabled" = true;
  "widget.windows.mica" = true;
  "widget.windows.mica.toplevel-backdrop" = 2;
  "sidebar.animation.enabled" = false;
  "gwfox.plus" = true;
  "gwfox.atbc" = true;

  "browser.quitShortcut.disabled" = true; # disable ctrl+q

  "browser.tabs.warnOnClose" = true;
  "browser.tabs.warnOnCloseOtherTabs" = true;
  "browser.tabs.warnOnQuit" = true;

  "signon.rememberSignons" = false; # don't ask to save passwords

  # Automatically enable extensions installed with home-manager
  "extensions.autoDisableScopes" = 0;
  "extensions.update.autoUpdateDefault" = false;
  "extensions.update.enabled" = false;

  "extensions.htmlaboutaddons.recommendations.enabled" = false;

  # Disable Pocket
  "browser.urlbar.suggest.pocket" = false;
  "extensions.pocket.enabled" = false;

  "findbar.highlightAll" = true; # default Ctrl-F to highlight all results by default

  # Downloads settings
  "browser.download.always_ask_before_handling_new_types" = true; # ask whether to "open" or to "save"
  "browser.download.start_downloads_in_tmp_dir" = true; # if "open" selected: save in tmp dir
  "browser.download.useDownloadDir" = false; # if "save" selected: ask where to save

  # Disable some telemetry
  "app.shield.optoutstudies.enabled" = false;
  "browser.discovery.enabled" = false;
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  "browser.ping-centre.telemetry" = false;
  "datareporting.healthreport.service.enabled" = false;
  "datareporting.healthreport.uploadenabled" = false;
  "datareporting.policy.datasubmissionenabled" = false;
  "datareporting.sessions.current.clean" = true;
  "devtools.onboarding.telemetry.logged" = false;
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.bhrping.enabled" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.firstshutdownping.enabled" = false;
  "toolkit.telemetry.hybridcontent.enabled" = false;
  "toolkit.telemetry.newprofileping.enabled" = false;
  "toolkit.telemetry.prompted" = 2;
  "toolkit.telemetry.rejected" = true;
  "toolkit.telemetry.reportingpolicy.firstrun" = false;
  "toolkit.telemetry.server" = "";
  "toolkit.telemetry.shutdownpingsender.enabled" = false;
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.unifiedisoptin" = false;
  "toolkit.telemetry.updateping.enabled" = false;

  # New tab page junk
  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
  "browser.newtabpage.activity-stream.feeds.weatherfeed" = false;
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.showWeather" = false;
  "browser.newtabpage.activity-stream.system.showSponsored" = false;
  "browser.newtabpage.activity-stream.system.showWeather" = false;
  "browser.newtabpage.activity-stream.weather.locationSearchEnabled" = false;
  "browser.newtabpage.enabled" = false;

  # Disable irritating first-run stuff
  "browser.disableresetprompt" = true;
  "browser.download.panel.shown" = true;
  "browser.feeds.showfirstrunui" = false;
  "browser.messaging-system.whatsnewpanel.enabled" = false;
  "browser.rights.3.shown" = true;
  "browser.shell.checkdefaultbrowser" = false;
  "browser.shell.defaultbrowsercheckcount" = 1;
  "browser.startup.homepage_override.mstone" = "ignore";
  "browser.uitour.enabled" = false;
  "startup.homepage_override_url" = "";
  "trailhead.firstrun.didseeaboutwelcome" = true;
  "browser.bookmarks.restore_default_bookmarks" = false;
  "browser.bookmarks.addedimportbutton" = true;
  "browser.shell.checkDefaultBrowser" = false; # don't check if default browser

  # Enforce dark theme
  "devtools.theme" = "dark";
  "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

  "browser.startup.homepage" = "about:blank";
  "browser.newtab.url" = "about:blank";

  # Don't create $HOME/Downloads dir.
  "browser.download.folderList" = 2;
  "browser.download.dir" = "${config.home.homeDirectory}/downloads";

  "media.ffmpeg.vaapi.enabled" = true;
  "media.ffvpx.enabled" = false;
  "gfx.webrender.all" = true;
}
