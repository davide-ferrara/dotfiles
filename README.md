# .files

Install the symlinks:

```bash
stow --no-folding --dir="$HOME/dotfiles" --target="$HOME" nvim hypr omarchy alacritty foot ghostty kitty hex
```

See [the local dictation setup](hex/README.md) for Hex/Gemma dependencies and restore steps.

## Strata file manager

The Hyprland bindings already launch Strata with Super+Shift+F (or
Super+Alt+Shift+F for the terminal's current directory). Install Strata from
its [official repository](https://github.com/lgse/strata); the bindings expect
`~/.local/bin/strata`.

A snapshot of the Strata preferences is stored in
`strata/.config/strata/settings.toml`. To restore it after installing Strata,
close Strata and copy that file to `~/.config/strata/settings.toml`. Strata
writes its own settings, so update the repository copy when preferences change.
Tabs, recent files, portal state, and system file-manager associations are not
included; configure desktop integration through the Strata installer or settings.
