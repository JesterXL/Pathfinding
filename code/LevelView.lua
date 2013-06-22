

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



local BulletTower = require "BulletTower"
local makeTower = function(row, col)
	local tower = BulletTower:new(mainGroup)
	tower:init(map, row, col)
	-- tower:setTarget(bad)
end
-- makeTower(3, 3)
makeTower(4, 4)
makeTower(5, 5)
makeTower(6, 6)

local BadGuy = require "BadGuy"
local bad = BadGuy:new(mainGroup)
bad:init(map, 1, 1)

-- function mainGroup:touch(event)
-- 	local phase = event.phase
-- 	if phase == "began" then
-- 		stage:setFocus(self)
-- 		self.isFocus = true
-- 		self.x0 = event.x - self.x
-- 		self.y0 = event.y - self.y
-- 	elseif self.isFocus == true then
-- 		if phase == "moved" then
-- 			self.x = event.x - self.x0
-- 			self.y = event.y - self.y0
-- 		elseif phase == "ended" or phase == "cancelled" then
-- 			stage:setFocus(nil)
-- 			self.isFocus = false
-- 		end
-- 	end
-- 	return true
-- end

-------
local function calculateDelta( previousTouches, event )
        local id,touch = next( previousTouches )
        if event.id == id then
                id,touch = next( previousTouches, id )
                assert( id ~= event.id )
        end
 
        local dx = touch.x - event.x
        local dy = touch.y - event.y
        return dx, dy
end
 
-- create a table listener object for the bkgd image
function mainGroup:touch( event )
	print(event.id)
        local result = true
 
        local phase = event.phase
 
        local previousTouches = self.previousTouches
 
        local numTotalTouches = 1
        if ( previousTouches ) then
                -- add in total from previousTouches, subtract one if event is already in the array
                numTotalTouches = numTotalTouches + self.numPreviousTouches
                if previousTouches[event.id] then
                        numTotalTouches = numTotalTouches - 1
                end
        end
 
        if "began" == phase then
                -- Very first "began" event
                if ( not self.isFocus ) then
                        -- Subsequent touch events will target button even if they are outside the stageBounds of button
                        display.getCurrentStage():setFocus( self )
                        self.isFocus = true
 
                        previousTouches = {}
                        self.previousTouches = previousTouches
                        self.numPreviousTouches = 0
                elseif ( not self.distance ) then
                        local dx,dy
 
                        if previousTouches and ( numTotalTouches ) >= 2 then
                                dx,dy = calculateDelta( previousTouches, event )
                        end
 
                        -- initialize to distance between two touches
                        if ( dx and dy ) then
                                local d = math.sqrt( dx*dx + dy*dy )
                                if ( d > 0 ) then
                                        self.distance = d
                                        self.xScaleOriginal = self.xScale
                                        self.yScaleOriginal = self.yScale
                                        print( "distance = " .. self.distance )
                                end
                        end
                end
 
                if not previousTouches[event.id] then
                        self.numPreviousTouches = self.numPreviousTouches + 1
                end
                previousTouches[event.id] = event
 
        elseif self.isFocus then
                if "moved" == phase then
                        if ( self.distance ) then
                                local dx,dy
                                if previousTouches and ( numTotalTouches ) >= 2 then
                                        dx,dy = calculateDelta( previousTouches, event )
                                end
        
                                if ( dx and dy ) then
                                        local newDistance = math.sqrt( dx*dx + dy*dy )
                                        local scale = newDistance / self.distance
                                        print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
                                        if ( scale > 0 ) then
                                                self.xScale = self.xScaleOriginal * scale
                                                self.yScale = self.yScaleOriginal * scale
                                        end
                                end
                        end
 
                        if not previousTouches[event.id] then
                                self.numPreviousTouches = self.numPreviousTouches + 1
                        end
                        previousTouches[event.id] = event
 
                elseif "ended" == phase or "cancelled" == phase then
                        if previousTouches[event.id] then
                                self.numPreviousTouches = self.numPreviousTouches - 1
                                previousTouches[event.id] = nil
                        end
 
                        if ( #previousTouches > 0 ) then
                                -- must be at least 2 touches remaining to pinch/zoom
                                self.distance = nil
                        else
                                -- previousTouches is empty so no more fingers are touching the screen
                                -- Allow touch events to be sent normally to the objects they "hit"
                                display.getCurrentStage():setFocus( nil )
 
                                self.isFocus = false
                                self.distance = nil
                                self.xScaleOriginal = nil
                                self.yScaleOriginal = nil
 
                                -- reset array
                                self.previousTouches = nil
                                self.numPreviousTouches = nil
                        end
                end
        end
 
        return result
end

mainGroup:addEventListener("touch", mainGroup)