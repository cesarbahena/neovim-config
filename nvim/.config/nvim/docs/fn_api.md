# fn API Documentation

The `fn` API provides a powerful, lazy function wrapper system with conditional execution, error handling, and flexible notification options. It's designed to make complex function composition and error handling patterns more readable and maintainable.

## Table of Contents

- [Basic Concepts](#basic-concepts)
- [Usage Patterns](#usage-patterns)
- [Enhanced Condition Evaluation](#enhanced-condition-evaluation)
- [Notify Options](#notify-options)
- [Examples](#examples)
- [API Reference](#api-reference)

## Basic Concepts

The `fn` API creates **lazy functions** - functions that are defined now but executed later. This allows for:

- **Conditional execution**: Execute different functions based on runtime conditions
- **Error handling**: Graceful fallback when functions fail
- **Notification control**: Fine-grained control over error messaging
- **Function composition**: Chain and compose complex function calls

## Usage Patterns

### 1. Conditional Execution

Execute different functions based on a condition:

```lua
local conditional_fn = fn {
  when = condition,           -- boolean, string, or function
  main_function,              -- function to call if condition is true
  or_else = fallback_function -- function to call if condition is false
}
```

### 2. Try/Notify with Error Handling

Handle function errors with configurable notifications:

```lua
local try_fn = fn {
  main_function,              -- function to try first
  or_else = fallback,         -- function to call if main fails
  notify = 'fallback'         -- notification strategy ('main'|'fallback'|'both')
}
```

### 3. Direct Function Call

Wrap a function with basic error handling:

```lua
local safe_fn = fn(function_reference, arg1, arg2, ...)
```

### 4. Module Path Call

Call a function from a module by string path:

```lua
local module_fn = fn('module.function_name', arg1, arg2, ...)
```

## Enhanced Condition Evaluation

The `when` condition in `fn` supports advanced evaluation patterns for vim variables, options, and custom iteration.

### Basic Condition Types

```lua
-- String expression (lazy evaluation)
when = 'vim.bo.filetype == "lua"'

-- Function (lazy evaluation)  
when = function() return vim.bo.filetype == "lua" end

-- Boolean (immediate evaluation)
when = true
```

### Vim Variable/Option Access

Access vim variables and options with clean, readable syntax:

```lua
-- Current buffer filetype
when = { 'filetype', eq = 'lua', in_this = 'buffer' }

-- Any window with gitsigns blame open
when = { 'gitsigns_preview', eq = 'blame', in_any = 'window' }

-- Global plugin loaded
when = { 'loaded_telescope', in_this = 'global' }

-- Vim state (count prefix > 0)
when = { 'count', gt = 0, in_this = 'state' }

-- Environment variable
when = { 'TERM', eq = 'xterm-256color', in_this = 'env' }
```

### Scope Options

#### Merged Scopes (check both variables and options)

| Scope | Variables | Options | Description |
|-------|-----------|---------|-------------|
| `window` | `vim.w` | `vim.wo` | Window variables + options |
| `buffer` | `vim.b` | `vim.bo` | Buffer variables + options |
| `global` | `vim.g` | `vim.go` | Global variables + options |

#### Single Scopes

| Scope | Access | Description |
|-------|--------|-------------|
| `tab` | `vim.t` | Tab-local variables |
| `option` | `vim.o` | Global options |
| `env` | `vim.env` | Environment variables |
| `state` | `vim.v` | Vim internal state (count, version, register, etc.) |

### Iteration Options

```lua
-- Check current context only
in_this = 'buffer'   -- vim.b[key] or vim.bo[key]

-- Iterate through all items, return ID of first match  
in_any = 'window'    -- Check all windows, return winid

-- Custom iteration
forEach = { 1, 2, 3, 4, 5 }           -- Iterate array
forEach = 'windows'                   -- Shortcut for vim.api.nvim_list_wins()
forEach = function() return my_list() end  -- Dynamic iteration
```

### Comparison Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `eq` | Equal to | `{ 'filetype', eq = 'lua' }` |
| `ne` | Not equal to | `{ 'filetype', ne = 'help' }` |
| `gt` | Greater than | `{ 'count', gt = 0 }` |
| `lt` | Less than | `{ 'line_count', lt = 100 }` |
| `gte` | Greater than or equal | `{ 'version', gte = 801 }` |
| `lte` | Less than or equal | `{ 'tabstop', lte = 4 }` |
| `contains` | Contains key/substring | `{ result, contains = 'stage_hunk' }` |

### Property Access Syntax

Access nested properties from function results using the `()` syntax:

```lua
-- Compare values from state tables
when = { 'vim.fn.undotree().seq_cur', lt = 'vim.fn.undotree().seq_last' }

-- Access nested properties 
when = { 'vim.lsp.get_clients().1.name', eq = 'tailwindcss' }

-- Get buffer info properties
when = { 'vim.fn.getbufinfo().1.changed', eq = 1 }
```

#### Syntax Rules

- `module.function().property.path` - Call function, then access nested properties
- Looks like natural Lua syntax for function calls and property access
- Supports deep property access with dot notation
- Works in both conditions and comparison values

### Function-Aware Comparisons

Comparison operators can now accept functions or property access syntax:

```lua
-- Compare function results
when = { 
  function() return vim.fn.line('.') end,
  lt = function() return vim.fn.line('$') end 
}

-- Mix literal values with function results  
when = { 'vim.fn.undotree().seq_cur', lt = 'vim.fn.undotree().seq_last' }

-- Use in any comparison operator
when = { 'vim.lsp.get_clients', contains = function() return get_target_client() end }
```

### Advanced Examples

#### Multiple Windows with TypeScript Files
```lua
local typescript_keymap = fn {
  'typescript.organize_imports',
  when = { 'filetype', eq = 'typescript', in_any = 'buffer' },
  or_else = function() print('No TypeScript files open') end
}
```

#### Conditional Behavior Based on Vim State
```lua
local smart_motion = fn {
  when = { 'count', gt = 1, in_this = 'state' },
  function() vim.cmd('normal! ' .. vim.v.count .. 'j') end,
  or_else = function() vim.cmd('normal! gj') end -- Visual line movement
}
```

#### Environment-Aware Configuration
```lua
local dev_tools = fn {
  when = { 'NODE_ENV', eq = 'development', in_this = 'env' },
  function() require('dev_tools').setup() end,
  or_else = function() print('Production mode - dev tools disabled') end
}
```

#### Smart Undo/Redo with State Tables
```lua
local smart_undo = fn {
  feed('<c-r>'),  -- Redo by default
  when = { 'vim.fn.undotree().seq_cur', lt = 'vim.fn.undotree().seq_last' },
  or_else = { feed('.') }  -- Repeat last action if at latest change
}
```

#### LSP Client State Detection  
```lua
local tailwind_action = fn {
  'show_tailwind_values',
  when = { 'vim.lsp.get_clients().1.name', eq = 'tailwindcss' },
  or_else = function() print('Tailwind LSP not active') end
}
```

#### Complex Window State Detection
```lua
local close_floating_windows = fn {
  when = { 
    function(w_table, wo_table, winid) 
      return wo_table.winblend > 0  -- Check if window is floating/transparent
    end,
    in_any = 'window'
  },
  function() 
    -- Close all floating windows
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.wo[winid].winblend > 0 then
        vim.api.nvim_win_close(winid, true)
      end
    end
  end,
  or_else = function() print('No floating windows found') end
}
```

## Notify Options

The `notify` option controls when and how errors are reported:

| Option | Description | Main Function Error | Fallback Function Error |
|--------|-------------|---------------------|-------------------------|
| `'main'` | Notify only main errors | ✅ Notified | ❌ Silent (propagates) |
| `'fallback'` | Notify only fallback errors (default) | ❌ Silent | ✅ Notified |
| `'both'` | Notify both main and fallback errors | ✅ Notified | ✅ Notified |

### Notification Behavior Details

- **Notified**: Error message shown via `vim.notify()`
- **Silent**: No notification, execution continues
- **Propagates**: Error bubbles up to caller (function will throw)

## Examples

### Conditional Execution Examples

#### Boolean Condition
```lua
local toggle_fn = fn {
  when = vim.o.wrap,
  function() vim.cmd('set nowrap') end,
  or_else = function() vim.cmd('set wrap') end,
}
```

#### Function Condition
```lua
local smart_save = fn {
  when = function() return vim.bo.modified end,
  function() vim.cmd.write() end,
  or_else = function() print('Buffer not modified') end,
}
```

#### String Condition (Lazy Evaluation)
```lua
local conditional_format = fn {
  when = 'vim.bo.filetype == "lua"',
  function() vim.cmd('!stylua %') end,
  or_else = function() print('Not a Lua file') end,
}
```

### Error Handling Examples

#### Smart Navigation with Graceful Fallback
```lua
local prev_diagnostic = fn {
  when = fn('trouble.is_open'),
  { 'trouble.prev', { skip_groups = true, jump = true } },
  or_else = fn {
    vim.cmd.cprev,
    or_else = vim.diagnostic.goto_prev,
  },
}
```

#### Function with Custom Error Notification
```lua
local safe_require = fn {
  function() return require('optional_module') end,
  notify = 'main',  -- Show error if module not found
  or_else = function() return {} end,  -- Return empty table as fallback
}
```

### Module Path Examples

#### Simple Module Call
```lua
local formatter = fn('conform.format', { async = true })
formatter()  -- Calls conform.format({ async = true })
```

#### With Error Handling
```lua
local safe_format = fn {
  { 'conform.format', { async = true } },
  notify = 'main',
  or_else = function() vim.cmd('!stylua %') end,
}
```

### Complex Composition Examples

#### Nested fn Calls
```lua
local complex_operation = fn {
  when = fn('project.has_config'),
  fn {
    { 'project.load_config' },
    notify = 'both',
    or_else = fn('project.create_default_config'),
  },
  or_else = function() print('No project detected') end,
}
```

#### Multi-step Process
```lua
local build_and_test = fn {
  function() 
    -- Chain multiple operations
    local build = fn('build.compile')()
    if build.success then
      return fn('test.run_all')()
    end
    error('Build failed: ' .. build.error)
  end,
  notify = 'main',
  or_else = function() print('Build process failed') end,
}
```

## API Reference

### fn(spec, ...)

Creates a lazy function wrapper.

#### Parameters

- `spec` (function|string|table): The function specification
- `...` (any): Arguments to pass to the function

#### Returns

- `function`: A lazy function that executes the specified logic when called

#### Function Specification Types

##### Table Specifications

**Conditional Table:**
```lua
{
  when = condition,    -- boolean|string|function
  [1] = main_function, -- function|string|table
  or_else = fallback   -- function|string|table (optional)
}
```

**Try/Notify Table:**
```lua
{
  [1] = main_function,       -- function|string|table
  or_else = fallback,        -- function|string|table (optional)
  notify = notification_mode -- 'main'|'fallback'|'both' (optional, default: 'fallback')
}
```

##### Function Reference
Direct function calls with basic error handling:
```lua
fn(function_reference, arg1, arg2, ...)
```

##### Module Path String
Call module functions by string path:
```lua
fn('module.function_name', arg1, arg2, ...)
```

### Error Handling

The API uses `pcall` internally to catch errors and handle them according to the `notify` option:

- **Successful execution**: Returns the function result
- **Failed execution**: Follows notify strategy and executes fallback if available
- **No fallback**: Returns `nil` or propagates error based on notify option

### Module Path Resolution

Module paths follow the format `'module.function_name'`:

- ✅ Valid: `'string.format'`, `'vim.cmd'`, `'my_module.my_function'`
- ❌ Invalid: `'just_a_function'`, `'module.'`, `'.function'`

Module resolution is lazy - modules are only required when the function is executed.

## Best Practices

### 1. Use Descriptive Conditions
```lua
-- Good
fn {
  when = function() return vim.bo.modified and vim.bo.filetype == 'lua' end,
  -- ...
}

-- Avoid
fn {
  when = vim.bo.modified,  -- Not clear what happens next
  -- ...
}
```

### 2. Choose Appropriate Notify Options
```lua
-- For user-facing operations, notify main errors
local save_file = fn {
  vim.cmd.write,
  notify = 'main',
  or_else = function() print('Save failed, trying backup...') end,
}

-- For internal operations, use fallback notifications
local internal_op = fn {
  risky_internal_function,
  notify = 'fallback',  -- Default - only notify if fallback fails too
  or_else = safe_fallback,
}
```

### 3. Keep Functions Pure When Possible
```lua
-- Good - pure function
local calculate = fn(function(x, y) return x + y end, 5, 3)

-- Avoid - side effects make testing harder
local impure = fn(function() 
  local x = get_global_state()
  update_global_state(x + 1)
  return x
end)
```

### 4. Use Module Paths for External Dependencies
```lua
-- Good - clear dependency
local format = fn('conform.format', options)

-- Avoid - hidden dependency
local format = fn(function() 
  local conform = require('conform')
  return conform.format(options)
end)
```

## Implementation Notes

The `fn` API is implemented with:

- **Guard clauses** for clear control flow
- **Helper functions** for code reusability
- **Comprehensive error handling** with proper cleanup
- **Type annotations** for better developer experience
- **Modular design** for maintainability

All functionality is thoroughly tested with a comprehensive test suite covering edge cases and error conditions.