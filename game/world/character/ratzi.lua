local AnnoyingBastard = require 'game.world.character.annoyingBastard'
local Util = require 'util'

local Ratzi = {}
Ratzi.__index = Ratzi

setmetatable(Ratzi, { __index = AnnoyingBastard })

function Ratzi.create(world, player, x, y, npcNumber)
    local self = AnnoyingBastard.create(world, player, x, y, npcNumber)
    setmetatable(self, Ratzi)
    self.type = 'ratzi'
    self.path = "media/Ratzis/Character_Ratz-0" .. npcNumber .. "_"
    self.flashTime = 1
    self.frame = 1
    self.totalFrames = 1
    self.shouldFlash = true
    return self
end

function Ratzi:load()
    self.flashImage = love.graphics.newImage("media/Ratzis/spotlight.png")
    self.flashWidth, self.flashHeight = self.flashImage:getDimensions()
    AnnoyingBastard.load(self)
end

function Ratzi:update(dt)
    self.shouldFlash = self:checkShouldFlash()
    AnnoyingBastard.update(self, dt)
end

function Ratzi:draw()
    if Util:isDebug() then
        love.graphics.rectangle('line', self.world:getRect(self))
    end
    local image = self:getImageFromFrame()
    local xOffset = self.width / 2
    local yOffset = self.height / 2
    local x = self.x + xOffset - self.COLLISION_OFFSET
    local y = self.y + yOffset - self.COLLISION_OFFSET

    love.graphics.draw(image, x, y, self.angle, 1, 1, xOffset - 3, yOffset)

    if self.shouldFlash then
        local xOffset = self.flashWidth / 2
        local yOffset = self.flashHeight / 2
        local x = self.x + self.width / 2 - self.COLLISION_OFFSET
        local y = self.y + self.height / 2 - self.COLLISION_OFFSET
        love.graphics.draw(self.flashImage, x, y, self.angle, 1, 1, xOffset, yOffset)
    end
end

function Ratzi:checkShouldFlash(shouldFlash)
    if self:isWithinDistanceFromPlayer(200) then
        return true
    end
    return false
end

return Ratzi