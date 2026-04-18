# dotfiles

## 思想

### 凝集性を重視

各 feature は**自己完結**している。

- nvim に関するものは `features/nvim/` に全部ある
- nvim フォルダを見れば nvim の全てがわかる
- 外部への依存は最小限にする

### 重複OK

複数の feature が同じツールを `brew install` しても良い。

```zsh
# nvim/install.zsh
brew install lazygit  # nvim から使う

# 将来 git/install.zsh に追加するかも
brew install lazygit  # ターミナルで使う
```

`brew install` は冪等（既にあれば何もしない）なので問題ない。

### シンプルさ優先

- 複雑な仕組みは避ける
- Brewfile は使わない（凝集性が下がるため）
- 必要になったら考える

### 冪等性は追わない

このdotfilesは**install の冪等性のみ**担保している。

- `brew install` は冪等（何度実行しても同じ結果）
- シンボリックリンクも上書きされるだけ

**uninstall / cleanup は冪等ではない。**

理由: 重複OKルールにより、あるツールを「誰が使っているか」を追跡していない。

```
例: lazygit
- nvim/install.zsh で brew install lazygit
- 将来 git/install.zsh でも brew install lazygit するかも

このとき nvim を削除して brew uninstall lazygit すると、
git で使いたかった lazygit も消える。
```

だから **uninstall は自動化しない**。人間が判断する。

## 構造

```
dotfiles/
├── bootstrap.zsh     # .zshrc から読み込むエントリポイント
├── setup.zsh         # 初回セットアップ
├── shell.zsh         # グローバルなシェル設定
├── platform/
│   └── macos.zsh     # macOS 固有設定
└── features/         # 機能ごとのモジュール
    └── {feature}/
        ├── install.zsh   # インストール処理（1回だけ実行）
        ├── shell.zsh     # シェル設定（毎回読み込み）
        └── config/       # 設定ファイル（シンボリックリンク）
```

## 使い方

### 初回セットアップ

```zsh
git clone https://github.com/xxx/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.zsh
```

### GitHub SSH 鍵のセットアップ（新マシン初回のみ）

`.gitconfig` の `insteadOf` により HTTPS の GitHub URL は SSH に自動書換される。
新マシンでは以下で鍵を作って GitHub に登録する（dotfiles 内に鍵自体は入れない）。

```zsh
ssh-keygen -t ed25519 -C "your@email" -f ~/.ssh/id_ed25519 -N ""
gh auth refresh -h github.com -s admin:public_key   # scope 不足時のみ
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(scutil --get ComputerName)"
ssh -T git@github.com   # 疎通確認
```

### 別マシンへの同期

別 PC で `git pull` した後の同期は **Claude に頼むのが推奨**。

```
（Claude Code に向かって）「このPCを sync して」
```

Claude は以下を順に行う:

1. `~/.dotfiles-last-sync` を baseline に、git diff で**消えた install 痕跡**（brew / curl / symlink / ランタイム等）を抽出
2. 残存しているものを承認制で削除（cleanup）
3. `./sync.zsh` を実行（全 `install.zsh` 再実行、冪等）
4. `~/.dotfiles-last-sync` を現在の HEAD で更新

直接 `./sync.zsh` を叩いても install は冪等に走るが、cleanup はスキップされる。  
（前回 sync から進んでいる場合、起動時に Claude 経由を促す警告が出る）

### feature の追加

1. `features/{name}/` ディレクトリを作成
2. `install.zsh` に brew install やシンボリックリンク処理を書く
3. `shell.zsh` に alias や環境変数を書く
4. `./setup.zsh` を実行（または `source features/{name}/install.zsh`）

### feature の削除

1. `features/{name}/` ディレクトリを削除
2. brew パッケージは**残る**（手動で消すか放置）
3. シンボリックリンクも**残る**（手動で消す）

### cleanup

定期的に手動で棚卸しする。

```zsh
brew leaves        # 依存されてないパッケージ一覧
brew uninstall xxx # 要らないものを手動で消す
```

⚠️ 他の feature で使ってないか確認してから消すこと。
