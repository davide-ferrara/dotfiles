# Local voice dictation

Hex uses Parakeet v3 for local speech recognition and Ollama's `gemma4:e2b`
for Italian/English cleanup. The helpers remove hesitation sounds and extra
spaces, fix contextual recognition errors, and paste UTF-8 text using Hyprland's
explicit shortcut dispatch (Ctrl+Shift+V in terminals, Ctrl+V elsewhere).

The model stays loaded on the GPU. Correction has a 1.5-second deadline;
on timeout, the transcript still gets deterministic filler/space cleanup.
Number changes and substantial rewrites are rejected. No cloud API is used.

## Files

- `.local/bin/omarchy-dictation-hex`: recording and correction pipeline.
- `.local/bin/hex-refine-local`: Gemma model, prompt, cleanup and safeguards.
- `.local/bin/hex-paste-text`: clipboard insertion that preserves accents.
- `.config/systemd/user/hex-refine-warmup.service`: preload Gemma at login.
- `reference/settings.json`: Hex settings snapshot, without transcripts or logs.
- `reference/hex.service`: reference copy of the unit owned by Hex's installer.

`reference/` is excluded from Stow so Hex can manage its own service and data
files. These scripts and units target the existing `/home/dff` account.

## Restore

Install [Hex](https://github.com/anomalyco/hex/blob/dev/docs/linux.md) and
[Ollama](https://docs.ollama.com/linux) first. This setup also needs Hyprland
with Lua support, Python 3, jq, wl-clipboard and GNU coreutils.
The system Ollama service must be running.

From the repository root, with Hex stopped:

```bash
ollama pull gemma4:e2b
hex model install parakeet_v3 --language it
stow --no-folding --dir="$HOME/dotfiles" --target="$HOME" hex
cp --backup=numbered hex/reference/settings.json "$HOME/.local/share/hex/settings.json"
systemctl --user daemon-reload
systemctl --user enable hex.service hex-refine-warmup.service
hex start
systemctl --user start hex-refine-warmup.service
```

On an existing installation, move the three custom helper files and the warm-up
unit to a backup before Stow links their repository copies. Hex's installer
creates `hex.service`; its reference copy does not need to be installed.
The `hypr` package contains the keyboard bindings: Super+R and Super+Ctrl+X
toggle dictation; F9 records while held. Disable the previous backends:

```bash
systemctl --user disable --now hyprvoice.service voxtype.service
```

To bypass correction, create `~/.config/hex/refine-disabled`; remove that file
to enable it again. Model weights and dictation history are not stored here.
