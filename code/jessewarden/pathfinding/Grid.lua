-- stolen from here
-- http://mobile.tutsplus.com/tutorials/corona/corona-sdk-game-development-path-finding/
local Grid = {}
local Tile = require "Tile"
function Grid:new(rows, cols)
	local grid = {}
	grid.rows = rows
	grid.cols = cols

	function grid:init()
		local r
		local c
		local cols = self.cols
		local rows = self.rows
		for r = 1,rows do
			self[r] = {}
			for c = 1,cols do
				self[r][c] = Tile:new(0)
			end
		end
	end

	function grid:getTile(row, col)
		return self[row][col]
	end

	function grid:setTile(row, col, tile)
		self[row][col] = tile
	end

	grid:init()

	return grid
end

return Grid