# sources:
# https://wiki.hypr.land/Configuring/Multi-GPU/
# https://github.com/CrispyTonkatsu/NixOs/blob/18865694d6b2737c9a3e5f970af5cd19c4baae1e/custom-packages/gpu-udev-finder.nix

{
  gpuVendorName ? throw "A GPU vendor name must be provided",
  symlinkName ? "${gpuVendorName}-gpu",

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
    GPU_ID=$(lspci -d ::03xx | grep -i ${gpuVendorName} | cut -f1 -d ' ')

    if [ -n "$GPU_ID" ]; then
      UDEV_RULE=$(cat <<-EOF
    KERNEL=="card*", \
    KERNELS=="0000:$GPU_ID", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/${symlinkName}"
    EOF
    )

      echo "$UDEV_RULE" >> "$RULE_PATH"
    fi
  '';
}
