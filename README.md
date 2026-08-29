# dotfiles

## 思想

### 凝集性を重視

各 feature は**自己完結**している。

- nvim に関するものは `features/nvim/` に全部ある
- nvim フォルダを見れば nvim の全てがわかる
- 外部への依存は最小限にする

brew パッケージも例外ではなく、feature 自身の `Brewfile` に書く。
リポジトリ直下に巨大な Brewfile を1枚置く方式は取らない（凝集性が下がるため）。

### 重複OK

複数の feature が同じツールを宣言しても良い。

```ruby
# features/nvim/Brewfile
brew "lazygit"    # nvim から使う

# features/tmux/Brewfile
brew "lazygit"    # prefix + g のポップアップから使う
```

`sync.zsh` は全 feature の Brewfile を連結して1つの宣言として扱う。
**和集合が「このマシンにあるべきもの」**なので、重複しても消えないし、
片方の feature を消しても、もう片方が宣言している限り残る。
「誰が使っているか」は宣言そのものが持っている。

### シンプルさ優先

- 複雑な仕組みは避ける
- 新しいツールを増やさない（brew に元から入っている `brew bundle` で足りる）
- 必要になったら考える

### install は宣言的、削除は人間が判断

- **install**: 冪等。`brew bundle install` も symlink 上書きも何度走らせてよい。
- **cleanup**: `sync.zsh` が「宣言に無いのに入っているもの」を**列挙するところまで**やる。
  実際に消すかは人間が決める。

自動で消さない理由は、手で入れたツールと、消した feature の残骸を機械が区別できないから。
残したいものは宣言に足せばよい（下記）。

## 構造

```
dotfiles/
├── bootstrap.zsh     # .zshrc から読み込むエントリポイント
├── setup.zsh         # 初回セットアップ
├── sync.zsh          # 2回目以降の同期 + cleanup 候補の提示
├── shell.zsh         # グローバルなシェル設定
├── platform/
│   └── macos.zsh     # macOS 固有設定
└── features/         # 機能ごとのモジュール
    └── {feature}/
        ├── Brewfile      # brew / cask の宣言
        ├── install.zsh   # brew 以外のセットアップ（symlink, 外部インストーラ等）
        ├── shell.zsh     # シェル設定（毎回読み込み）
        └── config/       # 設定ファイル（シンボリックリンク）
```

`Brewfile` だけで済む feature には `install.zsh` を置かない。

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

```zsh
git pull
./sync.zsh
```

`sync.zsh` は次の順に走る。

1. 全 `Brewfile` を連結して `brew bundle install`（未導入だけ入る。upgrade はしない）
2. 全 `install.zsh` を再実行（冪等）
3. **cleanup 候補を列挙**（宣言に無い brew パッケージ / dangling symlink）

3 は列挙だけで何も消さない。出てきたものを見て、要らなければ手で消す。

### cleanup

`sync.zsh` の最後に出る一覧を見て判断する。

- **残したい**: `features/local/Brewfile` に書く。次回から一覧に出なくなる
- **消したい**: `brew uninstall <name>` / `brew uninstall --cask <name>`

`features/local/` は `.gitignore` 済みなので、マシンごとに違う「手で入れたが残したいもの」を
ここに置ける。

一覧に出す formula は `brew leaves`（何にも依存されていないもの）に絞ってある。
依存パッケージまで並べると 100 件超の壁になって読めないため。
leaves を消したあと、宙に浮いた依存はまとめて掃除できる。

```zsh
brew uninstall d2 glow      # 要らない leaves を消す
brew autoremove             # 依存されなくなったパッケージを掃除
```

親を消せばその依存が次回の `sync.zsh` で leaves として出てくるので、
何回か回せば収束する。

⚠️ `brew bundle cleanup --force` は使わないこと。依存を含む全件（実測 115 件）を消しにいくので、
一覧に出ている 17 件とはスケールが違う。

### feature の追加

1. `features/{name}/` ディレクトリを作成
2. `Brewfile` に brew / cask を書く
3. brew 以外のセットアップ（symlink 等）が要れば `install.zsh` に書く
4. `shell.zsh` に alias や環境変数を書く
5. `./sync.zsh` を実行

### feature の削除

1. `features/{name}/` ディレクトリを削除
2. `./sync.zsh` を実行 → 残った brew パッケージと symlink が cleanup 候補に出る
3. 一覧を見て手で消す

brew 以外の方法で入れたもの（`curl | bash` 系、`git clone` 系）は cleanup 候補に出ない。
数は少ないので、消すときは該当 feature の `install.zsh` を見て手で対応する。
