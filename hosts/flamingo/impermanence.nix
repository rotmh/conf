{
  inputs,
  lib,
  ...
}:
let
  persistentDir = "/persistent";
in
{
  imports = [
    inputs.impermanence.nixosModules.default
  ];

  boot.initrd.postResumeCommands =
    lib.mkAfter
      # syntax: bash
      ''
        mkdir /btrfs_tmp
          mount /dev/disk/by-partlabel/disk-main-root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
      '';

  programs.fuse.userAllowOther = true;

  # Otherwise it will re-lecture after every reboot.
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  environment.persistence.${persistentDir} =
    let
      # See <https://nixos.org/manual/nixos/stable/#ch-system-state>.
      requiredSystemState = {
        directories = [
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/log/journal"
        ];
        files = [
          "/etc/machine-id"
        ];
      };
    in
    {
      hideMounts = true;
      directories = [ "/var/lib/bluetooth" ] ++ requiredSystemState.directories;
      files = [ ] ++ requiredSystemState.files;
    };
}
