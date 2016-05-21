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

    self.vx = math.min(400, math.max(self.vx, -400))
    self.vy = math.min(400, math.max(self.vy, -400))

    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
end

function Player:draw()
    Character.draw(self)
    love.graphics.print('vx: ' .. self.vx .. ', vy: ' .. self.vy, 5, 5)
    love.graphics.circle('fill', self.x + 5, self.y + 5, 5)
end

return Player
