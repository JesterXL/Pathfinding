local EventDispatcher = require "utils.EventDispatcher"
local HealthPoints = {}

function HealthPoints:new(startHealth, startMaxHealth)
	local healthPoints = {}
	healthPoints.classType = "HealthPoints"
	healthPoints.health = startHealth
	healthPoints.maxHealth = startMaxHealth
	
	EventDispatcher:initialize(healthPoints)
	assert(healthPoints.removeEventListener ~= nil, "method isn't working")

	function healthPoints:setHealth(value)
		assert(value ~= nil, "value cannot be nil")
		assert(value > -1, "value cannot be less than 0")
		if self.maxHealth ~= nil then
			assert(value <= self.maxHealth, "value cannot be less than maxHealth")
		end
		local oldValue = self.health
		self.health = value
		local difference = self.health - oldValue
		self:dispatchEvent({name="onHealthChanged", target=self, difference=difference, health=health, oldValue=oldValue})
	end

	function healthPoints:setMaxHealth(value)
		assert(value ~= nil, "value cannot be nil")
		assert(value > -1, "value cannot be less than 0")
		local oldValue = self.maxHealth
		self.maxHealth = value
		local difference = self.maxHealth - oldValue
		if self.health == nil then
			self:setHealth(self.maxHealth)
		elseif self.health > self.maxHealth then
			self:setHealth(self.maxHealth)
		end
		self:dispatchEvent({name="onMaxHealthChanged", target=self, difference=difference, maxHealth=health, oldValue=oldValue})
	end

	function healthPoints:reduceHealth(amount)
		if self.health ~= nil and self.health ~= 0 then
			local currentHealth = self.health - amount
			if currentHealth >= 0 then
				self:setHealth(currentHealth)
			end
		end
	end



	return healthPoints
end

return HealthPoints