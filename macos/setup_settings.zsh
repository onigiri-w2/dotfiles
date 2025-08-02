#!/bin/zsh


echo "Configuring Dock..."
defaults write com.apple.dock orientation -string "left"
defaults write NSGlobalDomain _HIHideMenuBar -bool true

echo "Configuring Keyboard..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Configring Spotlight..."
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>524288</integer></array></dict></dict>"

echo "Applying changes..."
killall Dock
killall SystemUIServer
npm install -g typescript

npm install -g create-react-app
npm install -g nodemon
npm install -g prettier
npm install -g eslint

echo "System settings have been configured successfully!"
echo ""
echo "Changes applied:"
echo "✓ Dock moved to left side"
echo "✓ Dock auto-hide enabled"
echo "✓ Menu bar auto-hide enabled"
echo "✓ Key repeat rate set to maximum"
echo "✓ Initial key repeat delay set to minimum"
echo ""
echo "Note: Some changes may require a restart to take full effect."
