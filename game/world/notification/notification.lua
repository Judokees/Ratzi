local Util = require 'util'
local easing = require('libs.easing.lib.easing')
local bounce = easing.outElastic

local width, height = love.graphics.getDimensions()

local Notification = {}

Notification.__index = Notification

function Notification.create(world, x, y)
    local self = setmetatable({}, Notification)
    self.visible = false
    self.y = height
    self.x = width
    self.STATE_RISING = 1
    self.STATE_OPEN = 2
    return self
end

function Notification:show()
    self.state = self.STATE_RISING
    self.start = love.timer:getTime()
    self.elapsed = 0
end

function Notification:load()
    self.x = width - self.width - 50
    self.targetY = height - self.height + 20
end


function Notification:update(dt)
    if self.state == self.STATE_RISING then
        self.elapsed = self.elapsed + dt
        self.y = bounce(self.elapsed, height, self.targetY - height, 1, 20)
        if self.elapsed > 1 then
            self.state = self.STATE_OPEN
            self.elapsed = 0
        end
    end
end

function Notification:shouldDraw()
    return self.state == self.STATE_RISING or self.state == self.STATE_OPEN
end

function Notification:draw()

end

return Notification
