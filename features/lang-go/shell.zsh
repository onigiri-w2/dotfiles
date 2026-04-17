# lang-go 環境変数
# シェル起動時に毎回読み込む

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export GO111MODULE=on
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"
