--アイテム3号の右移動算出Lua＠ロックマン２

--高さテキストを取得する
function get_width_str(DefaultWidth,Width,Visible,Arm)
	--アイテム3号が存在するとき
	if((Visible == 0x86 or Visible == 0xC6) and Arm == 0xB)then
		return string.format(" %03d",Width)
	--存在しないとき
	else
		return string.format("*%03d",DefaultWidth)
	end
end

--高さを取得する
function get_width(DefaultWidth,Width,Visible,Arm)
	--アイテム3号が存在するとき
	if((Visible == 0x86 or Visible == 0xC6) and Arm == 0xB)then
		return Width
	--存在しないとき
	else
		return DefaultWidth
	end
end

--右ヒントを取得する
function get_right(Seed,MaxFrame,Width)
	local RightText = ""
	for i = 0,MaxFrame,1 do
		Seed = Seed + 0x27
		if(Seed > 0xFF)then
			RightText = RightText .. "|"
			Seed = Seed - 0x100
			Width = Width + 2
		else
			RightText = RightText .. "."
			Width = Width + 1
		end
	end
	return string.format("%s %d",RightText,Width)
end


--CSVを出力するか
local output_csv_flag = false

--CSVを出力する最大フレーム数
local max_csv_frame = 100

--シードごとのmax_csv_frameフレームの高さCSVを出力する
function output_csv(FileName,Seed,DefaultHeight,Height,Visible,Arm)

	local NowHeight = 0

	--アイテム3号が存在するとき
	if((Visible == 0x82 or Visible == 0xC2) and Arm == 0xB)then
		NowHeight = Height
	--存在しないとき
	else
		NowHeight = DefaultHeight
	end

	--出力
	fp = io.open (FileName,"w")

	--ヘッダ
	fp:write(" ,")
	for i= 0,max_csv_frame,1 do
		fp:write(string.format("%d,",i))
	end
	fp:write("\n")

	--シードごとの高さを出力
	format = ""
	for i = 0,255,1 do
		if(Seed == i)then
			format = "%d!,%s\n"
		else
			format = "%d,%s\n"
		end
		fp:write(string.format(format,i,get_height_csv(NowHeight,i)))
	end

	--閉じる
	fp:close()

	output_csv_flag = false
end

--シードに対応するmax_csv_frameフレーム分のCSVテキストを取得する
function get_width_csv(Width,Seed)
	width_csv = ""
	for i = 0,max_csv_frame,1 do
		Seed = Seed + 0x27
		if(Seed > 0xFF)then
			Seed = Seed - 0x100
			Width = Width + 2
		else
			Width = Width + 1
		end
		if(Width <= 0)then
			break
		end
		width_csv = width_csv .. Width .. ","
	end
	return width_csv
end


--何フレーム分ボタンを保存するか
local max_bakinp_frame = 20
--ボタンをしばらく押し続けているか、または一瞬押したかチェック
function holding_key(inp,bakinp,key)

	if((inp[key] == false or inp[key] == nil) and bakinp[2][key] == true)then
		return true
	end
	for i = 1,max_bakinp_frame,1 do
		if(bakinp[i][key]~=true)then
			return false
		end
	end
	return true
end

--何フレーム分右ヒントを表示するか
local right_display_frame = 20
--CSVセーブ時の文言表示
local output_msg_frame = false

gui.register(function()

	--現在装備中の武器
	local Arm = memory.readbyte(0xA9)

	--すべてのアイテム3号のデフォルトとなる高さ
	local DefaultWidth = memory.readbyte(0x4a0)

	--アイテム3号の高さ
	local Width = {}
	Width[1] = memory.readbyte(0x464)
	Width[2] = memory.readbyte(0x463)
	Width[3] = memory.readbyte(0x462)

	--シード
	local Seed = {}
	Seed[1] = memory.readbyte(0x484)
	Seed[2] = memory.readbyte(0x483)
	Seed[3] = memory.readbyte(0x482)

	--存在
	local Visible = {}
	Visible[1] = memory.readbyte(0x424)
	Visible[2] = memory.readbyte(0x423)
	Visible[3] = memory.readbyte(0x422)

	--高さ算出
	local Item3Width = {}
	Item3Width[1] = get_width_str(DefaultWidth,Width[1],Visible[1],Arm)
	Item3Width[2] = get_width_str(DefaultWidth,Width[2],Visible[2],Arm)
	Item3Width[3] = get_width_str(DefaultWidth,Width[3],Visible[3],Arm)

	--上昇ルール算出
	local Item3Move = {}
	Item3Move[1] = get_right(Seed[1],right_display_frame,get_width(DefaultWidth,Width[1],Visible[1],Arm))
	Item3Move[2] = get_right(Seed[2],right_display_frame,get_width(DefaultWidth,Width[2],Visible[2],Arm))
	Item3Move[3] = get_right(Seed[3],right_display_frame,get_width(DefaultWidth,Width[3],Visible[3],Arm))

	--出力
	gui.text(5,0, string.format("Item3->:Width($464-462) %df",right_display_frame))
	gui.text(5,10, string.format("1st->:%s(%03d) %s",Item3Width[1],Seed[1],Item3Move[1]))
	gui.text(5,20,string.format("2nd->:%s(%03d) %s",Item3Width[2],Seed[2],Item3Move[2]))
	gui.text(5,30,string.format("3rd->:%s(%03d) %s",Item3Width[3],Seed[3],Item3Move[3]))

	--CSV出力
	if(output_csv_flag == true)then
		output_csv("Item3_1st.csv",Seed[1],DefaultWidth,Width[1],Visible[1],Arm)
		output_csv("Item3_2nd.csv",Seed[2],DefaultWidth,Width[2],Visible[2],Arm)
		output_csv("Item3_3rd.csv",Seed[3],DefaultWidth,Width[3],Visible[3],Arm)
	end

	
	--入力の取得
	local inp = input.get()
	local input = inp

	--入力のバックアップ値初期化
	if(bakinp == nil)then
		bakinp = {}
	end
	for i = 1,max_bakinp_frame,1 do
		if(bakinp[i] == nil)then
			bakinp[i] = {}
		end
	end

	--ボタンのバックアップ
	for i = max_bakinp_frame,1,-1 do
		if(i == 1)then
			bakinp[1] = input
		else
			bakinp[i] = bakinp[i-1]
		end
	end


	--Sボタンを押したときCSV出力
	if(inp.S == true and (bakinp.S == nil or bakinp.S == false))then
		output_csv_flag = true
		output_msg_frame = movie.framecount()
	end

	--CSV出力したらしばらくの間メッセージ表示
	if(output_msg_frame ~= false)then
		if(movie.framecount() < (output_msg_frame + 60))then
			gui.text(5,40, "output csv file")
		end
	end

	--Pボタンを押したとき上昇ヒント表示増加
	if(holding_key(inp,bakinp,"P")) then
		right_display_frame = right_display_frame + 1
		if(right_display_frame > 40)then
			right_display_frame = 40
		end
	end
	
	--Mボタンを押したとき上昇ヒント表示減少
	if(holding_key(inp,bakinp,"O"))then
		right_display_frame = right_display_frame - 1
		if(right_display_frame < 0)then
			right_display_frame = 0
		end
	end

	--1stSeed+1
	if(holding_key(inp,bakinp,"Y"))then
		memory.writebyte(0x4c4,memory.readbyte(0x4c4)+0x01)
	end
	--1stSeed-1
	if(holding_key(inp,bakinp,"H"))then
		memory.writebyte(0x4c4,memory.readbyte(0x4c4)-0x01)
	end

	--2ndSeed+1
	if(holding_key(inp,bakinp,"U"))then
		memory.writebyte(0x4c3,memory.readbyte(0x4c3)+0x01)
	end
	--2ndSeed-1
	if(holding_key(inp,bakinp,"J"))then
		memory.writebyte(0x4c3,memory.readbyte(0x4c3)-0x01)
	end

	--3rdSeed+1
	if(holding_key(inp,bakinp,"I"))then
		memory.writebyte(0x4c2,memory.readbyte(0x4c2)+0x01)
	end
	--3rdSeed-1
	if(holding_key(inp,bakinp,"K"))then
		memory.writebyte(0x4c2,memory.readbyte(0x4c2)-0x01)
	end

end)


while true do
	emu.frameadvance()
end