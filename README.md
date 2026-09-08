## Install 
To install, clone this repository into `$HOME/source/system-setup`.
All the paths are currently still under the name system-setup & it is important to keep it this way for now.

GNOME settings are stored as a user-wide text-backed dconf database in the
`gnome` dotfiles package. Run `./scripts/setup-gnome.sh`, then log out and back
in so the `DCONF_PROFILE` environment variable applies to the whole session.
The setup script preserves an existing binary database as
`~/.config/dconf.binary.bak` before linking the tracked text database.

## SSH configuration

Stow the SSH config from the dotfiles directory:

```sh
cd ~/source/system-setup/dotfiles
stow ssh
```

If `~/.ssh/config` already exists, merge any settings you want to keep into
`dotfiles/ssh/.ssh/config`, then move the existing file aside before running Stow.
The package configures `ssh nas` to use `~/.ssh/internal`. Keep private keys in
`~/.ssh`; they are not part of this package.

## License

System-Setup was originally omarchy, released under the [MIT License](https://opensource.org/licenses/MIT).
But nothing really is left, since we start with [Dank Linux](https://danklinux.com) nowadays: 

```
curl -fsSL https://install.danklinux.com | sh
```

System-Setup is licensed under the [MIT License](https://opensource.org/licenses/MIT).
