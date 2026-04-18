# lang-go を このPCにインストール & setup する
# 1回だけ実行

brew install goenv
goenv versions --bare 2>/dev/null | grep -q '^1\.24' || goenv install 1.24
goenv global 1.24
