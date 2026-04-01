# sources:
# https://wiki.hypr.land/Configuring/Multi-GPU/
# https://github.com/CrispyTonkatsu/NixOs/blob/18865694d6b2737c9a3e5f970af5cd19c4baae1e/custom-packages/gpu-udev-finder.nix

{
  gpuId ? throw "A GPU id must be provided",
  symlinkName ? throw "A symlink name must be provided",

  stdenv,
  udevCheckHook,
  pciutils,
  ...
}:

stdenv.mkDerivation {
  pname = "gpu-udev-finder";
  version = "0.1.0";

  phases = [ "installPhase" ];

  nativeBuildInputs = [ pciutils ];

  nativeInstallCheckInputs = [ udevCheckHook ];
  doInstallCheck = true;

  installPhase = ''
    mkdir -p "$out/lib/udev/rules.d/"

    RULE_PATH="$out/lib/udev/rules.d/${symlinkName}-dev-path.rules"

    UDEV_RULE=$(cat <<-EOF
    KERNEL=="card*", \
    KERNELS=="0000:${gpuId}", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/${symlinkName}"
    EOF
    )

    echo "$UDEV_RULE" >> "$RULE_PATH"
  '';
}
