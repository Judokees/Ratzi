local Character = require 'game.world.character.character'
local Util = require 'util'

local AnnoyingBastard = {}
AnnoyingBastard.__index = AnnoyingBastard

setmetatable(AnnoyingBastard, { __index = Character })

function AnnoyingBastard.create(world, player, x, y, npcNumber)
    local self = Character.create(world, x, y)
    setmetatable(self, AnnoyingBastard)
    self.type = 'AnnoyingBastard'
    self.player = player
    self.maxSpeed = 300
    self.minSpeed = 10
    self.radius = 800
    self.pulseSpeed = 500
    self.pulsed = false
    self.walkUpdateTime = math.random(1.5, 3)
    self.randomXSpeed = math.random(50, 100)
    self.randomYSpeed = math.random(50, 100)
    self._walkdt = 0
    return self
end

function AnnoyingBastard:load()
    Character.load(self)
end

function AnnoyingBastard:update(dt)
    if self.pulsed then
        self.vx, self.vy = self:beingPulsed()
        self.vx = -self.vx
        self.vy = -self.vy
        self.pulsed = false
    elseif self:isWithinDistanceFromPlayer(self.radius) then
        self.vx, self.vy = self:_calculateVelocity()
    else
        self.vx, self.vy = self:_randomWalk(dt)
    end
    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
    Character.update(self, dt)
end

function AnnoyingBastard:draw()
    Character.draw(self)
    if Util:isDebug() then
        love.graphics.print("vx " .. math.floor(self.vx) .. " vy " .. math.floor(self.vy), self.x, self.y)
    end
end

function AnnoyingBastard:beingPulsed()
    self.pulsed = true
    local x, y = self:_getXYFromSpeedAndRatio(self.pulseSpeed, self:_getXYRatio())
    return x, y
end

function AnnoyingBastard:isWithinDistanceFromPlayer(distance)
    return self:_distanceSquaredFromPlayer() <= distance * distance
end

------------------ MATHS ----------------------

function AnnoyingBastard:_calculateSpeed()
    -- This determines the magnitude of the velocity of the AnnoyingBastard.
    -- This is the function we should change to make the AnnoyingBastard behave differently.
    local distanceSquared = self:_distanceSquaredFromPlayer()
    if distanceSquared < self.radius * self.radius then
        local gradient = (self.minSpeed - self.maxSpeed) / self.radius
        return self.maxSpeed + gradient * math.sqrt(distanceSquared)
    end
    return 0
end

function AnnoyingBastard:_distanceVectorFromPlayer()
    local x = self.x - self.player.x
    local y = self.y - self.player.y
    return x, y
end

function AnnoyingBastard:_distanceSquaredFromPlayer()
    local x, y = self:_distanceVectorFromPlayer()
    -- square roots are expensive. Make the function dependant on the distance squared.
    return x * x + y * y
end

function AnnoyingBastard:_getXYRatio()
    local x, y = self:_distanceVectorFromPlayer()
    return y/x
end

function AnnoyingBastard:_getXYFromSpeedAndRatio(speed, ratio)
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

function AnnoyingBastard:_calculateVelocity()
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

function AnnoyingBastard:_randomWalk(dt)
    local directionX = self:_oneOrMinusOne()
    local directionY = self:_oneOrMinusOne()
    local vx = self.vx
    local vy = self.vy
    if self._walkdt > self.walkUpdateTime then
        self._walkdt = 0
        vx, vy = directionX * self.randomXSpeed, directionY * self.randomYSpeed
    else
        self._walkdt = self._walkdt + dt
    end
    return vx, vy
end

function AnnoyingBastard:_oneOrMinusOne()
    local number = math.random(-1, 1)
    if number < 0 then
        return -1
    else
        return 1
    end
end

return AnnoyingBastard
