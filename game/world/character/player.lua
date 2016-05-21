local Character = require 'game.world.character.character'

local RIGHT_KEY = 'right'
local LEFT_KEY = 'left'
local UP_KEY = 'up'
local DOWN_KEY = 'down'

local Player = {}
Player.__index = Player

setmetatable(Player, { __index = Character })

function Player.create(world)
    local self = Character.create(world)
    setmetatable(self, Player)
    return self
end

function Player:load()

end

function Player:update(dt)
    if love.keyboard.isDown(RIGHT_KEY) then
        self:moveRight()
        if self:isMovingLeft() then
            self:stopLeftRight()
        end
    elseif love.keyboard.isDown(LEFT_KEY) then
        self:moveLeft()
        if self:isMovingRight() then
            self:stopLeftRight()
        end
    else
        self:stopLeftRight()
    end

    if love.keyboard.isDown(DOWN_KEY) then
        self:moveDown()
        if self:isMovingUp() then
            self:stopUpDown()
        end
    elseif love.keyboard.isDown(UP_KEY) then
        self:moveUp()
        if self:isMovingDown() then
            self:stopUpDown()
        end
    else
        self:stopUpDown()
    end

    self.vx = math.min(400, math.max(self.vx, -400))
    self.vy = math.min(400, math.max(self.vy, -400))

    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
end

function Player:draw()
    love.graphics.print('vx: ' .. self.vx .. ', vy: ' .. self.vy, 5, 5)
    love.graphics.circle('fill', self.x + 5, self.y + 5, 5)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

return Player
