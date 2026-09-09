## Install 
To install, clone this repository into `$HOME/source/system-setup`.
All the paths are currently still under the name system-setup & it is important to keep it this way for now.

## Home backup

Requires Bash, restic, OpenSSH and the usual Linux coreutils. Run from any directory:

```bash
~/source/system-setup/scripts/backup.sh --dry-run  # preview the existing repository
~/source/system-setup/scripts/backup.sh            # create a snapshot
~/source/system-setup/scripts/backup.sh --init     # only when creating a NEW repository
```

The destination is `sftp:storage@nas:/backup/$(hostname -s)`: `/backup/<short-hostname>`
as seen through the storage user's SFTP connection on the NAS. For this laptop it is
`sftp:storage@nas:/backup/laptop`, equivalent to `sftp://storage@nas//backup/laptop`.
The host filesystem's directory above the chroot is not part of the SFTP path.
SSH asks for the storage login password
when needed; restic separately asks for the repository encryption password. The
script stores neither password. Standard restic password environment variables
are also supported. Keep the repository encryption password available for restores.

The colored terminal header is followed by restic's live progress, including
elapsed time, processed bytes/files and the paths currently being read. The script
explicitly requests five updates per second, including in terminals restic does
not recognize. Override the rate with `RESTIC_PROGRESS_FPS` if desired.
ETA appears once the scan is complete and restic has a positive time estimate;
very fast dry runs or unchanged backups can finish without showing one.
Use `--verbose` to also print each file as it finishes. Progress measures processed
source data, not network throughput. Without a terminal, progress appears as
periodic log lines. `NO_COLOR=1` or `--no-color` disables the header colors.

Edit [scripts/backup.excludes](scripts/backup.excludes) to change the
exclusions. The script sets `BACKUP_HOME` for the patterns, normally to `$HOME`.
All of `source`, `.local`, `.rustup`, `.cargo`, `.npm`, `.codex`, `.cache` and
`.fontconfig` are excluded, along with downloaded installers and ISO files.
`.fonts` and `.config` are included, except the listed cache directories inside
`.config`. Symlinks are saved as links, without following them: restore the standard
`source/system-setup` checkout separately to supply linked fonts and dotfiles.
The backup script itself is in that excluded checkout, so keep it in Git.

`--dry-run` never initializes a repository or creates a snapshot, and disables
restic's cache and repository lock writes. It still needs an existing repository
and credentials. `--init` only initializes; it does not run a backup. Restic's exit
status is preserved, including status 3 for unreadable source data. There is no
automatic snapshot deletion or pruning.

For another destination or a test fixture, use `--repo REPO` and `--source DIR`.
Run the local integration test with:

```bash
python3 scripts/test-backup.py
```

## License

System-Setup was originally omarchy, released under the [MIT License](https://opensource.org/licenses/MIT).
But nothing really is left, since we start with [Dank Linux](https://danklinux.com) nowadays: 

```
curl -fsSL https://install.danklinux.com | sh
```

System-Setup is licensed under the [MIT License](https://opensource.org/licenses/MIT).
