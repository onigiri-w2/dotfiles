#!/bin/zsh

# macOS システム設定
# 1回だけ実行

echo "Configuring macOS settings..."

# Dock
echo "Configuring Dock..."
defaults write com.apple.dock orientation -string "left"

# メニューバー非表示
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# キーボード
echo "Configuring Keyboard..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Spotlight (Cmd+Space を無効化、他のLauncherアプリと競合しないようにするため)
echo "Configuring Spotlight..."
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"

# 設定を反映
echo "Applying changes..."
killall Dock
killall SystemUIServer

echo ""
echo "macOS settings configured:"
echo "✓ Dock moved to left side"
echo "✓ Menu bar auto-hide enabled"
echo "✓ Key repeat rate set to maximum"
echo "✓ Initial key repeat delay set to minimum"
echo ""
echo "Note: Some changes may require a restart to take full effect."
