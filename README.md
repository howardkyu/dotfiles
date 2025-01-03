# dotfiles

## 🗿 Overview

This [dotfiles](https://github.com/howardkyu/dotfiles) repository is managed with [`chezmoi🏠`](https://www.chezmoi.io/), a dotfiles manager. The setup scripts target for Linux with specific support for Ubuntu.

The actual dotfiles exist under the [`home`](https://github.com/howardkyu/dotfiles/tree/main/home) directory specified in the [`.chezmoiroot`](https://github.com/howardkyu/dotfiles/blob/master/.chezmoiroot).
See [.chezmoiroot - chezmoi](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiroot/) more detail on the setting.

Inspiration is heavily taken from [shunk031's dotfile](https://github.com/shunk031/dotfile)

## 📥 Setup

To set up the dotfiles run the appropriate snippet in the terminal.

### 🖥️ `Ubuntu`
- Configuration snippet of the Ubuntu environment

```console
bash -c "$(wget -qO - https://raw.githubusercontent.com/howardkyu/dotfiles/refs/heads/main/setup.sh)"
```

