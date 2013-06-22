display.setStatusBar(display.HiddenStatusBar)
require "physics"

local function setupGlobals()
	mainGroup = display.newGroup()

	local GameLoop = require "GameLoop"
	gameLoop = GameLoop:new()
	gameLoop:start()
end

local function setupPhysics()
	physics.setDrawMode("hybrid")
	-- physics.setDrawMode("normal")
	-- physics.setDrawMode("debug")
	physics.start()
	physics.setGravity(0, 0)
	-- physics.setPositionIterations( 10 )
end

setupGlobals()
setupPhysics()
require "LevelView"