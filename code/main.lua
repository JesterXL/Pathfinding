display.setStatusBar(display.HiddenStatusBar)

mainGroup = display.newGroup()

local GameLoop = require "GameLoop"
gameLoop = GameLoop:new()
gameLoop:start()

local ROWS = 100
local COLS = 100
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



-- local myPath = Path:new()
-- local foundMoves = myPath:calculateMoves(myGrid, 1, 1, 10, 30)

-- local calculatedPath = myPath:calculatePath(foundMoves)

local TileMap = require "TileMap"
local map = TileMap:new(mainGroup, myGrid, TILE_WIDTH, TILE_HEIGHT)

local BadGuy = require "BadGuy"
local bad = BadGuy:new(mainGroup)
bad:init(map, 1, 1)

local BulletTower = require "BulletTower"
local makeTower = function(row, col)
	local tower = BulletTower:new(mainGroup)
	tower:init(map, row, col)
	tower:setTarget(bad)
end
makeTower(3, 3)
makeTower(4, 4)
makeTower(5, 5)

function mainGroup:touch(event)
	local phase = event.phase
	if phase == "began" then
		stage:setFocus(self)
		self.isFocus = true
		self.x0 = event.x - self.x
		self.y0 = event.y - self.y
	elseif self.isFocus == true then
		if phase == "moved" then
			self.x = event.x - self.x0
			self.y = event.y - self.y0
		elseif phase == "ended" or phase == "cancelled" then
			stage:setFocus(nil)
			self.isFocus = false
		end
	end
	return true
end

mainGroup:addEventListener("touch", mainGroup)