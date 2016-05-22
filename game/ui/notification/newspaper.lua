local Notification = require 'game.ui.notification.Notification'
local FontManager = require 'game.font_manager'
local Util = require 'util'

local NewsPaper = {}
NewsPaper.__index = NewsPaper

setmetatable(NewsPaper, { __index = Notification })

function NewsPaper.create(title)
    local self = Notification.create()
    setmetatable(self, NewsPaper)
    self.title = title
    return self
end

function NewsPaper:load()
    self.image = love.graphics.newImage('res/images/notifications/newspaper.png')
    self.font = FontManager:get('headline')
    local width, height = self.image:getDimensions()
    self.scale = 400 / width
    self.width = width * self.scale
    self.height = height * self.scale
    self.textBox = {
        width = self.width - 40,
        height = 60
    }
    self.fontBox = {
        width = self.font:getWidth(self.title),
        height = self.font:getHeight()
    }
    self.fontOffset = {
        width = self.textBox.width / 2 - self.fontBox.width / 2,
        height = self.textBox.height / 2 - self.fontBox.height / 2
    }
    Notification.load(self)
end

function NewsPaper:update(dt)
    Notification.update(self, dt)
end

function NewsPaper:draw()
    Notification.draw(self)
    if self:shouldDraw() then
        love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
        love.graphics.setFont(self.font)
        love.graphics.print(self.title, self.x + 20 + self.fontOffset.width, self.y + 70 + self.fontOffset.height)
        if Util:isDebug() then
            love.graphics.rectangle('line', self.x + 20, self.y + 70, self.textBox.width, self.textBox.height)
        end
    end
end

return NewsPaper
