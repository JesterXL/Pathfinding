display.setStatusBar(display.HiddenStatusBar)

local Grid = require "jessewarden.pathfinding.Grid"
local Path = require "jessewarden.pathfinding.Path"
local myGrid = Grid:new(100, 100)
local myPath = Path:new()
local st = system.getTimer()
local foundMoves = myPath:calculateMoves(myGrid, 1, 1, 50, 50)
print(system.getTimer() - st)
st = system.getTimer()
local calculatedPath = myPath:calculatePath(foundMoves)
print(system.getTimer() - st)


animate = function(event)
	-- path = CalcPath(CalcMoves(board, 1, 1, 10, 10))
	for i = 1, table.getn(calculatedPath) do
		local newX = calculatedPath[i].x
		local newY = calculatedPath[i].y
		print("X: " .. newX .. "    Y: " .. newY)
		local marker = display.newCircle((newX*32 - 16), (newY*32 - 16), 8)
		marker:setFillColor(255, 174, 0)
	end
end

animate()