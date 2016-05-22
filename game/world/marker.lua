local Util = require 'util'
local Easing = require 'libs.easing.lib.easing'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Marker = {}

Marker.__index = Marker

local STATE_INACTIVE = 1

function Marker.create(x, y)
    local self = setmetatable({}, Marker)
    self.originalY = y
    self.x = x
    self.minY = y - 20
    self.maxY = y - 5
    self.vy = 0
    self.type = "marker"
    self.state = STATE_ACTIVE
    self.vy = 1
    self.elapsedTime = 0
    return self
end

function Marker:load(id)
    self.image = love.graphics.newImage('res/images/markers/' .. id .. '.png')
    self.width, self.height = self.image:getDimensions()
end

function Marker:update(dt)
    self.elapsedTime = self.elapsedTime + dt

    if self.vy > 0 then
        local ending = self.maxY - self.minY
        self.y = Easing.inCubic(self.elapsedTime, self.minY, ending, 0.5)
    else
        local ending = self.minY - self.maxY
        self.y = Easing.outCubic(self.elapsedTime, self.maxY, ending, 0.5)
    end
    -- Change direction
    if self.y > self.maxY or self.y < self.minY then
        self.vy = self.vy * -1
        self.elapsedTime = 0
    end
end

function Marker:draw()
    love.graphics.draw(self.image, self.x + 35 / 2 - self.width / 2, self.y - self.height)
    if Util:isDebug() then
        love.graphics.rectangle('line', self.x, self.originalY, 35, 35)
    end
end

return Marker
