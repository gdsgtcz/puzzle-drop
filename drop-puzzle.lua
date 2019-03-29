-- 掉落碎片测试

--[[
-- 掉落规则:
-- 初始状态不加入稀有碎片
-- 无稀有碎片且掉落次数大于默认轮询次数时加入稀有碎片
-- 掉落稀有碎片并且池内碎片数大于默认轮询次数时去掉池内稀有碎片,并重置当前轮询次数
-- 全部掉落完后重新初始化碎片池
]]

-- 碎片列表 1601 - 1602
local puzzleList = {
	rare1 = {
		puzzle = {
			"1601",
			"1602",
			"1603",
			"1604",
		},
		initNum = 4,
	},
	rare2 = {
		puzzle = {
			"1605",
			"1606",
			"1607",
		},
		initNum = 3,
	},
	rare3 = {
		puzzle = {
			"1608",
			"1609",
		},
		initNum = 1,
	},
}

-- const
-- 轮询数 
local turnCounts = 5

-- save
-- 当前轮询数
local currentTurnCount = 1
-- 稀有碎片池状态
local rarePoolStatus = false
-- 掉落碎片池
local puzzlePool = {
	
}
-- 稀有碎片池
local rarePuzzlePool = {
	
}

function table.nums(t)
	local count = 0
	for k, v in pairs(t) do
		count = count + 1
	end
	return count
end

-- 初始化碎片池
function initPuzzlePool()
	if not next(puzzlePool) then
		print("\n数据为空, 初始化新一组\n")
		-- 重置
		puzzlePool = {}
		rarePuzzlePool = {}
		rarePoolStatus = false
		-- 初始化
		for i, v in ipairs(puzzleList.rare1.puzzle) do
			puzzlePool[v] = puzzleList.rare1.initNum
		end
		for i, v in ipairs(puzzleList.rare2.puzzle) do
			puzzlePool[v] = puzzleList.rare2.initNum		
		end
		for i, v in ipairs(puzzleList.rare3.puzzle) do
			rarePuzzlePool[v] = puzzleList.rare3.initNum		
		end
	end
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function getPuzzleFromPool()
	math.randomseed((os.clock()%1)*1000000)
	local rand = math.random(1, getCountsOfPool())
	local n = 0
	for k, v in pairs(puzzlePool) do
		n = n + v
		if n >= rand then
			if puzzlePool[k] <= 1 then
				puzzlePool[k] = nil
			else
				puzzlePool[k] = puzzlePool[k] - 1
			end
			return k
		end
	end
end

-- 加入稀有
function addRarePuzleToPool()
	rarePoolStatus = true
	for k, v in pairs(rarePuzzlePool) do
		puzzlePool[k] = v
		rarePuzzlePool[k] = nil
	end
end

-- 去掉稀有
function removeRarePuzleToPool()
	rarePoolStatus = false
	for k, v in pairs(puzzlePool) do
		if checkRarePuzzleId(k) then
			puzzlePool[k] = nil
			rarePuzzlePool[k] = v
		end
	end
end

-- 检测id是否稀有
function checkRarePuzzleId(id)
	for i, v in ipairs(puzzleList.rare3.puzzle) do
		if v == id then
			return true
		end
	end
	return false
end

-- 获取掉落池总数
function getCountsOfPool()
	local count = 0
	for k,v in pairs(puzzlePool) do
		count = count + v
	end
	return count
end

-- 掉落
function dropPuzzle()
	initPuzzlePool()
	local retId
	print("轮询次数:",currentTurnCount)
	--检测是否加稀有
	if not rarePoolStatus and currentTurnCount >= turnCounts then
		print("加入稀有")
		addRarePuzleToPool()
	end
	-- 掉落
	retId = getPuzzleFromPool()
	print("掉落=>", retId)
	if checkRarePuzzleId(retId) and getCountsOfPool() > turnCounts then
		-- 掉落稀有后,去掉剩余稀有id
		print("剔除稀有")
		removeRarePuzleToPool()
		currentTurnCount = 1
	else
		currentTurnCount = currentTurnCount + 1
	end
	print("\n")
	return retId
end

-- test
function main()
	print("请输入测试关卡数:")
	local maxIndex = io.read()
	if maxIndex and tonumber(maxIndex) and tonumber(maxIndex) > 0 then
		for i = 1, maxIndex do
			print("---第" .. i .. "次掉落---")
			dropPuzzle()
		end
	else
		print("error input!!")
	end
end

main()