local Tile = {}
local EventDispatcher = require "EventDispatcher"

function Tile:new(isObstacle)

	local tile = {}
	tile.isObstacle = isObstacle

	function tile:setIsObstacle(value)
		print("Tile::setIsObstacle, value:", value)
		if self.isObstacle ~= value then
			self.isObstacle = value
			self:dispatchEvent({name="isObstacleChanged", target=self})
		end
	end

	EventDispatcher:initialize(tile)

	return tile

end

return Tile