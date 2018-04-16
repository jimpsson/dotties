-- ディレイ水流支援Lua rev.1
-- ディレイ水流成功に必要な各種値を表示

---D582:NMI終了
---　　｜（前半処理数計測）
---D89B:敵読み込み時のバンク切り替え箇所
---　　｜（後半処理数計測）
---D4A8:NMI開始

local water_pre_frame = 0         ---命令数を取得したときのフレーム
local water_pre_flag = 0          ---スクロールカウントを記録するか
local water_pre_temp = 0          ---処理数仮記録
local water_pre_instructions = 0  ---出力処理数

local water_next_frame = 0         ---命令数を取得したときのフレーム
local water_next_flag = 0          ---スクロールカウントを記録するか
local water_next_temp = 0          ---処理数仮記録
local water_next_instructions = 0  ---出力処理数

local enemy_bank = 0               ---もし成功した場合に読まれると予想されるバンク

--=----
-- すべての命令実行に割り込み
-- TODO: 領域をしぼる、一括で処理しない？その他無駄な処理をしないような工夫
memory.registerexec(0x8000, 0x8000, function(address)

	local pc = address -- memory.getregister("pc")
	local b1 = memory.readbyte(pc)

	--NMI終了
	if pc == 0xd582 then

		if(water_pre_flag == 0)then
			water_pre_flag = 1
		end

	--LoadEnemy Bank切り替え処理
	elseif pc == 0xd89b and b1 == 0xa9 then

		--直前のバンクを取得
		enemy_bank = memory.readbyte(0x42)

		if(water_pre_flag == 1)then
			water_pre_flag = 0
			water_pre_instructions = water_pre_temp
			water_pre_temp = 0
			water_pre_frame = movie.framecount()
		end
		
		if(water_next_flag == 0)then
			water_next_flag = 1
		end


	--NMI開始
	elseif pc == 0xd4a8 then

		--LoadEnemy Bank切り替え処理に到達する前に2度目のNMI発生した場合は初期化
		if(water_pre_flag == 1)then
			water_pre_flag = 0
			water_pre_temp = 0
		end

		if(water_next_flag == 1)then
			water_next_flag = 0
			water_next_instructions = water_next_temp
			water_next_temp = 0
			water_next_frame = movie.framecount()
		end

	else

		--負方向記録
		if(water_pre_flag == 1)then

			water_pre_temp = water_pre_temp + 1

		end

		--負方向記録
		if(water_next_flag == 1)then

			water_next_temp = water_next_temp + 1

		end

	end

end)

gui.register(function()
	
	-- X座標取得
	local RockX  = math.floor((memory.readbyte(0x480)*256+memory.readbyte(0x4A0))/256.0 * 1000)/1000
	-- Xスピード取得
	local RockXS = math.floor((memory.readbytesigned(0x4F9)*256+memory.readbyte(0x510))/256.0 * 1000)/1000
	-- Y座標取得
	local RockY  = math.floor((memory.readbyte(0x600)*256+memory.readbyte(0x620))/256.0 * 1000)/1000
	-- Yスピード取得
	local RockYS = math.floor((memory.readbytesigned(0x680)*256+memory.readbyte(0x660))/256.0 * 1000)/1000

	-- 現在のバンク取得
	local current_bank = memory.readbyte(0x42)
	local current_frame = movie.framecount()

	local xadj, yadj = 0, 5
	gui.text(5+xadj,5+yadj, "X      ->:"..RockX.."("..RockXS..")")
	gui.text(5+xadj,15+yadj,"Y      ->:"..RockY.."("..RockYS..")")
	-- 行数表示
	gui.text(5+xadj,25+yadj,"PRE    ->:"..tostring(water_pre_instructions) .. "(" .. tostring(water_pre_frame) .. ")")
	gui.text(5+xadj,35+yadj,"NEXT   ->:"..tostring(water_next_instructions) .. "(" .. tostring(water_next_frame) .. ")")
	gui.text(5+xadj,45+yadj,"ENMYBNK->:"..tostring(enemy_bank).."(" .. tostring(water_pre_frame) .. ")")
	gui.text(5+xadj,55+yadj,"CRNTBNK->:"..tostring(current_bank).."(" .. tostring(current_frame) .. ")")
end)



while true do
	emu.frameadvance()
end
