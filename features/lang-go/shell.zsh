# lang-go 環境変数
# シェル起動時に毎回読み込む

export GO111MODULE=on
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.goenv/shims:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
