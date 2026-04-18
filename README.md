# dotfiles

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat-square&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58E1FF?style=flat-square)
![Neovim](https://img.shields.io/badge/Neovim-0.10-57A143?style=flat-square&logo=neovim&logoColor=white)
![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin_Mocha-CBA6F7?style=flat-square)

My personal Arch Linux dotfiles, managed with GNU Stow. Fully Wayland-native, themed consistently with Catppuccin Mocha across every component.

---

## Preview

> Hyprland · Waybar · Kitty · Wofi · Catppuccin Mocha

---

## Stack

| Component | Tool |
|-----------|------|
| Window manager | [Hyprland](https://hyprland.org) |
| Status bar | [Waybar](https://github.com/Alexays/Waybar) |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) |
| App launcher | [Wofi](https://hg.sr.ht/~scoopta/wofi) |
| Shell | Zsh + Oh My Zsh |
| Prompt | [Starship](https://starship.rs) |
| Editor | [Neovim](https://neovim.io) |
| Notifications | [swaync](https://github.com/ErikReider/SwayNotificationCenter) |
| Lock screen | Hyprlock |
| Idle daemon | Hypridle |
| Wallpaper | Hyprpaper + wallpaper rotation script |
| Theme | Catppuccin Mocha (everywhere) |

---

## Structure

Each directory is a Stow package — it mirrors the target path relative to `$HOME`. Running `stow <package>` creates the symlinks automatically.

```
dotfiles/
├── hypr/           → ~/.config/hypr/
│   └── hyprland.conf · hyprlock.conf · hypridle.conf
│   └── hyprpaper.conf · mocha.conf
│   └── scripts/wallpaper.sh · start-sunshine.sh
├── waybar/         → ~/.config/waybar/
│   └── config.jsonc · style.css · mocha.css · wifi-manager.sh
├── kitty/          → ~/.config/kitty/
│   └── kitty.conf · current-theme.conf
├── nvim/           → ~/.config/nvim/
│   └── init.lua · lua/vim-options.lua
│   └── lua/plugins/  (lsp, completions, treesitter, formatting…)
├── wofi/           → ~/.config/wofi/
│   └── style.css
├── starship/       → ~/.config/
│   └── starship.toml
├── zsh/            → ~/
│   └── .zshrc
├── backgrounds/    → ~/.config/backgrounds/
│   └── 1.jpg · 2.jpg · 3.jpg · 4.jpg · shaded.png
├── pkglist-pacman.txt   # Full pacman package list
└── pkglist-aur.txt      # AUR packages
```

---

## Neovim

Managed with [lazy.nvim](https://github.com/folke/lazy.nvim). LSPs are installed automatically via Mason.

**LSP support** (via `mason-lspconfig`): C/C++ (`clangd`), Python (`pyright`), Java (`jdtls`), TypeScript (`ts_ls`), HTML, CSS, Tailwind CSS, Bash, Lua

**Plugins**

| Plugin | Purpose |
|--------|---------|
| `nvim-lspconfig` + `mason.nvim` | LSP setup and auto-install |
| `nvim-cmp` + `LuaSnip` | Autocompletion and snippets |
| `none-ls.nvim` | Formatting: Prettier, Black, stylua · Linting: pylint |
| `nvim-treesitter` | Syntax highlighting |
| `oil.nvim` | File manager inside a buffer |
| `snacks.nvim` | Quality-of-life utilities |
| `vim-surround` | Surround motions |
| `catppuccin` | Mocha colorscheme |
| `swagger-preview` | Live Swagger/OpenAPI preview |
| `vim-test` | Run tests from inside Neovim |

**Key mappings** (leader = `Space`)

| Mapping | Action |
|---------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `gr` | References |
| `<leader>f` | Format buffer |
| `Ctrl+h/j/k/l` | Navigate splits |

---

## Shell

Zsh with Oh My Zsh. Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf` (key bindings + fuzzy completion).

Prompt is **Starship** with a custom Catppuccin Mocha powerline layout showing: OS icon · username · directory · git branch/status · active language runtime (C, Python, Java, Node, etc.) · Docker context · time · command duration.

---

## Hyprland

Dwindle tiling layout with 5px inner / 20px outer gaps, 10px rounded corners, blur and shadows enabled. Custom bezier animation curves for windows, workspaces, and layer transitions.

**Autostart:** Waybar, swaync, wallpaper rotation script, Sunshine (game streaming).

**Keybinds (selection)**

| Key | Action |
|-----|--------|
| `Super + Return` | Open Kitty |
| `Super + Space` | Wofi launcher |
| `Super + Q` | Kill active window |
| `Super + V` | Toggle floating |
| `Super + 1–0` | Switch workspace |
| `Super + Shift + 1–0` | Move window to workspace |
| `Super + S` | Toggle scratchpad |
| `Print` | Screenshot window |
| `Shift + Print` | Screenshot region |
| Media keys | Volume, brightness, playback |

---

## Installation

### Dependencies

Install all packages from the saved lists:

```bash
# Pacman packages
sudo pacman -S --needed - < pkglist-pacman.txt

# AUR packages (requires yay or paru)
yay -S --needed - < pkglist-aur.txt
```

### Stow symlinks

From the root of this repo, stow whichever packages you want:

```bash
# All at once
stow hypr waybar kitty nvim wofi starship zsh backgrounds

# Or individually
stow nvim
stow hypr
```

To remove symlinks:

```bash
stow -D nvim
```

> Make sure the target config files don't already exist before stowing, or Stow will refuse with a conflict error. Back up or delete existing configs first.

---

## Notes

- The Hyprland config includes VM-specific overrides at the bottom (`Virtual-1` monitor, software rendering env vars) — remove or adjust these on bare metal
- Hypridle and Hyprlock are configured but idle locking is commented out — uncomment the listener block in `hypridle.conf` to enable auto-lock
