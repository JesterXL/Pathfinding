local TileView = {}

function TileView:new(tile, parentGroup, tileWidth, tileHeight)
	local view = display.newRect(parentGroup, 0, 0, tileWidth, tileHeight)
	view.tile = tile
	
	function view:init()
		local tile = self.tile
		self:setReferencePoint(display.TopLeftReferencePoint)
		self.strokeWidth = 1
		self:setStrokeColor(255, 0, 0)
		self:updateColor()

		tile:addEventListener("isObstacleChanged", self)
		-- self:addEventListener("touch", self)
	end

	function view:updateColor()
		local tile = self.tile
		if tile.isObstacle == true then
			self:setFillColor(255, 0, 0)
		else
			self:setFillColor(0, 255, 0)
		end
	end

	function view:touch(event)
		if event.phase == "ended" then
			local tile = self.tile
			print("tile:", tile)
			local obstacle = tile.isObstacle
			if obstacle == true then
				tile:setIsObstacle(false)
			else
				tile:setIsObstacle(true)
			end
		end
		return true
	end

	function view:isObstacleChanged(event)
		print("isObstacleChanged")
		self:updateColor()
	end

	view:init()

	return view
end

return TileView