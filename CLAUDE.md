# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using GNU Stow structure for managing configurations. Contains Neovim configuration with sophisticated error handling and backup mechanisms, plus tmux configuration.

### Managed Configurations

- **nvim**: Neovim configuration at `nvim/.config/nvim/`
- **tmux**: Tmux configuration at `tmux/.config/tmux/`

## Key Commands

### Testing

- `make test` - Run all tests with plenary.nvim
- `make test-verbose` - Run tests with verbose output
- `make test-file` - Run a specific test file
- `make dev-test` - Interactive testing (run `:PlenaryBustedDirectory tests/` in nvim)

### Stow Management

- `stow <package>` - Create symlinks for a package (e.g., `stow nvim`, `stow tmux`)
- `stow -D <package>` - Remove symlinks for a package

### Backup and Sync

- `./sync-nvim-backup.sh` - Sync nvim config to backup location (complete replacement)

### Environment Variables

- `NVIM_BACKUP_PATH` - Path to backup configuration (default: `~/.config/nvim_backup`)
- `NVIM_SAFE_MODE` - Set to '1' to load backup config immediately without waiting for errors

## Architecture

### Core Error Handling System

The configuration is built around a sophisticated error handling system using a custom `try` API:

- **Safe Execution**: All module loading uses `try()` wrapper for error resilience
- **Error Collection**: Errors are stored in `_G.Errors` for debugging
- **Backup Fallback**: Automatic fallback to backup configuration when modules fail
- **Retry Mechanism**: Failed modules can be retried before package manager initialization

### Directory Structure

```
nvim/.config/nvim/
├── init.lua              # Entry point with backup/safe mode logic
├── Makefile             # Test commands
├── lazy-lock.json       # Package lockfile
├── stylua.toml         # Lua formatter config
├── lsp/                # Language server configurations
├── lua/
│   ├── core/           # Core system modules
│   │   ├── init.lua    # Main loader with try() usage
│   │   ├── lsp/        # LSP configuration
│   │   ├── package_manager.lua  # lazy.nvim setup
│   │   └── retry.lua   # Module retry logic
│   ├── plugins/        # Plugin configurations (~30+ plugins)
│   ├── utils/          # Utility modules
│   │   └── try.lua     # Core error handling API
│   └── ui/             # UI-related modules
└── tests/              # Test suite for try API
```

### Try API

The `try` function provides multiple execution patterns:

- Simple calls: `try(function, args...)`
- Single operations: `try { function, args..., options }`
- Batch operations: `try { {func1, args...}, {func2, args...}, options }`
- Multi-call: `try { function, {args1...}, {args2...}, options }`

### Package Management

Uses lazy.nvim with:

- Lockfile at `json/lazy-lock.json`
- Plugin specs imported from `plugins/` directory
- Performance optimizations with disabled default plugins
- Automatic plugin checking enabled

### LSP Configuration

Language servers are configured in `lsp/` directory with automatic loading:

- Individual server configs: `lsp/<server_name>.lua`
- Mason auto-installs configured servers
- When adding LSP support: also add formatter to `conform.lua` formatters_by_ft

## Git Commit Preferences

- **No watermarks**: Do not add "Generated with Claude Code" or "Co-Authored-By: Claude" to commit messages
- **Scoped commits**: Use conventional commit format with scope, e.g.:
  - `feat(nvim): add new plugin configuration`
  - `fix(tmux): correct key binding configuration`
  - `refactor(backup): improve sync script reliability`
  - `docs: update installation instructions`

## Development Notes

- All Lua files use the `try()` wrapper for safe module loading
- Test files are located in `tests/` and use plenary.nvim
- Configuration supports both normal and safe mode operation
- Backup configuration path is configurable via environment variable
- The setup automatically handles plugin installation and lazy loading
- Use GNU Stow for managing dotfile symlinks
