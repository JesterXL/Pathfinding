display.setStatusBar(display.HiddenStatusBar)
require "physics"

local function setupGlobals()
	mainGroup = display.newGroup()

	local GameLoop = require "GameLoop"
	gameLoop = GameLoop:new()
	gameLoop:start()
end

local function setupPhysics()
	-- physics.setDrawMode("hybrid")
	physics.setDrawMode("normal")
	-- physics.setDrawMode("debug")
	physics.start()
	physics.setGravity(0, 0)
	-- physics.setPositionIterations( 10 )
end

-- local ProgressBar = require "ProgressBar"
-- local bar = ProgressBar:new(mainGroup, 255, 0, 0, 0, 255, 0, 30, 6)
-- bar.x = 30
-- bar.y = 30
-- bar:setProgress(50, 100)

setupGlobals()
setupPhysics()
require "LevelView"