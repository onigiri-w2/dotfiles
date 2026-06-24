# jira-cli の認証情報 (API token) を macOS Keychain で扱う。
#
# 前提: jira-cli 自体は token を保存しない。実行時に JIRA_API_TOKEN env か ~/.netrc を
#       読むだけ (`jira init` は config 生成時のメタデータ取得に token を使うが永続化しない)。
#
# 方針:
#   - token は Keychain の generic-password (service=jira-cli) に保存する。
#     .zshrc にも平文ファイル (.netrc 等) にも残さない。
#   - グローバルに export しない。jira 実行時に子プロセスへだけ JIRA_API_TOKEN を注入する
#     (_jira_with_token)。親シェルの env に乗らないので、他サブプロセス
#     (AI エージェント含む) から `env` で覗かれない。

JIRA_KEYCHAIN_SERVICE="jira-cli"

# Keychain から token を取り出して stdout に出す。無ければ非ゼロ。
_jira_token_load() {
  security find-generic-password -a "$USER" -s "$JIRA_KEYCHAIN_SERVICE" -w 2>/dev/null
}

# token を Keychain に保存する。-U で既存を上書き (ローテーション対応)。
_jira_token_save() {
  security add-generic-password -U -a "$USER" -s "$JIRA_KEYCHAIN_SERVICE" -w "$1"
}

# 与えたコマンドを、token を env 注入した子プロセスで実行する。
# token 未登録なら登録方法を促して中断する。
_jira_with_token() {
  local token
  token="$(_jira_token_load)"
  if [[ -z "$token" ]]; then
    print "JIRA API token not found in Keychain." >&2
    print "Run 'jira-login' to register (or re-register) your API token." >&2
    return 1
  fi
  JIRA_API_TOKEN="$token" "$@"
}

# token を Keychain に登録する。初回や 401 (ローテーション) 時に手で叩く。
jira-login() {
  local token
  print -n "Paste JIRA API token: "
  read -rs token
  print
  [[ -z "$token" ]] && { print "aborted (empty)."; return 1; }

  _jira_token_save "$token" && print "Stored in Keychain (service=$JIRA_KEYCHAIN_SERVICE)."
}
