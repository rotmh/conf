{
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  python3Packages,
  hyprcursor,

  baseColor ? "#000000",
  outlineColor ? "#FFFFFF",
  watchBackgroundColor ? "#000000",
}:

let
  baseColorPlaceholder = "#00FF00";
  outlineColorPlaceholder = "#0000FF";
  watchBackgroundColorPlaceholder = "#FF0000";
in

stdenvNoCC.mkDerivation rec {
  pname = "apple-hyprcursor";
  version = "v2.0.1";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "apple_cursor";
    rev = version;
    hash = "sha256-gWdumtTFeTOu//APtaf255v9Hx61H1KtCfWZ39wPkFo=";
  };

  nativeBuildInputs = [
    python3
    python3Packages.tomli
    python3Packages.tomli-w
    hyprcursor.out
  ];

  phases = [
    "unpackPhase"
    "configurePhase"
    "buildPhase"
    "installPhase"
  ];

  unpackPhase = ''
    runHook preUnpack

    cp $src/configs/x.build.toml config.toml

    cp -r $src/svg cursors

    chmod -R u+w .

    runHook postUnpack
  '';

  configurePhase = ''
    runHook preConfigure

    cat << EOF > manifest.hl
    name = Apple-Hyprcursor
    description = Apple Cursor theme packaged for hyprcursor.
    version = ${version}
    cursors_directory = cursors
    EOF

    find cursors -type f -name "*.svg" |
      xargs sed -i \
        -e "s/${baseColorPlaceholder}/${baseColor}/g" \
        -e "s/${outlineColorPlaceholder}/${outlineColor}/g" \
        -e "s/${watchBackgroundColorPlaceholder}/${watchBackgroundColor}/g"

    python ${./configure.py} config.toml cursors

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    hyprcursor-util --create . --output .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r theme_Apple-Hyprcursor $out/share/icons/Apple-Hyprcursor

    runHook postInstall
  '';
}
