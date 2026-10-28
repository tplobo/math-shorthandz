[![Buy Me a Coffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-FFDD00?logo=buymeacoffee&logoColor=black&logoSize=auto&style=flat-square)](https://buymeacoffee.com/tplobo)[![Buy Me a Coffee user](https://img.shields.io/badge/drinker%3A-tplobo-57606A?labelColor=57606A&style=flat-square)](https://buymeacoffee.com/tplobo)
&emsp;&emsp;
[![CTAN](https://img.shields.io/badge/-CTAN-2A7F7F?logo=latex&logoColor=white&logoSize=auto&style=flat-square)](https://ctan.org/pkg/math-shorthandz)[![CTAN version](https://img.shields.io/ctan/v/math-shorthandz?label=version%3A&labelColor=57606A&color=57606A&style=flat-square)](https://ctan.org/pkg/math-shorthandz)
&emsp;&emsp;
[![Zenodo](https://img.shields.io/badge/-%20-1682D4?logo=zenodo&logoColor=white&logoSize=auto&style=flat-square)](https://doi.org/10.5281/zenodo.23414428)[![Zenodo DOI](https://img.shields.io/badge/DOI%3A-10.5281%2Fzenodo.23414428-57606A?labelColor=57606A&style=flat-square)](https://doi.org/10.5281/zenodo.23414428)

# math-shorthandz — smart shorthands for typesetting math in LaTeX

The **math-shorthandz** package has shorthand macros for typesetting the most
common mathematical expressions in LaTeX. It provides compact commands to
construct symbols with features such as multi-underlines, pre/succeeding
scripts, fractions, differentials/derivatives and integrals with highly
customizable positioning and (auto-)scaling. All commands are safe in text and
distinguish their customization between display, inline, script and/or
scriptscript contexts.

Every distance is measured in the math style of the operand, so commands look
good in inline, display and exponent contexts. All tunable parameters are
package options, read at call time, so they can be changed anywhere with
`\setkeys{shorthand}{key=value}`. The package name ends in "z" on purpose:
every command starts with `z` (e.g. `\zdot` instead of `\cdot`), which gives
them a unified style and keeps them distinct from other commands.

## Commands

- `\zint` — integrals: single, multiple, contour or bridged; slant, stacked or right-side limits
- `\zdiff` — differentials and derivatives
- `\zfrac` — fractions (`\frac`, `\nicefrac` or slash) with optional parentheses
- `\zscript` — up to four scripts around a nucleus
- `\zprime` — primes as superscript or accent
- `\zlim` — limit operator with variable and value
- `\zarg` — scaled function argument
- `\zcond` — "evaluated at" bar
- `\zdot` — heavier dot-product operator
- `\zscale` — style-aware scaling of math content
- `\zline`, `\zvec`, `\zmat` — stacked underlines for vectors and matrices
- `\zpunct` — punctuation at the end of a display line
- `\zlocal`, `\zref`, `\zwrapper` — prefixes that change options for the next call of a command only
- `\zalias` — variants of any command with their own option values

```latex
\usepackage[zint-math-after=-0.3, zarg-kern=1mu]{math-shorthandz}
...
\zint[0][T] f\zarg{t}\zdiff+{t} = \zfrac[\beta+1] \zpunct{.}
```

## Requirements

LuaLaTeX or XeLaTeX (the package loads `unicode-math`), LaTeX kernel 2020-10-01
or newer, the packages `amsmath`, `graphicx`, `nicefrac` and `xkeyval`, and the
XITS Math font (used for the integral glyphs; `xits` in TeX Live).

## Installation

Install it from your TeX distribution (`tlmgr install math-shorthandz`), or copy
`math-shorthandz.sty` into your local TEXMF tree under
`tex/latex/math-shorthandz/` (`kpsewhich -var-value TEXMFHOME` prints its
location), or simply next to your document. Then load it with
`\usepackage{math-shorthandz}`.

## Documentation

The manual is `math-shorthandz.pdf`. To rebuild it from `math-shorthandz.tex`
(which needs `math-shorthandz.sty` and `math-shorthandz-listings.tex`, plus the
packages `tcolorbox`, `listings`, `tikz`, `hypdoc` and a few common ones):

    lualatex math-shorthandz
    makeindex -s gind.ist math-shorthandz.idx
    lualatex math-shorthandz
    lualatex math-shorthandz

or run `l3build doc` in the repository. The `gind.ist` index style is required;
`-shell-escape` is not. With `latexmk`, add
`$makeindex = 'makeindex -s gind.ist %O -o %D %S';` to a `latexmkrc`.

## Contributing and releasing

Issues and pull requests are welcome at
https://github.com/tplobo/math-shorthandz.

### TODO

1. **Refactor `math-shorthandz.sty`** to remove duplication. Compare the rendered manual before and after each step to catch layout drift:
   - shared helpers for the frame (before/after/above/below and `\box_set_ht:Nn`/`\box_set_dp:Nn`), the overhang computation and the `\rlap`/`\box_move_up:nn` emit used by `\zscript`, `\zprime`, `\zlim` and `\zint`;
   - one shared four-branch `\mathchoice` front end, with mode and sub-style derived once, which would also take over `\__msz_begin:` and `\group_end:`;
   - set the per-call state (form, class, mode) in the same place in every command (`\zprime` sets it in its builder, the others in the public command).
1. **Rename the scale options for v2.0.0.** Replace the term "scale" in all keys (`zdot-scale-text`, `zscale-text`, ...) by a shorter one, so that `zscale` gets keys of the same form as the other commands. Candidates: `size`, `norm`, `rule`. Breaks every existing key, so it must wait for a major release. Once every command shares the key form `<command>-<term>-<style>`, one `\zlocal` with an empty command list (all commands) could change the scaling of every command at once, which is not possible today (e.g. a predefined prefix switching `<term>-absolute` to `false`).
1. **`\zscript` reference**: split `zscript-reference` into one reference for the vertical positions and one for the horizontal ones. Today one expression supplies all four edges, and the printed nucleus is centred on it, which is wrong when the two glyphs differ in width (`\mathbf{\Psi}` against `\Psi`).
1. **`\zalias*`**: a starred form that forces the definition over any macro that is not a command of the package. Not needed so far.
1. **`\zfrac`**: the "numerator-only" branch of `\__msz_frac_render:nn` is dead code (`\l__msz_frac_den_present_bool` is always true), and its `\bool_if:NF` has two brace groups, so the second would run unconditionally if the bool were ever false. Decide what the branch is for, or remove it. Low priority.

### Code and documentation guidelines

- `math-shorthandz.sty` has one section per public command, in dependency
  order. Each section keeps the same internal order: options and constants,
  helper functions, then the public command, each with a short comment
  (docstring) describing arguments and behaviour. Follow the existing
  spacing, indentation and comment style.
- Every tunable value is a package option (family `shorthand`, key names
  prefixed with the command name), read at call time. Positions and margins
  are ratios of the x-height or quad of the math style; scales follow the
  four-factor scheme described in the manual.
- Any change to a command must be reflected in its section of
  `math-shorthandz.tex` (syntax box, option table, examples) and in the
  Change History. Examples are introduced by a short paragraph ending in ":".
- There is no automated test suite: the manual itself is the test. A change is
  ready when `l3build doc` runs without errors and the examples look right.

### Versioning

Version numbers follow [Semantic Versioning](https://semver.org) (`MAJOR.MINOR.PATCH`):

- **MAJOR**: renamed or removed commands or option keys, or changes that alter
  the output of existing input;
- **MINOR**: new commands or options that keep existing input working;
- **PATCH**: bug fixes and documentation changes without behaviour change.

Below 1.0.0, anything may change at any time. The Change History in the manual
lists every version, newest first.

### Releasing a new version

Maintainers only. Replace `vX.Y.Z` by the new version.

1.  Make sure the working tree is clean and on the main branch.
2.  Add the `vX.Y.Z` entry to the Change History in `math-shorthandz.tex`
    (`l3build tag` does not touch it).
3.  Update version and date in `math-shorthandz.sty` and in the manual title:

    l3build tag vX.Y.Z

4.  Build the manual and check the log for errors and warnings:

    l3build doc

5.  Commit and tag:

    git add -A
    git commit -m "Release vX.Y.Z"
    git tag -a vX.Y.Z -m "math-shorthandz vX.Y.Z"
    git push origin main
    git push origin vX.Y.Z

6.  Build the CTAN archive:

    l3build ctan

7.  Validate the upload without sending it (`CTAN_EMAIL` must hold the uploader
    address, or pass `--email`). For updates, replace the announcement with
    `-m "text"` or `-F file`; the default in `build.lua` is the text of the first
    release:

        export CTAN_EMAIL=you@example.org
        l3build upload --debug

8.  Upload:

    l3build upload

## License

Copyright (C) 2020-2026 Tiago Pomella Lobo. Distributed and modified under the
LaTeX Project Public License, version 1.3c or later
(https://www.latex-project.org/lppl.txt). Maintenance status: author-maintained.

## Author and support

Tiago Pomella Lobo — https://github.com/tplobo/math-shorthandz (source, issues
and releases).
