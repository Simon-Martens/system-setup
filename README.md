## Install 
To install, clone this repository into `$HOME/source/system-setup`.
All the paths are currently still under the name system-setup & it is important to keep it this way for now.

GNOME settings are stored as a user-wide text-backed dconf database in the
`gnome` dotfiles package. Run `./scripts/setup-gnome.sh`, then log out and back
in so the `DCONF_PROFILE` environment variable applies to the whole session.
The setup script preserves an existing binary database as
`~/.config/dconf.binary.bak` before linking the tracked text database.

## License

System-Setup was originally omarchy, released under the [MIT License](https://opensource.org/licenses/MIT).
But nothing really is left, since we start with [Dank Linux](https://danklinux.com) nowadays: 

```
curl -fsSL https://install.danklinux.com | sh
```

System-Setup is licensed under the [MIT License](https://opensource.org/licenses/MIT).
