# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

個人用 macOS dotfiles。zsh + Homebrew 前提。`features/` 配下の自己完結モジュール構成。

## Commands

- 初回セットアップ: `./setup.zsh` （Homebrew 導入 → 全 feature の `install.zsh` 実行 → macOS 設定 → `.zshrc` に `bootstrap.zsh` を追記）
- 単一 feature の再インストール: `source features/{name}/install.zsh`
- シェル再読込: `source ~/.zshrc` (alias: `zshreload`)
- ルートへ移動: `cddot`

テストスイートや lint は無い（シェルスクリプトのみ）。

## Architecture

### Feature-based modular layout

`features/{name}/` は自己完結していて、その feature に関する全て（brew install、config、alias）を内包する。各 feature は次のファイルを持ち得る:

- `install.zsh` — 1回だけ実行（`setup.zsh` 経由）。brew install、シンボリックリンク作成。
- `shell.zsh` — シェル起動ごとに `bootstrap.zsh` から source される。alias・環境変数・`eval` フック。
- `zinit.zsh` — zinit プラグイン定義（`bootstrap.zsh` が `shell.zsh` より先に source する）。
- `config/` — 設定ファイル実体。`install.zsh` が `~/.config/{name}` 等へ symlink する。

例外: `features/claude/install.sh` は `.sh` 拡張子で、`~/.claude/skills` への symlink もここで作る。

### Load order (bootstrap.zsh)

1. `shell.zsh` (グローバル設定・Homebrew shellenv)
2. `features/zinit/shell.zsh` を先に初期化（プラグインマネージャが他の `zinit.zsh` より前に必要）
3. 残り feature を順不同ループで `zinit.zsh` → `shell.zsh` の順に source

新 feature を追加する際もこの規約に従えば `bootstrap.zsh` の編集は不要。

### 設計方針（README.md 抜粋）

- **凝集性優先**: 外部依存は最小限。feature 間で brew パッケージが重複してもよい（`brew install` は冪等なので）。
- **Brewfile を使わない**（凝集性が下がるため）。
- **install のみ冪等を担保**。uninstall/cleanup は自動化しない — 削除が他 feature に影響する可能性があるので人間が `brew leaves` を見て判断する。
- feature 削除時に brew パッケージと symlink は**残す**（意図的）。
- feature 間に依存が必要なら install.zsh 内で `source` する（例: `nvim/install.zsh` が `lang-node/install.zsh` を source）。

### Local overrides (git 管理外)

`.gitignore` で除外される local 設定:

- `features/local/` — このマシン固有の feature 置き場
- `features/hammerspoon/config/hammerspoon/local.lua` — hammerspoon 個人設定
- `.gitconfig.local` — git の個人情報

コミット前にこれらへ変更を入れないよう注意。

### Platform 設定

`platform/macos.zsh` は `setup.zsh` が Darwin でのみ呼ぶ。Dock・キーリピート・Spotlight 無効化など `defaults write` 系の1回だけの適用。
