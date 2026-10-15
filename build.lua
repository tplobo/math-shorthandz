-- l3build configuration for math-shorthandz

module = "math-shorthandz"

-- The version is read from \ProvidesPackage in math-shorthandz.sty, the single
-- source of truth. `l3build tag vX.Y.Z` rewrites it (see update_tag below).
-- NOTE: "-" is a quantifier in Lua patterns, hence the "%-" escapes below.
local function read(path)
  local file = assert(io.open(path, "rb"))
  local text = file:read("*a")
  file:close()
  return text
end

local pkgversion = read("math-shorthandz.sty"):match("\\ProvidesPackage{math%-shorthandz}%[%d+/%d+/%d+ v([%d%.]+)")
assert(pkgversion, "cannot read the version from \\ProvidesPackage in math-shorthandz.sty")

sourcefiles  = {"math-shorthandz.sty"}             -- no .dtx/.ins: the .sty is the source
unpackfiles  = {}                                  -- nothing to extract
typesetfiles = {"math-shorthandz.tex"}             -- the manual
docfiles     = {"math-shorthandz-listings.tex"}    -- file the manual \input's
textfiles    = {"README.md", "LICENSE*"}
typesetexe   = "lualatex"                          -- unicode-math needs LuaTeX or XeTeX
tagfiles     = {"math-shorthandz.sty", "math-shorthandz.tex"}

-- `l3build tag v1.2.3` updates version and date in the .sty and the manual title
function update_tag(file, content, tagname, tagdate)
  local version = ((tagname or pkgversion):gsub("^v", ""))
  local date    = (tagdate:gsub("%-", "/"))
  if file:match("%.sty$") then
    return (content:gsub("(\\ProvidesPackage{math%-shorthandz}%[)%d+/%d+/%d+ v[%d%.]+",
      function(head) return head .. date .. " v" .. version end))
  end
  return (content:gsub("(\\today\\quad v)[%d%.]+",
    function(head) return head .. version end))
end

local repository = "https://github.com/tplobo/math-shorthandz"

uploadconfig = {
  pkg          = module,
  version      = pkgversion,
  author       = "Tiago Pomella Lobo",
  uploader     = "Tiago Pomella Lobo",
  maintainer   = "Tiago Pomella Lobo",
  email        = os.getenv("CTAN_EMAIL"),
  license      = "lppl1.3c",
  summary      = "Smart shorthands for typesetting math in LaTeX",
  description  = [[The 'math-shorthandz' package has shorthand macros for typesetting the most common mathematical expressions in LaTeX. It provides compact commands to construct symbols with features such as multi-underlines, pre/succeeding scripts, fractions, differentials/derivatives and integrals with highly customizable positioning and (auto-)scaling. All commands are safe in text and distinguish their customization between display, inline, script and/or scriptscript contexts.]],
  topic        = {"maths"},
  ctanPath     = "/macros/latex/contrib/" .. module,
  repository   = repository,
  development  = repository,
  bugtracker   = repository .. "/issues",
  announcement = [[math-shorthandz — smart shorthands for typesetting math in LaTeX

The 'math-shorthandz' package bundles compact macros for constructing the most common mathematical expressions in LaTeX, with highly customizable positioning and scaling. Try its fraction command with easy inclusion of delimiters, or integral command with stylized integration limits positioning!]],
  note         = "Uploaded automatically by l3build.",
}