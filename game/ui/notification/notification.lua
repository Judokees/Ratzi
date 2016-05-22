local Util = require 'util'
local easing = require('libs.easing.lib.easing')
local bounceIn = easing.outElastic
local bounceOut = easing.inBack

local width, height = love.graphics.getDimensions()

local Notification = {}

Notification.__index = Notification

function Notification.create(world, x, y)
    local self = setmetatable({}, Notification)
    self.visible = false
    self.y = height
    self.x = width
    self.STATE_CLOSED = 0
    self.STATE_RISING = 1
    self.STATE_OPEN = 2
    self.STATE_FALLING = 3
    self.state = self.STATE_CLOSED
    return self
end

function Notification:show()
    self.state = self.STATE_RISING
    self.start = love.timer:getTime()
    self.elapsed = 0
end

function Notification:hide()
    self.state = self.STATE_FALLING
    self.start = love.timer:getTime()
    self.elapsed = 0
end

function Notification:load()
    self.x = width - self.width - 50
    self.targetY = height - self.height
end


function Notification:update(dt)
    if self.state == self.STATE_RISING then
        self.elapsed = self.elapsed + dt
        self.y = bounceIn(self.elapsed, height, self.targetY - height, 0.9)
        if self.elapsed > 1 then
            self.state = self.STATE_OPEN
            self.elapsed = 0
        end
    elseif self.state == self.STATE_FALLING then
        self.elapsed = self.elapsed + dt
        self.y = bounceOut(self.elapsed, self.targetY, height, 0.3)
        if self.elapsed > 1 then
            self.state = self.STATE_CLOSED
            self.elapsed = 0
        end
    end
end

function Notification:keyreleased(key)
    if self.state == self.STATE_OPEN then
        love.event.push('startlevel')
    end
end

function Notification:shouldDraw()
    return self.state == self.STATE_RISING or self.state == self.STATE_OPEN or self.state == self.STATE_FALLING
end

function Notification:draw()

end

return Notification
