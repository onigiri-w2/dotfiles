# jira-cli (ankitpokhrel/jira-cli) を このPCにインストールする
# 1回だけ実行
#
# 設定はここでは行わない (install は非対話・冪等に保つ)。シェル再読込後に各自で:
#   jira init     # サーバURL・login・project・board を対話設定 (~/.config/.jira/.config.yml)
#   jira-login    # API token を Keychain に保存 (features/jira/lib/auth.zsh が定義)
# jira-cli は token を自前保存しないので、jira-login で Keychain に置く必要がある。
# 設定実体 (~/.config/.jira/.config.yml) はアカウント／インスタンス固有なのでコミットしない。

# 本体。binary は `jira`。go-jira と `jira` 名が衝突するので併用不可。
brew install jira-cli

print "jira-cli installed. Reload your shell, then run 'jira init' and 'jira-login'."
