local Character = require 'game.world.character.character'
local Util = require 'util'

local Fan = {}
Fan.__index = Fan

setmetatable(Fan, { __index = Character })

function Fan.create(world, player, npcNumber)
    local self = Character.create(world, 100, 100)
    setmetatable(self, Fan)
    self.type = 'fan'
    self.player = player
    self.maxSpeed = 300
    self.minSpeed = 10
    self.radius = 800
    self.pulseSpeed = 500
    self.pulsed = false
    self.path = "media/npc" .. npcNumber .. "_"
    return self
end

function Fan:load()
    Character.load(self)
end

function Fan:update(dt)
    if self.pulsed then
        self.vx, self.vy = self:beingPulsed()
        self.vx = -self.vx
        self.vy = -self.vy
        self.pulsed = false
    else
        self.vx, self.vy = self:_calculateVelocity()
    end
    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
    Character.update(self, dt)
end

function Fan:draw()
    Character.draw(self)
    if Util:isDebug() then
        love.graphics.print("vx " .. math.floor(self.vx) .. " vy " .. math.floor(self.vy), self.x, self.y)
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
end

function Fan:beingPulsed()
    self.pulsed = true
    local x, y = self:_getXYFromSpeedAndRatio(self.pulseSpeed, self:_getXYRatio())
    return x, y
end

function Fan:isWithinDistanceFromPlayer(distance)
    return self:_distanceSquaredFromPlayer() <= distance * distance
end

------------------ MATHS ----------------------

function Fan:_calculateSpeed()
    -- This determines the magnitude of the velocity of the fan.
    -- This is the function we should change to make the fan behave differently.
    local distanceSquared = self:_distanceSquaredFromPlayer()
    if distanceSquared < self.radius * self.radius then
        local gradient = (self.minSpeed - self.maxSpeed) / self.radius
        return self.maxSpeed + gradient * math.sqrt(distanceSquared)
    end
    return 0
end

function Fan:_distanceVectorFromPlayer()
    local x = self.x - self.player.x
    local y = self.y - self.player.y
    return x, y
end

function Fan:_distanceSquaredFromPlayer()
    local x, y = self:_distanceVectorFromPlayer()
    -- square roots are expensive. Make the function dependant on the distance squared.
    return x * x + y * y
end

function Fan:_getXYRatio()
    local x, y = self:_distanceVectorFromPlayer()
    return y/x
end

function Fan:_getXYFromSpeedAndRatio(speed, ratio)
    -- This is just a maths formula
    local vxSquared = (speed * speed) / (1 + ratio * ratio)
    local vySquared = speed * speed - vxSquared

    -- Follow the player
    local xDirection = 0
    local yDirection = 0
    if self.player.x > self.x then
        xDirection = 1
    else
        xDirection = -1
    end
    if self.player.y > self.y then
        yDirection = 1
    else
        yDirection = -1
    end
    return xDirection * math.sqrt(vxSquared), yDirection * math.sqrt(vySquared)
end

function Fan:_calculateVelocity()
    local xYRatio = self:_getXYRatio()
    local speed = self:_calculateSpeed()
    -- If the X Y ratio is huge, then x is zero
    if xYRatio == math.huge then
        return 0, speed
    elseif xYRatio == 0 then
        return speed, 0
    else
        return self:_getXYFromSpeedAndRatio(speed, xYRatio)
    end
end

return Fan
