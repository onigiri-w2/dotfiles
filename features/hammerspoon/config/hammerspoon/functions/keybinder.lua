-- keybinder.lua
local hotkey = require("hs.hotkey")
local timer = require("hs.timer")

local M = {}

-- シーケンス情報を保持するテーブル
local sequences = {}

-- 最後のキー入力の情報
local lastKeyPress = {
	time = 0,
	key = nil,
}

function M.bindSequence(mods, keys, callback, timeFrame)
	local timeout = timeFrame or 0.5

	-- 最初のキーと2番目のキーが同じ場合と違う場合でハンドラを分ける
	local isSameKey = keys[1] == keys[2]

	-- キーハンドラ
	local keyHandler = function(keyName)
		local now = timer.secondsSinceEpoch()

		if isSameKey then
			-- ダブルタップの場合
			if keyName == lastKeyPress.key and (now - lastKeyPress.time) <= timeout then
				local result = callback()
				if type(result) == "function" then
					result()
				end
				lastKeyPress.time = 0 -- リセット
			else
				lastKeyPress.time = now
			end
		else
			-- 異なるキーのシーケンスの場合
			if lastKeyPress.key == keys[1] and keyName == keys[2] and (now - lastKeyPress.time) <= timeout then
				local result = callback()
				if type(result) == "function" then
					result()
				end
			end
			lastKeyPress.time = now
		end

		lastKeyPress.key = keyName
	end

	-- 各キーのバインディングを作成
	local bindings = {}
	for i, key in ipairs(keys) do
		local binding = hotkey.bind(
			mods,
			key,
			function()
				keyHandler(key)
			end,
			nil,
			function()
				keyHandler(key)
			end
		)
		table.insert(bindings, binding)
	end

	-- シーケンス情報を保存
	table.insert(sequences, {
		bindings = bindings,
		callback = callback,
	})

	return {
		unbind = function()
			for _, binding in ipairs(bindings) do
				binding:delete()
			end
			-- シーケンス情報を削除
			for i, seq in ipairs(sequences) do
				if seq.callback == callback then
					table.remove(sequences, i)
					break
				end
			end
		end,
	}
end

return M
