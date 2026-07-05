# lang-go を このPCにインストール & setup する
# 1回だけ実行

brew install goenv
goenv versions --bare 2>/dev/null | grep -q '^1\.24' || goenv install 1.24
goenv global 1.24

# brew で goenv 本体が上がると shim が古い Cellar パス（libexec/goenv 等）を
# 指したまま壊れるため、毎回 shim を貼り直す（冪等）。
goenv rehash
