{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:

stdenvNoCC.mkDerivation {
  pname = "gwfox";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "akkva";
    repo = "gwfox";
    rev = "a754dedbc66ede897e05e5e911db7604a9328d08";
    sha256 = "sha256-2OlfCOYvdnIOs3SyGC+cqzsSOFFDKcvmdHk8EvZ7CQg=";
  };

  patches = [
    ./remove-window-padding.patch
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
}
