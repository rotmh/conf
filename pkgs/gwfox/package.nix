{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:

stdenvNoCC.mkDerivation {
  pname = "gwfox";
  version = "2.7.19";

  src = fetchFromGitHub {
    owner = "akkva";
    repo = "gwfox";
    rev = "2ea734ce0ee65b31bcc57a58a8956c0db9a15f2c"; # 2.7.19
    sha256 = "sha256-p8eNbGNy/sxMBJ0GEJ3sFMCCehqMwrzs9rhFb6Vg6pY=";
  };

  patches = [
    ./remove-window-padding.patch
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
}
