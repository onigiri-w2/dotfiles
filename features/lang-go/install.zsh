# lang-go を このPCにセットアップする
# パッケージ（goenv）は Brewfile を参照。

# `goenv use <ver> --global` は未導入なら install も行う（旧来の install + global の2手を兼ねる。
# `goenv global` は deprecated）。ただし毎回叩くと成功バナーを出すので、既に 1.24 系なら何もしない。
goenv current 2>/dev/null | grep -q '^1\.24' || goenv use 1.24 --global

# brew で goenv 本体が上がると shim が古い Cellar パス（libexec/goenv 等）を
# 指したまま壊れる。実際に壊れている時だけ貼り直す（rehash は毎回 "Rehashing..." を出すため）。
"$HOME/.goenv/shims/go" version >/dev/null 2>&1 || goenv rehash
