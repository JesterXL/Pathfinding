local BulletTower = {}
local Bullet = require "Bullet"

function BulletTower:new(parentGroup)
	local tower = display.newGroup()
	if parentGroup then
		parentGroup:insert(tower)
	end
	
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

		local RADIUS = 60

		local range = display.newCircle(self, 0, 0, RADIUS)
		range:setFillColor(0, 0, 255, 90)
		range.strokeWidth = 2
		range:setStrokeColor(0, 0, 0, 180)
		self.range = range
		function range:cancelIt()
			if self.tweenID then
				transition.cancel(self.tweenID)
				self.tweenID = nil
			end
		end
		function range:fadeIn()
			range.tweenID = transition.to(range, {time = 2000, alpha = 1, onComplete=function()range:fadeOut()end})
		end
		function range:fadeOut()
			range.tweenID = transition.to(range, {time = 2000, alpha = 0, onComplete=function()range:fadeIn()end})
		end
		-- range:fadeIn()
		physics.addBody(self, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = true, radius=RADIUS})
		self:addEventListener("collision", self)
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
			local bullet = Bullet:new(parentGroup)
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

	function tower:collision(event)
		if self.target == nil then
			if event.other.classType == "BadGuy" then
				self:setTarget(event.other)
			end
		elseif event.phase == "ended" and event.other == self.target then
			self:setTarget(nil)
		end
		return true
	end

	function tower:onDestroyed()
		self.target = nil
	end

	return tower
end

return BulletTower