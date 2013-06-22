local BadGuy = {}
local Path = require "jessewarden.pathfinding.Path"

function BadGuy:new()
	local bad = display.newCircle(0, 0, 15)
	bad:setFillColor(0, 0, 255, 200)
	bad.startRow = nil
	bad.startCol = nil
	bad.tileMap = nil
	bad.speed = 0.1
	bad.target = nil
	
	bad.points = nil
	

	function bad:init(tileMap, startRow, startCol)
		gameLoop:addLoop(self)
		self.tileMap = tileMap
		self.startRow = startRow
		self.startCol = startCol
		local tile = self.tileMap:getTileView(startRow, startCol)
		self.x = tile.x
		self.y = tile.y
		self:nextPath()
	end

	function bad:destroy()
		self:dispatchEvent({name="onDestroyed", target=self})
		gameLoop:removeLoop(self)
		self.target = nil
		self:removeSelf()
	end

	function bad:tick(millisecondsPassed)
		local target = self.target
		if target == nil then return true end
		local deltaX = self.x - target.x
		local deltaY = self.y - target.y
		local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))

		local moveX = self.speed * (deltaX / dist) * millisecondsPassed
		local moveY = self.speed * (deltaY / dist) * millisecondsPassed

		if (math.abs(moveX) > dist or math.abs(moveY) > dist) then
			self.x = target.x
			self.y = target.y

			-- self.startRow = math.round(target.y / self.tileMap.tileHeight)
			-- self.startCol = math.round(target.x / self.tileMap.tileWidth)
			self.target = nil
			bad:nextPath()
			-- local t = function()
			-- 	bad:nextPath()
			-- end
			-- timer.performWithDelay( 100, t )
		else
			self.x = self.x - moveX
			self.y = self.y - moveY
		end
	end

	function bad:nextPath()
		self.target = nil
		local points = self.points
		-- print("points are:", points)
		if points == nil then
			local tileMap = self.tileMap
			local TILE_WIDTH = tileMap.tileWidth
			local TILE_HEIGHT = tileMap.tileHeight
			local myPath = Path:new()
			local foundMoves = myPath:findPath(tileMap.grid, self.startRow, self.startCol, 7, 7)
			points = {}
			local i
			-- print("*** path ***")
			for i = 1, #foundMoves do
				local pathItem = foundMoves[i]
				local newX = pathItem.y * TILE_WIDTH - self.width / 2
				local newY = pathItem.x * TILE_HEIGHT - self.height / 2
				-- print("x: " .. pathItem.x .. ", y:", pathItem.y)
				-- print(newX, newY)
				table.insert(points, {x=newX, y=newY})
			end
			self.points = points
		end

		if #points < 1 then
			self:destroy()
			return true
		end

		local nextPoint = table.remove(points, 1)
		-- local t = 1
		-- while points[t] do
		-- 	print("t:", t, ", points[t]:", points[t])
		-- 	t = t + 1
		-- end
		-- print("next:", nextPoint.x, nextPoint.y)
		self.target = nextPoint
	end

	return bad
end

return BadGuy