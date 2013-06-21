display.setStatusBar(display.HiddenStatusBar)

local GameLoop = require "GameLoop"
gameLoop = GameLoop:new()
gameLoop:start()

local ROWS = 7
local COLS = 7
local TILE_WIDTH = 32
local TILE_HEIGHT = 32

stage = display.getCurrentStage()
local Grid = require "jessewarden.pathfinding.Grid"
local Path = require "jessewarden.pathfinding.Path"
local Tile = require "Tile"
local myGrid = Grid:new(ROWS, COLS)
local setObstacle = function(row, col)
	local someTile = myGrid:getTile(row, col)
	someTile.isObstacle = true
	myGrid:setTile(row, col, someTile)
end
setObstacle(1, 2)
setObstacle(2, 2)
setObstacle(3, 3)
setObstacle(4, 4)
setObstacle(5, 5)
setObstacle(6, 6)



local myPath = Path:new()
local foundMoves = myPath:calculateMoves(myGrid, 1, 1, 10, 10)

local calculatedPath = myPath:calculatePath(foundMoves)

local TileMap = require "TileMap"
local map = TileMap:new(myGrid)

local BadGuy = require "BadGuy"
local bad = BadGuy:new()
bad:init(map, 1, 1)


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