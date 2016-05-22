local Util = require 'util'

local windowWidth, windowHeight = love.graphics.getDimensions()

local ProgressBar = {}

ProgressBar.__index = ProgressBar

function ProgressBar.create(min, max, style)
    local self = setmetatable({}, ProgressBar)
    self.min = min
    self.max = max
    self.style = style
    self.value = min
    return self
end

function ProgressBar:setValue(value)
    self.value = math.min(self.max, math.max(self.min, value))
end

function ProgressBar:load()

end

function ProgressBar:update(dt)

end

function ProgressBar:draw()
    love.graphics.setColor(unpack(self.style.backColor))
    love.graphics.rectangle('fill', 0, 0, self.style.width, self.style.height)
    love.graphics.setColor(unpack(self.style.fillColor))
    love.graphics.rectangle('fill', self.style.padding, self.style.padding, self.value / self.max * (self.style.width - self.style.padding * 2), self.style.height - self.style.padding * 2)
end

return ProgressBar
