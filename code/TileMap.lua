local TileMap = {}
local TileView = require "TileView"

function TileMap:new(parentGroup, grid, tileWidth, tileHeight)
	local map = display.newGroup()
	if parentGroup then
		parentGroup:insert(map)
	end
	map.grid = grid
	map.tileWidth = tileWidth
	map.tileHeight = tileHeight
	map.tileHash = {}

	function map:init()
		local grid = self.grid
		local ROWS = grid.rows
		local COLS = grid.cols
		local r, c
		local startX = 0
		local startY = 0
		local tileHash = self.tileHash
		for r=1,ROWS do
			local tileView
			for c=1,COLS do
				local tile = grid:getTile(r, c)
				
				
				tileView = self:createTileViewFromTile(tile)
				tileHash[tostring(r) .. "-" .. tostring(c)] = tileView
				self:insert(tileView)
				tileView.x = startX
				tileView.y = startY
				startX = startX + tileView.width
			end
			startX = 0
			startY = startY + tileView.height
		end
	end

	function map:createTileViewFromTile(tile)
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
		local rect = TileView:new(tile, self, self.tileWidth, self.tileHeight)
		return rect
	end

	function map:getTileView(row, col)
		return self.tileHash[tostring(row) .. "-" .. tostring(col)]
	end

	map:init()

	return map
end

return TileMap 