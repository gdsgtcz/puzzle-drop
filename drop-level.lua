-- 掉落关卡测试
-- 概率配置
local lvPro = {
	{lv = 100, pro = 0.2, addPro = 0.05},
	{lv = 200, pro = 0.3, addPro = 0.05},
	{lv = 300, pro = 0.4, addPro = 0.05},
	{lv = 400, pro = 0.6, addPro = 0.05},
	{lv = 500, pro = 0.8, addPro = 0.05},
	{lv = 99999, pro = 1, addPro = 0.05},
}

-- 连续不掉落次数 (save)
local failCounts = 0

function getPro(index)
--	print("1 "..index)
	for i, v in ipairs(lvPro) do
--		print("2 "..i)
		if index <= v.lv then
--			print("3 "..v.pro)
			return v.pro
		end
	end
--	print("4 ")
	return 0
end

function getAddPro(index)
	for i, v in ipairs(lvPro) do
		if index <= v.lv then
			return v.addPro
		end
	end
	return 0
end

function isDrop(index)
	if not index then return end
	local isdrop = false
	local pro = getPro(index) + getAddPro(index) * failCounts
	print("基础概率:", getPro(index))
	print("累加概率:", getAddPro(index))
	print("累计失败:", failCounts)
	print("最终概率:", pro)
	math.randomseed((os.clock()%1)*1000000)
	local rand = math.random(1, 100)
	print("随机数字:",rand)
--	print("5 -> "..rand)
	isdrop = rand <= pro*100
	if not isdrop then
		failCounts = failCounts + 1
	else
		failCounts = 0
	end
	return isdrop
end

-- test
function main()
	print("请输入测试关卡数:")
	local maxLevel = io.read()
	if maxLevel and tonumber(maxLevel) and tonumber(maxLevel) > 0 then
		for i = 1, maxLevel do
			print("关卡:", i)
			print("掉落结果:", isDrop(i), "\n")
		end
	else
		print("error input!!")
	end
end

main()
