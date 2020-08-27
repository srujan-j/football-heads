Class = require 'class'
push = require 'push'

require 'player'

WALKING_SPEED = 500
JUMP_VELOCITY = 400
GRAVITY = 7.5

VIRTUAL_WIDTH = 1152
VIRTUAL_HEIGHT = 648

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()

    -- sets up a different, better-looking retro font as our default
    --love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('Football Heads')
    

    backgroundImage = love.graphics.newImage('background.PNG')
    goal2Image = love.graphics.newImage('goal.PNG')
    goal1Image = love.graphics.newImage('goal1.PNG')
    
    --player1 = player(WINDOW_WIDTH / 2.5, WINDOW_HEIGHT / 1.55)

end

function love.draw() 
    -- begin virtual resolution drawing
    push:apply('start')

    love.graphics.draw(backgroundImage, 0, 0)
    --love.graphics.draw(player.texture, player.frames, player.x, player.y, 0, 5) 
    love.graphics.draw(goal1Image, 0, 410)
    love.graphics.draw(goal2Image, 1040, 410)
    player:render()

    -- end virtual resolution
    push:apply('end')
end

function love.update(dt)
    player:update(dt)
end    

function love.resize(w, h)
    push:resize(w, h)
end