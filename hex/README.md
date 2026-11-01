# Local voice dictation

**Hex → Parakeet v3 → Gemma 4 E2B → UTF-8 clipboard paste**, replacing
Hyprvoice/Voxtype. Recognition defaults to Italian; cleanup preserves Italian,
English and mixed speech without translation. Everything runs locally.

Gemma outperformed Qwen on our name, grammar and number tests. Its prompt uses
sentence context, removes fillers/false starts and preserves meaning.
Extra spaces and clear hesitation noises are removed independently of the LLM.
GPU-resident, non-thinking correction measured ~0.5–0.6 seconds on an RTX 3060.
A 1.5-second deadline, errors, truncation, changed numbers or substantial
rewrites trigger fallback to the cleaned original transcript.

Clipboard paste fixes accents lost during simulated typing. Hyprland sends
explicit key-down/up events: Ctrl+Shift+V for `terminal`-tagged windows,
Ctrl+V elsewhere.

## Files

- `.local/bin/omarchy-dictation-hex`: recording, correction deadline, insertion.
- `.local/bin/hex-refine-local`: model, bilingual prompt, cleanup and validation.
- `.local/bin/hex-paste-text`: Unicode clipboard and paste shortcut.
- `.config/systemd/user/hex-refine-warmup.service`: preload Gemma at login.
- `reference/`: Hex settings snapshot and installer-owned service reference;
  excluded from Stow. No weights, transcripts or logs are committed.

Settings select Parakeet v3/Italian and disable Annotate (F9 conflict) and native
OpenCode rewriting (the custom helper owns cleanup). `hypr` provides bindings:
**Super+R / Super+Ctrl+X** toggle; **hold F9** records.

## Restore

Requires [Hex](https://github.com/anomalyco/hex/blob/dev/docs/linux.md),
[running Ollama](https://docs.ollama.com/linux), Stow, Python 3, jq,
wl-clipboard, coreutils, Lua-enabled Hyprland (`send_key_state`) and Omarchy's
terminal tags. Adjust hardcoded `/home/dff` paths for another account.

With Hex stopped, back up existing custom helpers/warm-up unit before Stow.
From the repository root:

```bash
ollama pull gemma4:e2b
hex model install parakeet_v3 --language it
stow --no-folding --dir="$HOME/dotfiles" --target="$HOME" hex hypr
cp --backup=numbered hex/reference/settings.json "$HOME/.local/share/hex/settings.json"
systemctl --user daemon-reload
systemctl --user enable hex.service hex-refine-warmup.service
hex start
systemctl --user start hex-refine-warmup.service
```

Hex's installer creates `hex.service`; its reference copy is documentation.
Disable Hyprvoice/Voxtype services if installed. Create
`~/.config/hex/refine-disabled` to bypass cleanup; remove it to re-enable.

## Maintenance

Change model/prompt in `hex-refine-local`, pull any replacement model and
restart `hex-refine-warmup.service`. Check `hex status --json`, `ollama ps`
and that service's user journal. `hex history --limit 3 --raw --json` shows
text **before custom cleanup**; pipe it into `~/.local/bin/hex-refine-local`
to inspect refinement. Correct output but broken insertion points to
`hex-paste-text`.
