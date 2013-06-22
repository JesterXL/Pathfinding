local BadGuy = {}
local Path = require "jessewarden.pathfinding.Path"
local ProgressBar = require "ProgressBar"
local HealthPoints = require "HealthPoints"

function BadGuy:new(parentGroup)
	local bad = display.newGroup()
	bad.classType = "BadGuy"
	if parentGroup then
		parentGroup:insert(bad)
	end

	bad.startRow = nil
	bad.startCol = nil
	bad.tileMap = nil
	bad.speed = 0.05
	bad.target = nil
	
	bad.points = nil

	bad.healthPoints = nil
	bad.destroyed = false

	function bad:init(tileMap, startRow, startCol)
		gameLoop:addLoop(self)

		local circle = display.newCircle(self, 0, 0, 15)
		circle:setFillColor(0, 0, 255, 200)
		self.circle = circle

		local progressBar = ProgressBar:new(self, 255, 0, 0, 0, 255, 0, 30, 6)
		self.progressBar = progressBar
		progressBar.x = -(progressBar.width / 2) + 1
		progressBar.y = -26

		self.tileMap = tileMap
		self.startRow = startRow
		self.startCol = startCol
		local tile = self.tileMap:getTileView(startRow, startCol)
		self.x = tile.x
		self.y = tile.y
		self:nextPath()

		physics.addBody(self, "dynamic", {density = 0.8, friction = 0.8, bounce = 0.2, isSensor = true, radius=15})
	
		self:addEventListener("collision", self)

		local HITPOINTS = 30
		self.healthPoints = HealthPoints:new(HITPOINTS, HITPOINTS)
		self.healthPoints:addEventListener("onHealthChanged", self)
	end

	function bad:onHealthChanged(event)
		self.progressBar:setProgress(self.healthPoints.health, self.healthPoints.maxHealth)
		if self.healthPoints.health == 0 then
			self:destroy()
		end
	end

	function bad:destroy()

		if self.destroyed == true then return true end

		self.destroyed = true
		self.isVisible = true
		self.circle.isVisible = false
		self.progressBar.isVisible = false

		self.healthPoints:removeEventListener("onHealthChanged", self)
		gameLoop:removeLoop(self)
		self.target = nil

		self:dispatchEvent({name="onDestroyed", target=self})
		
		local t = function()
			local removed = physics.removeBody(bad)
			if removed == true then
				self:removeSelf()
			else
				timer.performWithDelay(500, t)
			end
		end
		timer.performWithDelay(500, t)
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

	function bad:collision(event)
		if event.other.classType == "Bullet" and event.phase == "began" and event.other.destroyed == false then
			event.other:destroy()
			self.healthPoints:reduceHealth(1)
		end
	end

	return bad
end

return BadGuy