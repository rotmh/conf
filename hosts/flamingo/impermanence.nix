{
  config,
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

  boot.initrd.postResumeCommands = lib.mkAfter ''
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

  # Adapted from <https://github.com/nix-community/impermanence/issues/184#issuecomment-2199454423>.
  systemd.services."persist-home-create-root-paths" =
    let
      relevantUsers = lib.filterAttrs (_: user: user.createHome == true) config.users.users;
      createPersistentHome =
        user:
        let
          home = lib.escapeShellArg (persistentDir + user.home);
        in
        ''
          if [[ ! -d ${home} ]]; then
            echo "Persistent home root folder '${home}' not found, creating..."
            mkdir -p --mode=${user.homeMode} ${home}
            chown ${user.name}:${user.group} ${home}
          fi
        '';
    in
    {
      script = lib.concatLines (lib.mapAttrsToList (_: createPersistentHome) relevantUsers);
      unitConfig = {
        Description = "Ensure users' home folders exist in the persistent filesystem";
        PartOf = [ "local-fs.target" ];
        # The folder creation should happen after the persistent home path is mounted.
        After = [ "persist-home.mount" ];
      };

      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal";
        StandardError = "journal";
      };

      wantedBy = [ "local-fs.target" ];
    };

  programs.fuse.userAllowOther = true;

  # Otherwise it will re-lecture after every reboot.
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  environment.persistence.${persistentDir} = {
    # https://nixos.org/manual/nixos/stable/#ch-system-state
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log/journal"

      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];

    files = [
      "/etc/machine-id"
    ];
  };
}
