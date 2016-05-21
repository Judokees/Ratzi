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
    self.accel = 20
    self.decel = 30
    return self
end

function Player:load()

end

function Player:update(dt)
    if love.keyboard.isDown(RIGHT_KEY) then
        self.vx = self.vx + self.accel
    elseif love.keyboard.isDown(LEFT_KEY) then
        self.vx = self.vx - self.accel
    else
        if self.vx < 0 then
            self.vx = math.max(0, self.vx + self.decel)
        elseif self.vx > 0 then
            self.vx = math.min(0, self.vx - self.decel)
        end
    end
    if love.keyboard.isDown(DOWN_KEY) then
        self.vy = self.vy + self.accel
    elseif love.keyboard.isDown(UP_KEY) then
        self.vy = self.vy - self.accel
    else
        if self.vy < 0 then
            self.vy = math.max(0, self.vy + self.decel)
        elseif self.vy > 0 then
            self.vy = math.min(0, self.vy - self.decel)
        end
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
