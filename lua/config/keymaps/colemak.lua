return {
  keys = {
    -- nox
    n = "Next line",
    N = "Next page",
    e = "prEv line",
    E = "prEv page",
    k = "bacK word",
    K = "bacK w.ord",
    w = "rest of Word",
    W = "rest of W.ord",
    h = "Hop to next word",
    H = "Hop to next w.ord",
    m = "Move left",
    M = "HoMe",
    o = "Move right",
    O = "eoL",
    ["\\"] = "Next match",
    ['<tab>'] = "Escape to normal mode",
    ["do"] = "Delete one",
    so = "Substitute one",
    f = 'Find in screen',
    F = 'Find in document',
    r = 'Remote',
    R = 'Repeat macro',
    t = { normal = 'To', operator = 'Till' },
    T = { normal = 'Treesitter search', operator = 'Till backwards' },

    -- nx
    s = "Substitute",
    ["<cr>"] = "Command line mode",
    
    -- n
    Y = "Yank line",
    yy = "Yank to eol",
    yp = "Copy down",
    U = "Unundo",
    [","] = { "Insert comma at the end", i = "Comma with auto undo breakpoints" },
    [";"] = { "Insert semicolon at the end", i = "Semicolon with auto undo breakpoints" },
    [":"] = "Delete comma or semicolon at the end",
    J = "Join/Merge lines (pretty)",
    gJ = "Join/Merge lines (raw)",
    i = "Insert mode",
    D = "Delete line",
    [">"] = "Indent",
    ["<"] = "Deindent",
    l = "Open Line below",
    L = "Open Line above",

    -- x
    y = "Yank",

    p = "Paste",
    gU = "Uppercase",
    u = "nop",
    gu = "Lowercase",
    V = "Change visual mode",
    ["."] = "Dot with auto undo breakpoints",
  },
  control = {
    u = 'Undo jump',
    y = 'Yes',
    r = 'Toggle macro recording',
  },
  leader = {
    l = 'add Line below',
    L = 'add Line above',
    _ = "Move window to bottom",
    ["|"] = "Move window to rightmost side",
    ["="] = "Evenly distributed windows",
  },
  alt = {
    q = "Quit",
    n = "Move line down",
    e = "Move line up",
  }
}
