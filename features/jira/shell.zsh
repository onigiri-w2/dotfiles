# jira-cli シェル設定。毎回読み込む。未インストールのマシンでも壊れないようガードする。
#
# jira-cli は token を JIRA_API_TOKEN env か ~/.netrc からしか読まない (自前保存しない)。
# ここでは token を Keychain に置き、jira 実行時にだけ env 注入する。詳細は lib/auth.zsh。

if command -v jira >/dev/null 2>&1; then
  source "${0:A:h}/lib/auth.zsh"

  # jira 本体ラッパ: token を子プロセスにだけ注入して実行する。
  jira() { _jira_with_token command jira "$@" }

  # zsh 補完。token 不要なので `command` で本体を直接呼ぶ (ラッパを経由させない)。
  source <(command jira completion zsh) 2>/dev/null

  # alias
  alias ji='jira issue'
  alias jil='jira issue list'
  alias jiv='jira issue view'
  alias jic='jira issue create'
  alias js='jira sprint'
  alias jp='jira project'
fi
