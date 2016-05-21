local Character = require 'game.world.character.character'

local RIGHT_KEY = 'right'
local LEFT_KEY = 'left'
local UP_KEY = 'up'
local DOWN_KEY = 'down'

local Player = {}
Player.__index = Player

setmetatable(Player, { __index = Character })

function Player.create()
    local self = Character.create()
    setmetatable(self, Player)
    return self
end

function Player:load()

end

function Player:update(dt)
    if love.keyboard.isDown(RIGHT_KEY) then
        self:moveRight()
    elseif love.keyboard.isDown(LEFT_KEY) then
        self:moveLeft()
    else
        self:stopLeftRight()
    end
    if love.keyboard.isDown(DOWN_KEY) then
        self:moveDown()
    elseif love.keyboard.isDown(UP_KEY) then
        self:moveUp()
    else
        self:stopUpDown()
    end

    math.min(400, math.max(self.vx, -400))
    math.min(400, math.max(self.vy, -400))

    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end

function Player:draw()
    love.graphics.print('vx: ' .. self.vx .. ', vy: ' .. self.vy, 10, 10)
    love.graphics.circle('fill', self.x, self.y, 10)
end

return Player
