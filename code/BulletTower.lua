local BulletTower = {}
local Bullet = require "Bullet"

function BulletTower:new()
	local tower = display.newGroup()
	tower.target = nil
	tower.fireTime = nil
	tower.MAX_FIRE_TIME = 200 + math.floor((math.random() * 50))

	function tower:init(tileMap, startRow, startCol)
		gameLoop:addLoop(self)

		self.tileMap = tileMap
		self.startRow = startRow
		self.startCol = startCol

		local bg = display.newCircle(self, 0, 0, 7)
		bg:setFillColor(100, 100, 100, 200)

		local stick = display.newLine(self, 0, 0, 16, 0)
		stick.strokeWidth = 2

		local tile = self.tileMap:getTileView(startRow, startCol)
		self.x = tile.x + self.tileMap.tileWidth / 2 - 3
		self.y = tile.y + self.tileMap.tileHeight / 2 - 3

	end

	function tower:tick(milliseconds)
		local target = self.target
		if target == nil then return true end

		-- local targetX, targetY = self:localToContent(target.x, target.y)
		-- -- targetX, targetY = self:contentToLocal(targetX, targetY)
		-- -- local targetX = target.x
		-- -- local targetY = target.y
		-- local rot = math.atan2(self.y - targetY, self.x - targetX) / math.pi * 180
		-- self.rotation = rot

		local rot = math.atan2(self.y -  target.y,  self.x - target.x) / math.pi * 180 -90;
		local angle = (rot -90) * math.pi / 180;
		local angle2 = math.rad(rot)

		if self.fireTime == nil then self.fireTime = 0 end
		self.fireTime = self.fireTime + milliseconds
		if self.fireTime >= self.MAX_FIRE_TIME then
			self.fireTime = 0
			local bullet = Bullet:new()
			bullet:init(self.x, self.y, self.target)
		end
	end

	function tower:setTarget(target)
		if self.target then
			self.target:removeEventListener("onDestroyed", self)
			self.target = nil
		end

		self.target = target
		if target then
			target:addEventListener("onDestroyed", self)
		end
	end

	function tower:onDestroyed()
		self.target = nil
	end

	return tower
end

return BulletTower