# Neorg Tangle

Tangling will be a core neorg feature, this is simply me learning lua, treesitter and writing plugins for Neovim.

This repository is nothing more than tracking my progress, but feel free to use and I will try fix bugs where I can.
## Installation

### Packer

```
use 'KaiSpencer/neorg-tangle'
```

## Features

### Tangle current file

As it says on the tin, when run the current file will be parsed. @code blocks extracted and written to a file.

- Run this in a .norg file
- Currently only works for lua code blocks
- Output file will be placed alongside working file

```
require"neorg-tangle".tangle_file()
```
