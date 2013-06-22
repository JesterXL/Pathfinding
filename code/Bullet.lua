local Bullet = {}

function Bullet:new(parentGroup)
	local bullet = display.newCircle(0, 0, 3)
	bullet.classType = "Bullet"
	bullet.destroyed = false

	if parentGroup then
		parentGroup:insert(bullet)
	end

	bullet.speed = 0.4

	function bullet:init(startX, startY, targetPoint)
		gameLoop:addLoop(self)
		self.x = startX
		self.y = startY
		self.targetPoint = targetPoint
		self.rot = math.atan2(self.y -  targetPoint.y,  self.x - targetPoint.x) / math.pi * 180 -90;
		self.angle = (bullet.rot -90) * math.pi / 180;

		physics.addBody(self, "dynamic", {density = 2, friction = 0.3, bounce = 0.4, isSensor = true, radius=3})
	end
	
	function bullet:tick(millisecondsPassed)
		self.x = self.x + math.cos(self.angle) * self.speed * millisecondsPassed
	   	self.y = self.y + math.sin(self.angle) * self.speed * millisecondsPassed
	end
	
	function bullet:destroy(phase)
		if self.destroyed == true then
			-- error("we're already dead")
			return true
		end

		self.destroyed = true

		gameLoop:removeLoop(self)
		self.isVisible = false
		-- self.x = -9999
		-- self.y = -9999
		local t = function()
			local result = physics.removeBody(bullet)
			if result == true then
				bullet:removeSelf()
			else
				timer.performWithDelay(100, t)
			end
		end
		timer.performWithDelay(500, t)
	end

	return bullet
end

return Bullet