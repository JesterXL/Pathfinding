local Bullet = {}

function Bullet:new(parentGroup)
	local bullet = display.newCircle(0, 0, 3)
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
	end
	
	function bullet:tick(millisecondsPassed)
		self.x = self.x + math.cos(self.angle) * self.speed * millisecondsPassed
	   	self.y = self.y + math.sin(self.angle) * self.speed * millisecondsPassed
	end
	
	return bullet
end

return Bullet