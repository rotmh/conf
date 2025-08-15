{ pkgs, ... }:
{
  home.packages = [
    # See: <https://github.com/NixOS/nixpkgs/issues/155092#issuecomment-2250032204>
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
        mv $out/share/applications/vlc.desktop{,.orig}
        substitute $out/share/applications/vlc.desktop{.orig,} \
          --replace-fail Exec=${pkgs.vlc}/bin/vlc Exec=$out/bin/vlc
      '';
    })
  ];
}
