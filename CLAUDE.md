# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

個人用 macOS dotfiles。zsh + Homebrew 前提。`features/` 配下の自己完結モジュール構成。

## Commands

- 初回セットアップ: `./setup.zsh` （Homebrew 導入 → 全 Brewfile を bundle install → 全 feature の `install.zsh` 実行 → macOS 設定 → `.zshrc` に `bootstrap.zsh` を追記）
- 別マシンへの同期: `./sync.zsh` （bundle install → 全 `install.zsh` 再実行 → cleanup 候補の列挙。冪等）
- 単一 feature の再インストール: `source features/{name}/install.zsh`（brew は `sync.zsh` 側）
- シェル再読込: `source ~/.zshrc` (alias: `zshreload`)
- ルートへ移動: `cddot`

テストスイートや lint は無い（シェルスクリプトのみ）。

## Architecture

### Feature-based modular layout

`features/{name}/` は自己完結していて、その feature に関する全て（brew パッケージ、config、alias）を内包する。各 feature は次のファイルを持ち得る:

- `Brewfile` — brew / cask の宣言。`setup.zsh` / `sync.zsh` が全 feature 分を連結して1つの Brewfile として扱う。
- `install.zsh` — brew 以外のセットアップ。シンボリックリンク作成、外部インストーラ（`curl | bash` 等）、ランタイム導入。
- `shell.zsh` — シェル起動ごとに `bootstrap.zsh` から source される。alias・環境変数・`eval` フック。
- `zinit.zsh` — zinit プラグイン定義（`bootstrap.zsh` が `shell.zsh` より先に source する）。
- `config/` — 設定ファイル実体。`install.zsh` が `~/.config/{name}` 等へ symlink する。

`Brewfile` だけで済む feature には `install.zsh` を置かない（例: `browser`, `fonts`, `other`）。

### Load order

**setup.zsh / sync.zsh**: Brewfile の bundle install が先、`install.zsh` ループが後。
`install.zsh` は `jq` / `goenv` / `mise` 等の brew パッケージに依存するのでこの順序が必要。

**bootstrap.zsh**:

1. `shell.zsh` (グローバル設定・Homebrew shellenv)
2. `features/zinit/shell.zsh` を先に初期化（プラグインマネージャが他の `zinit.zsh` より前に必要）
3. 残り feature を順不同ループで `zinit.zsh` → `shell.zsh` の順に source

新 feature を追加する際もこの規約に従えば `bootstrap.zsh` の編集は不要。

### 設計方針（README.md 抜粋）

- **凝集性優先**: brew パッケージも feature 自身の `Brewfile` に書く。リポジトリ直下に巨大な Brewfile を1枚置く方式は取らない。
- **重複OK**: 複数 feature が同じパッケージを宣言してよい。全 Brewfile の**和集合**が「このマシンにあるべきもの」なので、片方の feature を消しても他方が宣言していれば残る。「誰が使っているか」は宣言自身が持っている。
- **install は冪等、削除は人間が判断**: `sync.zsh` は宣言から外れたものを**列挙するだけ**で消さない。手で入れたツールと消した feature の残骸を機械が区別できないため。
- feature 間に依存が必要なら install.zsh 内で `source` する（例: `nvim/install.zsh` が `lang-node/install.zsh` を source）。

### Local overrides (git 管理外)

`.gitignore` で除外される local 設定:

- `features/local/` — このマシン固有の feature 置き場。`features/local/Brewfile` を置けば
  「手で入れたが残したいもの」を宣言でき、cleanup 候補から外れる。
- `features/hammerspoon/config/hammerspoon/local.lua` — hammerspoon 個人設定
- `.gitconfig.local` — git の個人情報

コミット前にこれらへ変更を入れないよう注意。

### Platform 設定

`platform/macos.zsh` は `setup.zsh` が Darwin でのみ呼ぶ。Dock・キーリピート・Spotlight 無効化など `defaults write` 系の1回だけの適用。

## Sync 運用

`./sync.zsh` を叩くだけ。Claude が orchestrate する必要はない。

- cleanup 候補は「現在の宣言」と「現在のマシン」の差分で出す。git 履歴から削除痕跡を掘る必要は無い。
  - formula: `brew leaves` − 宣言。**leaves に絞るのが肝**。`brew bundle cleanup` は依存も全部並べるので
    100 件超の壁になって読めなくなる（実測 115 件 → leaves 17 件）。親を消せば依存は次回 leaves として
    浮上するので、繰り返せば収束する。
  - cask: 導入済み全件 − 宣言（cask に依存関係は無いので絞り込み不要）。
- 出てきた候補は列挙のみ。消すかは人間が決める。残したいものは `features/local/Brewfile` へ。
- dangling symlink は `~/.config` 直下のみ検出する。`~/.hammerspoon` 等の直貼りは対象外。
- Homebrew のキャッシュ掃除（`brew cleanup`）はこの仕組みの対象外。気が向いたら手で叩く。

### 注意

- Brewfile には **alias ではなく正式名**を書く。`brew leaves` は正式名を返すので、alias のままだと
  差分が取れず「宣言に無い」と誤判定される（`nvim` → `neovim`、`font-monaspace-nerd-font` →
  `font-monaspice-nerd-font`）。追加時は `brew info <name>` で確認する。
- `brew bundle install` は既定で outdated を upgrade するため `--no-upgrade` を付けている。
  更新は `brew upgrade` で明示的に行う。
- brew 以外で入れたもの（`curl | bash`、`git clone`、`goenv install`、`mise use`）は cleanup 候補に出ない。
  該当 feature の `install.zsh` を見て手で対応する。
- `features/local/` 配下の変更は git に出ないので cleanup 対象から外れる。これは仕様。
