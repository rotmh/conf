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
    rev = "d0dfd0e6491653f4bc71369a7a129277612ef43a";
    sha256 = "sha256-1UQnR8f4lAuXR5J8RWGc9c7fSy1j8a0kC0YxkjkbM9w=";
  };

  patches = [
    ./remove-window-padding.patch
  ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
}
