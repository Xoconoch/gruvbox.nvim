---@class Gruvbox
---@field config GruvboxConfig
---@field palette GruvboxPalette
local Gruvbox = {}

---@alias Contrast "hard" | "soft" | ""

---@class ItalicConfig
---@field strings boolean
---@field comments boolean
---@field operators boolean
---@field folds boolean
---@field emphasis boolean

---@class HighlightDefinition
---@field fg string?
---@field bg string?
---@field sp string?
---@field blend integer?
---@field bold boolean?
---@field standout boolean?
---@field underline boolean?
---@field undercurl boolean?
---@field underdouble boolean?
---@field underdotted boolean?
---@field strikethrough boolean?
---@field italic boolean?
---@field reverse boolean?
---@field nocombine boolean?

---@class GruvboxConfig
---@field bold boolean?
---@field contrast Contrast?
---@field dim_inactive boolean?
---@field inverse boolean?
---@field invert_selection boolean?
---@field invert_signs boolean?
---@field invert_tabline boolean?
---@field italic ItalicConfig?
---@field overrides table<string, HighlightDefinition>?
---@field palette_overrides table<string, string>?
---@field strikethrough boolean?
---@field terminal_colors boolean?
---@field transparent_mode boolean?
---@field undercurl boolean?
---@field underline boolean?
local default_config = {
  terminal_colors = true,
  undercurl = false,
  underline = false,
  bold = false,      -- No bold text
  italic = {
    strings = false, -- No italics anywhere
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = false,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = false,
  contrast = "",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
}

Gruvbox.config = vim.deepcopy(default_config)

-- main gruvbox color palette
---@class GruvboxPalette
Gruvbox.palette = {
  dark0_hard = "#1d2021",
  dark0 = "#282828",
  dark0_soft = "#32302f",
  dark1 = "#3c3836",
  dark2 = "#504945",
  dark3 = "#665c54",
  dark4 = "#7c6f64",
  light0_hard = "#f9f5d7",
  light0 = "#fbf1c7",
  light0_soft = "#f2e5bc",
  light1 = "#ebdbb2",
  light2 = "#d5c4a1",
  light3 = "#bdae93",
  light4 = "#a89984",
  bright_red = "#fb4934",
  bright_green = "#b8bb26",
  bright_yellow = "#fabd2f",
  bright_blue = "#83a598",
  bright_purple = "#d3869b",
  bright_aqua = "#8ec07c",
  bright_orange = "#fe8019",
  neutral_red = "#cc241d",
  neutral_green = "#98971a",
  neutral_yellow = "#d79921",
  neutral_blue = "#458588",
  neutral_purple = "#b16286",
  neutral_aqua = "#689d6a",
  neutral_orange = "#d65d0e",
  faded_red = "#9d0006",
  faded_green = "#79740e",
  faded_yellow = "#b57614",
  faded_blue = "#076678",
  faded_purple = "#8f3f71",
  faded_aqua = "#427b58",
  faded_orange = "#af3a03",
  dark_red_hard = "#792329",
  dark_red = "#722529",
  dark_red_soft = "#7b2c2f",
  light_red_hard = "#fc9690",
  light_red = "#fc9487",
  light_red_soft = "#f78b7f",
  dark_green_hard = "#5a633a",
  dark_green = "#62693e",
  dark_green_soft = "#686d43",
  light_green_hard = "#d3d6a5",
  light_green = "#d5d39b",
  light_green_soft = "#cecb94",
  dark_aqua_hard = "#3e4934",
  dark_aqua = "#49503b",
  dark_aqua_soft = "#525742",
  light_aqua_hard = "#e6e9c1",
  light_aqua = "#e8e5b5",
  light_aqua_soft = "#e1dbac",
  gray = "#928374",
}

-- get a hex list of gruvbox colors based on current bg and constrast config
local function get_colors()
  local p = Gruvbox.palette
  local config = Gruvbox.config

  for color, hex in pairs(config.palette_overrides) do
    p[color] = hex
  end

  local bg = vim.o.background
  local color_groups = {
    dark = {
      bg0 = p.dark0,
      bg1 = p.dark1,
      bg2 = p.dark2,
      bg3 = p.dark3,
      bg4 = p.dark4,
      fg0 = p.light0,
      fg1 = p.light1, -- Default text color
      fg2 = p.light2,
      fg3 = p.light3,
      fg4 = p.light4,

      -- Keep Gruvbox colors but map them to Alabaster's 4 categories
      -- 1. Strings → Gruvbox green
      string = p.bright_green,
      -- 2. Constants → Gruvbox purple
      constant = p.bright_purple,
      -- 3. Comments → Gruvbox gray
      comment = p.gray,
      -- 4. Global definitions → Gruvbox blue
      definition = p.bright_blue,

      -- Everything else uses normal text color (light1)
      red = p.light1,
      green = p.light1,
      yellow = p.light1,
      blue = p.light1,
      purple = p.light1,
      aqua = p.light1,
      orange = p.light1,
      neutral_red = p.light1,
      neutral_green = p.light1,
      neutral_yellow = p.light1,
      neutral_blue = p.light1,
      neutral_purple = p.light1,
      neutral_aqua = p.light1,
      dark_red = p.light1,
      dark_green = p.light1,
      dark_aqua = p.light1,
      gray = p.gray,
    },
    light = {
      bg0 = p.light0,
      bg1 = p.light1,
      bg2 = p.light2,
      bg3 = p.light3,
      bg4 = p.light4,
      fg0 = p.dark0,
      fg1 = p.dark1, -- Default text color
      fg2 = p.dark2,
      fg3 = p.dark3,
      fg4 = p.dark4,

      -- Use faded versions for light mode (following Gruvbox's pattern)
      -- 1. Strings → faded green
      string = p.faded_green,
      -- 2. Constants → faded purple
      constant = p.faded_purple,
      -- 3. Comments → gray
      comment = p.gray,
      -- 4. Global definitions → faded blue
      definition = p.faded_blue,

      -- Everything else uses normal text color (dark1)
      red = p.dark1,
      green = p.dark1,
      yellow = p.dark1,
      blue = p.dark1,
      purple = p.dark1,
      aqua = p.dark1,
      orange = p.dark1,
      neutral_red = p.dark1,
      neutral_green = p.dark1,
      neutral_yellow = p.dark1,
      neutral_blue = p.dark1,
      neutral_purple = p.dark1,
      neutral_aqua = p.dark1,
      dark_red = p.dark1,
      dark_green = p.dark1,
      dark_aqua = p.dark1,
      gray = p.gray,
    },
  }

  return color_groups[bg]
end

local function get_groups()
  local colors = get_colors()
  local config = Gruvbox.config

  if config.terminal_colors then
    -- Keep Gruvbox terminal colors
    local term_colors = {
      colors.bg0,
      colors.neutral_red,
      colors.neutral_green,
      colors.neutral_yellow,
      colors.neutral_blue,
      colors.neutral_purple,
      colors.neutral_aqua,
      colors.fg4,
      colors.gray,
      colors.red,
      colors.green,
      colors.yellow,
      colors.blue,
      colors.purple,
      colors.aqua,
      colors.fg1,
    }
    for index, value in ipairs(term_colors) do
      vim.g["terminal_color_" .. index - 1] = value
    end
  end

  local groups = {
    -- Basic UI elements (use Gruvbox colors but no highlighting)
    Normal = config.transparent_mode and { fg = colors.fg1, bg = nil } or { fg = colors.fg1, bg = colors.bg0 },
    NormalFloat = config.transparent_mode and { fg = colors.fg1, bg = nil } or { fg = colors.fg1, bg = colors.bg1 },
    NormalNC = config.dim_inactive and { fg = colors.fg0, bg = colors.bg1 } or { link = "Normal" },

    -- Alabaster's 4 categories using Gruvbox colors:
    -- 1. Strings
    String = { fg = colors.string },

    -- 2. Constants (numbers, symbols, keywords, booleans)
    Constant = { fg = colors.constant },
    Number = { link = "Constant" },
    Boolean = { link = "Constant" },

    -- 3. Comments
    Comment = { fg = colors.comment },

    -- 4. Global definitions (functions, classes, etc.)
    Function = { fg = colors.definition },
    Identifier = { fg = colors.definition },

    -- Neutralize all language keywords (if, else, function, etc.)
    Statement = { fg = colors.fg1 },
    Conditional = { fg = colors.fg1 },
    Repeat = { fg = colors.fg1 },
    Label = { fg = colors.fg1 },
    Operator = { fg = colors.fg1 },
    Keyword = { fg = colors.fg1 },
    Exception = { fg = colors.fg1 },
    PreProc = { fg = colors.fg1 },
    Include = { fg = colors.fg1 },
    Define = { fg = colors.fg1 },
    Macro = { fg = colors.fg1 },
    PreCondit = { fg = colors.fg1 },
    Type = { fg = colors.fg1 },
    StorageClass = { fg = colors.fg1 },
    Structure = { fg = colors.fg1 },
    Typedef = { fg = colors.fg1 },
    Special = { fg = colors.fg1 },
    Tag = { fg = colors.fg1 },
    Delimiter = { fg = colors.fg1 },
    SpecialChar = { fg = colors.fg1 },

    -- UI elements (keep Gruvbox's but simpler)
    CursorLine = { bg = colors.bg1 },
    CursorColumn = { link = "CursorLine" },
    ColorColumn = { bg = colors.bg1 },
    LineNr = { fg = colors.fg4 },
    CursorLineNr = { fg = colors.fg3, bg = colors.bg1 },
    SignColumn = config.transparent_mode and { bg = nil } or { bg = colors.bg1 },

    -- Visual selection and search (subtle)
    Visual = { bg = colors.bg3 },
    VisualNOS = { link = "Visual" },
    Search = { bg = colors.bg2 },
    IncSearch = { link = "Search" },
    CurSearch = { link = "Search" },

    -- Pmenu
    Pmenu = { fg = colors.fg1, bg = colors.bg2 },
    PmenuSel = { fg = colors.bg2, bg = colors.fg1 },
    PmenuSbar = { bg = colors.bg2 },
    PmenuThumb = { bg = colors.bg4 },

    -- Status line
    StatusLine = { fg = colors.fg1, bg = colors.bg2 },
    StatusLineNC = { fg = colors.fg4, bg = colors.bg1 },
    WinBar = { fg = colors.fg4, bg = colors.bg0 },
    WinBarNC = { fg = colors.fg3, bg = colors.bg1 },
    WinSeparator = config.transparent_mode and { fg = colors.bg3, bg = nil } or { fg = colors.bg3, bg = colors.bg0 },

    -- Diff (subtle)
    DiffAdd = { bg = colors.dark_green },
    DiffDelete = { bg = colors.dark_red },
    DiffChange = { bg = colors.dark_aqua },
    DiffText = { bg = colors.bg2 },

    -- Diagnostics (minimal)
    DiagnosticError = { fg = colors.fg1 },
    DiagnosticWarn = { fg = colors.fg1 },
    DiagnosticInfo = { fg = colors.fg1 },
    DiagnosticHint = { fg = colors.fg1 },
    DiagnosticSignError = { fg = colors.fg1, bg = colors.bg1 },
    DiagnosticSignWarn = { fg = colors.fg1, bg = colors.bg1 },
    DiagnosticSignInfo = { fg = colors.fg1, bg = colors.bg1 },
    DiagnosticSignHint = { fg = colors.fg1, bg = colors.bg1 },

    -- Git (minimal)
    GitSignsAdd = { fg = colors.fg1 },
    GitSignsChange = { fg = colors.fg1 },
    GitSignsDelete = { fg = colors.fg1 },

    -- Tree-sitter groups (map to Alabaster's 4 categories)
    ["@comment"] = { link = "Comment" },
    ["@string"] = { link = "String" },
    ["@string.regex"] = { link = "String" },
    ["@string.escape"] = { link = "Constant" },
    ["@string.special"] = { link = "Constant" },

    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { link = "Constant" },
    ["@constant.macro"] = { link = "Constant" },
    ["@boolean"] = { link = "Constant" },
    ["@number"] = { link = "Constant" },
    ["@number.float"] = { link = "Constant" },
    ["@float"] = { link = "Constant" },

    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { link = "Function" },
    ["@function.call"] = { link = "Function" },
    ["@function.macro"] = { link = "Function" },
    ["@method"] = { link = "Function" },
    ["@method.call"] = { link = "Function" },
    ["@constructor"] = { fg = colors.definition },

    -- Neutralize all other tree-sitter groups
    ["@keyword"] = { fg = colors.fg1 },
    ["@keyword.conditional"] = { fg = colors.fg1 },
    ["@keyword.debug"] = { fg = colors.fg1 },
    ["@keyword.directive"] = { fg = colors.fg1 },
    ["@keyword.directive.define"] = { fg = colors.fg1 },
    ["@keyword.exception"] = { fg = colors.fg1 },
    ["@keyword.function"] = { fg = colors.fg1 },
    ["@keyword.import"] = { fg = colors.fg1 },
    ["@keyword.operator"] = { fg = colors.fg1 },
    ["@keyword.repeat"] = { fg = colors.fg1 },
    ["@keyword.return"] = { fg = colors.fg1 },
    ["@keyword.storage"] = { fg = colors.fg1 },
    ["@conditional"] = { fg = colors.fg1 },
    ["@repeat"] = { fg = colors.fg1 },
    ["@debug"] = { fg = colors.fg1 },
    ["@label"] = { fg = colors.fg1 },
    ["@include"] = { fg = colors.fg1 },
    ["@exception"] = { fg = colors.fg1 },
    ["@type"] = { fg = colors.fg1 },
    ["@type.builtin"] = { fg = colors.fg1 },
    ["@type.definition"] = { fg = colors.fg1 },
    ["@type.qualifier"] = { fg = colors.fg1 },
    ["@storageclass"] = { fg = colors.fg1 },
    ["@attribute"] = { fg = colors.fg1 },
    ["@field"] = { fg = colors.fg1 },
    ["@property"] = { fg = colors.fg1 },
    ["@variable"] = { fg = colors.fg1 },
    ["@variable.builtin"] = { fg = colors.fg1 },
    ["@variable.member"] = { fg = colors.fg1 },
    ["@variable.parameter"] = { fg = colors.fg1 },
    ["@module"] = { fg = colors.fg1 },
    ["@namespace"] = { fg = colors.fg1 },
    ["@symbol"] = { fg = colors.fg1 },
    ["@text"] = { fg = colors.fg1 },
    ["@tag"] = { fg = colors.fg1 },
    ["@tag.attribute"] = { fg = colors.fg1 },
    ["@tag.delimiter"] = { fg = colors.fg1 },
    ["@punctuation"] = { fg = colors.fg1 },
    ["@macro"] = { fg = colors.fg1 },
    ["@structure"] = { fg = colors.fg1 },
  }

  -- Apply any user overrides
  for group, hl in pairs(config.overrides) do
    if groups[group] then
      groups[group].link = nil
    end
    groups[group] = vim.tbl_extend("force", groups[group] or {}, hl)
  end

  return groups
end

---@param config GruvboxConfig?
Gruvbox.setup = function(config)
  Gruvbox.config = vim.deepcopy(default_config)
  Gruvbox.config = vim.tbl_deep_extend("force", Gruvbox.config, config or {})
end

--- main load function
Gruvbox.load = function()
  if vim.version().minor < 8 then
    vim.notify_once("gruvbox.nvim: you must use neovim 0.8 or higher")
    return
  end

  -- reset colors
  if vim.g.colors_name then
    vim.cmd.hi("clear")
  end
  vim.g.colors_name = "gruvbox"
  vim.o.termguicolors = true

  local groups = get_groups()

  -- add highlights
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return Gruvbox
