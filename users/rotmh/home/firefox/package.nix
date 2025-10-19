{ pkgs, ... }:
let
  ctrl_n_and_p_navigation_in_search_bar = pkgs.fetchpatch {
    name = "navigating_up_and_down_with_C-p_C-n.patch";
    url = "https://raw.githubusercontent.com/natask/firefox-tor-remap-C-n-and-C-p-for-search-bar-navigation/58603b9911ee037d94cb6329250301fe6a511e0c/navigating_up_and_down_with_C-p_C-n.patch";
    hash = "sha256-kaAZg1Zhlrj23JeupgLrJs4YXZN1XreVRM8KnsyQsTw=";
  };
in
pkgs.firefox.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    ctrl_n_and_p_navigation_in_search_bar
  ];
})
