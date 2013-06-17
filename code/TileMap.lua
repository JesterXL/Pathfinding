local TileMap = {}
local TileView = require "TileView"

function TileMap:new(grid)
	local map = display.newGroup()
	map.grid = grid

	function map:init()
		local grid = self.grid
		local ROWS = grid.rows
		local COLS = grid.cols
		local r, c
		local startX = 0
		local startY = 0
		for r=1,ROWS do
			local tileView
			for c=1,COLS do
				local tile = grid:getTile(r, c)
				tileView = self:getTileView(tile)
				tileView.x = startX
				tileView.y = startY
				startX = startX + tileView.width
			end
			startX = 0
			startY = startY + tileView.height
		end
	end

	function map:getTileView(tile)
		-- local rect = display.newRect(self, 0, 0, 32, 32)
		-- rect:setReferencePoint(display.TopLeftReferencePoint)
		-- rect.strokeWidth = 1
		-- rect:setStrokeColor(255, 0, 0)
		-- if tile.isObstacle == true then
		-- 	rect:setFillColor(0, 0, 255)
		-- else
		-- 	rect:setFillColor(0, 255, 0)
		-- end
		-- return rect
		local rect = TileView:new(tile, self, 32, 32)
		return rect
	end

	map:init()

	return map
end

return TileMap 