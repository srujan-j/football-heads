player = Class{}

local playerFrames = {}
local desiredDelayBetweenFrameChanges = 0.1
local timePassedSinceLastFrameChange = 0
local currentFrame = 1
local totalNumberOfFrames = 5
local frameWidth = 61
local frameHeight = 56

WALKING_SPEED = 500
JUMP_VELOCITY = 400
GRAVITY = 7.5

VIRTUAL_WIDTH = 1152
VIRTUAL_HEIGHT = 648

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function player:init()

    runninganim = love.graphics.newImage("runs.PNG")
	for frame = 1,totalNumberOfFrames do
		playerFrames[frame] = love.graphics.newQuad((frame-1) * frameWidth, 0, frameWidth, frameHeight, runninganim:getDimensions())
    end

    self.texture = love.graphics.newImage("runs.PNG")
    self.x = WINDOW_WIDTH / 2.5
    self.y = WINDOW_HEIGHT / 1.55
    self.dx = 0
    self.dy = 0
    self.width = 61
    self.height = 56
    self.state = 'idle'

    self.behaviors = {

        ['idle'] = function(dt)
            
            -- add spacebar functionality to trigger jump state
            if love.keyboard.isDown('w') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                
                
            elseif love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
                self.state = 'walking'
                
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
                self.state = 'walking'
                
            else
                self.dx = 0
            end
        end,
        ['walking'] = function(dt)
            
            -- keep track of input to switch movement while walking, or reset
            -- to idle if we're not moving
            if love.keyboard.isDown('w') then
                self.state = 'jumping'
                self.dy = -JUMP_VELOCITY
                
                
            elseif love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
                timePassedSinceLastFrameChange = timePassedSinceLastFrameChange + dt
                if timePassedSinceLastFrameChange > desiredDelayBetweenFrameChanges then
                    timePassedSinceLastFrameChange = timePassedSinceLastFrameChange - desiredDelayBetweenFrameChanges
                    -- Move on to next frame. Move back to frame 1 if totalNumberOfFrames exceeded.
                    currentFrame = currentFrame % totalNumberOfFrames + 1
                end
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
                timePassedSinceLastFrameChange = timePassedSinceLastFrameChange + dt
                if timePassedSinceLastFrameChange > desiredDelayBetweenFrameChanges then
                    timePassedSinceLastFrameChange = timePassedSinceLastFrameChange - desiredDelayBetweenFrameChanges
                    -- Move on to next frame. Move back to frame 1 if totalNumberOfFrames exceeded.
                    currentFrame = currentFrame % totalNumberOfFrames + 1
                end
            else
                self.dx = 0
                self.state = 'idle'
            end
        end,
        ['jumping'] = function(dt)

            -- apply map's gravity before y velocity
            self.dy = self.dy + GRAVITY

            if love.keyboard.isDown('a') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('d') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
            end



            -- check if there's a tile directly beneath us
            if self.y >= WINDOW_HEIGHT / 1.55 then
                -- if so, reset velocity and position and change state
                self.dy = 0
                self.state = 'idle'
                self.y = WINDOW_HEIGHT / 1.55
            end
        end
    }
end

function player:update(dt)
    self.behaviors[self.state](dt)

    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

function player:render()
    love.graphics.draw(runninganim, playerFrames[currentFrame], self.x, self.y, 0, 2)
end

