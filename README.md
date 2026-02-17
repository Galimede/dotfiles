# dotfiles

Arch Linux + Nix hybrid configuration for a work machine. Uses [Home Manager](https://github.com/nix-community/home-manager) with Nix flakes to declaratively manage dotfiles, packages, and application settings on top of a base Arch Linux install.

## Why hybrid?

Arch Linux handles the base system, kernel, and GPU drivers. Nix + Home Manager handles the user environment — packages, dotfiles, and app configuration — for reproducibility and rollbacks without giving up the Arch rolling release and AUR.

## Stack

- **Window manager:** [Niri](https://github.com/YaLTeR/niri) (Wayland, scrollable tiling)
- **Terminal:** Kitty
- **Shell:** Fish + Starship prompt
- **Editor:** Zed
- **Browser:** Zen Browser
- **Theme:** Catppuccin Mocha everywhere (Kitty, Zed, system dark mode via GTK/Qt/dconf)
- **GPU:** Intel Arc, GUI apps wrapped with [nixGL](https://github.com/nix-community/nixGL) for hardware acceleration

## Modules

| Module | What it configures |
|---|---|
| `fish.nix` | Fish shell, aliases, custom functions |
| `starship.nix` | Starship prompt |
| `kitty.nix` | Kitty terminal (nixGL-wrapped) |
| `zed.nix` | Zed editor (nixGL-wrapped) |
| `zen.nix` | Zen Browser |
| `niri.nix` | Niri window manager dotfiles |
| `git.nix` | Shared Git config |
| `git-local.nix` | Personal Git identity (gitignored, see template) |
| `lazygit.nix` | Lazygit TUI |
| `fzf.nix` | Fuzzy finder |
| `mise.nix` | Runtime version manager |
| `fonts.nix` | Fonts (Dank Mono, Hack Nerd Font, Noto Color Emoji) + fontconfig |
| `claude.nix` | Claude Code settings and skills |
| `1password.nix` | 1Password browser integration |

## Dotfiles

The `dotfiles/` directory contains raw config files that modules source via `home.file`:

- `fish/functions/` — Custom Fish functions (git helpers like `gwip`, `gcy`, `gfom`)
- `niri/config.kdl` — Niri window manager configuration
- `starship.toml` — Starship prompt configuration
- `claude/` — Claude Code skills and settings

## Prerequisites

- **Arch Linux** with:
  - Niri installed (window manager)
  - Intel Arc GPU drivers
  - `xdg-desktop-portal-gtk` (for portal backend service)
- **Nix** with flakes enabled

## Setup

```bash
# Clone to the default Home Manager path
git clone <repo-url> ~/.config/home-manager

# Copy git identity template and fill in your details
cp git-local.nix.template git-local.nix

# Apply configuration
home-manager switch
```

## Common commands

```bash
home-manager switch            # Build and activate
home-manager switch -n         # Dry run
home-manager switch --rollback # Roll back to previous generation
home-manager generations       # List generations
nix flake update               # Update all inputs
nixfmt *.nix                   # Format Nix files
```

## Future

Migration to [system-manager](https://github.com/numtide/system-manager) is planned to also manage system-level configuration with Nix.
