# 0001 - nvim で AI の変更に PR レビュー風コメントをする

- Status: experimenting（A を試用中）
- Date: 2026-07-09

## 背景

AI（Claude Code）が加えた変更に対して、GitHub の PR レビューのように「行に紐づいたコメント」を返したい。
diffview.nvim / neogit は導入済み（80d03a0, 1923052）だが、diffview 単体にはコメント機能が無い。
核となる要件は「行に紐づいたコメントを貯めて、まとめて AI に渡す」こと。
対象は 1 行とは限らず、複数行の範囲（関数全体・ブロック全体への指摘）も扱えること
（GitHub PR の multi-line comment に相当）。

## 選択肢

### A. インラインマーカー方式（ゼロ実装）

diffview（`<leader>gv`）で変更を巡回しながら、気になった行にコードコメントとして直接書き込む。

```lua
some_function()  -- REVIEW: ここは早期リターンにして。ネスト深すぎ
```

レビュー後に Claude へ「`REVIEW:` コメントを全部拾って対応し、コメント自体も消して」と指示する。
aider の `AI!` コメントと同じ発想。

複数行への指摘は、ブロックの直前にコメントを置いて「以下の関数全体」のように文章で範囲を示す。

- 長所: コメントが行に物理的に張り付くので、レビュー中に他の編集をしても位置がずれない。ツール不要。
- 短所: バッファを一時的に汚す。消し忘れは pre-commit の `grep REVIEW:` で弾ける。
  範囲の境界は文章表現に頼るため、B ほど厳密には示せない。

### B. Pending review 方式（小さい自作、PR 体験に最も近い）

diffview のバッファ内で keybind（例 `<leader>gc`）を押すと `vim.ui.input` でコメントを聞き、
`ファイル:行範囲: コメント` をレビューファイル（`.claude/review.md` 等）に追記する lua 関数（40 行程度）。
normal モードならカーソル行、visual モードなら選択範囲（`'<` 〜 `'>`）を記録すれば、
1 行コメントと multi-line コメントの両方を同じ keybind で扱える。
レビュー完了後、`/apply-review` 的な skill で Claude に渡す（= Submit review に相当）。

- 長所: GitHub の「pending comments を貯めて Submit」に最も近く、コードを汚さない。
- 短所: 行番号ベースなので貯めている間に編集するとずれる。コメント時に該当行のテキストも記録しておけば Claude 側でズレを吸収できる。

### C. 本物の PR + octo.nvim / `gh`

octo.nvim で nvim 内から実際の PR インラインコメントを書き、Claude は `gh api` で読む。
push の儀式が重いのでローカル反復には不向き。チームに見せる PR 用と割り切る。

### 補足: claudecode.nvim

coder/claudecode.nvim を入れると Claude Code の IDE プロトコルを nvim が話せるようになり、
ビジュアル選択した範囲を context として Claude に送れる。1 件ずつ対話的に指摘する用途で、A / B と補完関係。

## 決定（2026-07-09）

まず A で運用を始める。「コードを汚したくない」「Submit の儀式が欲しい」と感じたら B を組む。
B は `features/nvim`（lua 関数 + keybind）と `.claude`（skill）に収まる規模。

### A の運用ルール

- マーカーは `REVIEW:`（コメント記法は言語に従う。例: `-- REVIEW: ...`, `# REVIEW: ...`, `// REVIEW: ...`）
- 複数行への指摘はブロック直前の行に置き、「以下の関数全体」のように範囲を文章で示す
- レビューを終えたら Claude に「REVIEW コメントに対応して」と依頼する。
  Claude は `REVIEW:` を grep で全部拾い、各指摘に対応したうえでコメント自体を削除する
- 対応に異論がある場合、Claude は消さずに返答を追記して相談する
