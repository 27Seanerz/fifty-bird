--[[ Branch: sean_real_branch
Main file for flappy bird project
April 18th
]]

-- _______________________________________________________________________ INITIALIZE __________________________________________________________________________

-- virtual resolution handling library
push = require 'push'

-- physical screen dimensions
WINDOW_WIDTH = 1422
WINDOW_HEIGHT = 800

-- virtual resolution dimensions 512 x 288
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- loading images 
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')



-- _______________________________________________________________________ LOAD __________________________________________________________________________

function love.load()
    -- initialize our nearest-neighbor filter (doens't anti analyze, doesn't make blurry, good for retro)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Sean\'s Flappy Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end





-- _______________________________________________________________________ MISC FUNCTIONS __________________________________________________________________________

--allows for resizing using push lib
function love.resize(w, h)
    push:resize(w, h)
end

--allows for asynchronous input capture
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end



-- _______________________________________________________________________ RENDER __________________________________________________________________________
function love.draw()
    push:start() -- required in order to render using push lib
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, 0, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    
    push:finish() -- required in order to render using push lib
    
end