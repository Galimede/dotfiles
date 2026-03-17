# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Nix Home Manager configuration for an Arch Linux system (x86_64-linux). Manages dotfiles, packages, and application settings declaratively using Nix flakes.

## Commands

```bash
# Apply configuration (build and activate)
home-manager switch

# Dry run (show what would change without applying)
home-manager switch -n

# Build without activating
home-manager build

# Roll back to previous generation
home-manager switch --rollback

# List generations
home-manager generations

# Update all flake inputs
nix flake update

# Update a single input
nix flake update <input-name>

# Format Nix files
nixfmt *.nix

# Inspect a configuration option
home-manager option <option.name>
```

Note: `--flake .` is not needed when running from `~/.config/home-manager` (the default path).

## Architecture

**Entry point:** `flake.nix` defines inputs (nixpkgs unstable, home-manager, nixgl, zen-browser, nur, private-fonts) and a single home configuration for user `mdegand`.

**Main module:** `home.nix` imports all feature modules, sets global packages, dark mode theming (GTK/Qt/dconf), and XDG portals. It also builds two custom npm packages inline via `pkgs.callPackage` (`clever-switch-profile.nix`, `random-labels.nix`).

**Module pattern:** Each `.nix` file in the root is a self-contained module for one concern (e.g., `fish.nix`, `git.nix`, `kitty.nix`, `zed.nix`). Modules use the standard `{ pkgs, config, ... }:` parameter pattern and configure programs via `programs.<name>` or place dotfiles via `home.file`.

### Key modules

- **`git.nix` + `git-local.nix`**: Git config is split — shared settings in `git.nix`, personal identity/emails in `git-local.nix` (gitignored). New setups must copy `git-local.nix.template` to `git-local.nix`.
- **`kitty.nix` / `zed.nix`**: GUI apps wrapped with nixGL (`nixGLIntel`) for Intel Arc GPU acceleration. The wrapper scripts go in `~/.local/bin/`.
- **`claude.nix`**: Manages `~/.claude/settings.json` (permissions) and copies skills from `dotfiles/claude/skills/`.
- **`fonts.nix`**: Installs fonts (Dank Mono via private flake, Hack Nerd Font, Noto Color Emoji) and configures fontconfig fallback.

### Dotfiles

`dotfiles/` contains raw config files sourced by modules:
- `dotfiles/fish/functions/` — Fish shell functions (git helpers like `gwip`, `gcy`, `gfom`)
- `dotfiles/starship.toml` — Shell prompt config
- `dotfiles/niri/config.kdl` — Niri window manager config
- `dotfiles/claude/skills/` — Claude Code skill definitions

## Conventions

- Theme: Catppuccin Mocha everywhere (kitty colors, Zed theme, system dark mode)
- Unfree packages must be explicitly allowlisted in both `flake.nix` and `home.nix` (`allowUnfreePredicate`)
- Nix formatting follows `nixfmt-rfc-style`
- Flake inputs that depend on nixpkgs use `inputs.nixpkgs.follows = "nixpkgs"` to avoid duplicate nixpkgs

## Binary Verification

Before editing config files to use a binary (e.g., `${pkgs.foo}/bin/bar`), verify the correct binary name: check changelogs or run `which`/`command -v` first.
