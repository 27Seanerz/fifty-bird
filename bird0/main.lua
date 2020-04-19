--[[ Branch: sean_real_branch
Main file for flappy bird project
April 18th
]]

-- _______________________________________________________________________ INITIALIZE __________________________________________________________________________

-- library handling
push = require 'push'
Class = require 'class'

-- my classes handling
require 'Bird'
require 'Pipe'

-- physical screen dimensions
WINDOW_WIDTH = 1422
WINDOW_HEIGHT = 800

-- virtual resolution dimensions 512 x 288
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- loading images 
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

-- counters for image scrolling
local groundScroll = 0
local backgroundScroll = 0
local BACKGROUND_SPEED = 30
local GROUND_SPEED = 60
local BACKGROUND_LOOP = 413
local GROUND_LOOP = 413

--init objects
local prevPipeY = VIRTUAL_HEIGHT/2
local pipesAlarm = 0

local bird = Bird(prevPipeY)

local first_pipe = Pipe()
local top_pipes = {}
local bottom_pipes = {}



-- _______________________________________________________________________ LOAD __________________________________________________________________________

function love.load()
    -- initialize our nearest-neighbor filter (doens't anti analyze, doesn't make blurry, good for retro)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- initialize random 
    math.randomseed(os.time())

    -- initialize pipe variable
    first_pipe.y = VIRTUAL_HEIGHT/2

    -- app window title
    love.window.setTitle('Sean\'s Flappy Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end


-- _______________________________________________________________________ MISC FUNCTIONS __________________________________________________________________________

--allows for resizing using push lib
function love.resize(w, h)
    push:resize(w, h)
end

--allows for asynchronous input capture
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then 
        return true 
    else 
        return false 
    end 
end


-- _______________________________________________________________________ UPDATE __________________________________________________________________________

function love.update(dt)
    -- scrolls ground and background
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED*dt) % BACKGROUND_LOOP
    groundScroll = (groundScroll + GROUND_SPEED*dt) % VIRTUAL_WIDTH

  

    pipesAlarm = pipesAlarm + dt
    if pipesAlarm > 2 then 
        table.insert(top_pipes, Pipe())
        table.insert(bottom_pipes, Pipe())
        pipesAlarm = 0
    end 

      -- class update functions
    bird:update(dt)

    --pipe:update for all pipe objects

    --[[ my take on top pipes
    for k, pipe in pairs(top_pipes) do
        pipe:update(dt)

        if pipe.x + pipe.width < 0 then 
            table.remove(top_pipes, k)
        end 

    end ]]

    for k, pipe in pairs(bottom_pipes) do
        pipe:update(dt)

        if pipe.x + pipe.width < 0 then 
            table.remove(bottom_pipes, k)
        end 

    end 

    -- first_pipe:update(dt)

    --clears the keys stored/checked last frame
    love.keyboard.keysPressed = {}
end



-- _______________________________________________________________________ RENDER __________________________________________________________________________
function love.draw()
    push:start() -- required in order to render using push lib
    

    -- draw ground and background 
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw pipes 
    -- my take on setting first height
    -- first_pipe:render(math.floor(first_pipe.y), 1)

    for k, pipe in pairs(bottom_pipes) do
        pipe:render(math.floor(pipe.y), 1)
    end 

    -- my take on top pipes
    --[[  for k, pipe in pairs(top_pipes) do
        pipe:render(bottom_pipes[k].y - 150, -1)
    end ]]



    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)


    bird:render() 

    -- DEBUG
    -- love.graphics.printf(tostring(backgroundScroll), VIRTUAL_WIDTH-30, 10, 100, "center") --check scroll
    -- love.graphic.printf(tostring(love.keyboard.keysPressed{0}), VIRTUAL_WIDTH-30, 10, 100, "center")

    push:finish() -- required in order to render using push lib
    
end