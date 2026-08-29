# lang-go を このPCにセットアップする
# パッケージ（goenv）は Brewfile を参照。

# `goenv use <ver> --global --yes` は未導入なら install も行う（旧来の
# `goenv install` + `goenv global` の2手を兼ねる。`goenv global` は deprecated）。
# --yes が無いと非対話環境で install の確認を求めて失敗する。
# 版はパッチまで正確に指定する必要がある（`1.27` のような前置きでは not found）。
# 毎回叩くと成功バナーを出すので、既に目的の版が global なら何もしない。
goenv current 2>/dev/null | grep -q '^1\.27' || goenv use 1.27.0 --global --yes

# brew で goenv 本体が上がると shim が古い Cellar パス（libexec/goenv 等）を
# 指したまま壊れる。実際に壊れている時だけ貼り直す（rehash は毎回 "Rehashing..." を出すため）。
"$HOME/.goenv/shims/go" version >/dev/null 2>&1 || goenv rehash
