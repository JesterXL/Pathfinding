display.setStatusBar(display.HiddenStatusBar)

local ROWS = 7
local COLS = 7
local TILE_WIDTH = 32
local TILE_HEIGHT = 32

stage = display.getCurrentStage()
local Grid = require "jessewarden.pathfinding.Grid"
local Path = require "jessewarden.pathfinding.Path"
local Tile = require "Tile"
local myGrid = Grid:new(ROWS, COLS)
local someTile = myGrid:getTile(3, 3)
someTile.isObstacle = true
myGrid:setTile(3, 3, someTile)


local myPath = Path:new()
local st = system.getTimer()
local foundMoves = myPath:calculateMoves(myGrid, 1, 1, 10, 10)

st = system.getTimer()
local calculatedPath = myPath:calculatePath(foundMoves)
print(system.getTimer() - st)

local TileMap = require "TileMap"
local map = TileMap:new(myGrid)


-- animate = function(event)
-- 	-- path = CalcPath(CalcMoves(board, 1, 1, 10, 10))
-- 	for i = 1, table.getn(calculatedPath) do
-- 		local pathItem = calculatedPath[i]
-- 		local newX = pathItem.x * TILE_WIDTH
-- 		local newY = pathItem.y * TILE_HEIGHT
-- 		-- print("X: " .. newX .. "    Y: " .. newY)
-- 		local marker = display.newCircle((newX*32 - 16), (newY*32 - 16), 8)
-- 		local tile = Tile:new(stage, newX, newY, TILE_WIDTH, TILE_HEIGHT, pathItem.isObstacle)
-- 	end
-- end

-- animate()