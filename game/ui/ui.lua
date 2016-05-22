local Util = require 'util'
local ProgressBar = require 'game.ui.progressbar'

local windowWidth, windowHeight = love.graphics.getDimensions()

local UI = {}

function UI:load()
    self.staminaBar = ProgressBar.create(0, 1, {
        padding = 5,
        backColor = {0, 0, 0},
        fillColor = {150, 150, 150},
        width = 300,
        height = 40
    })
    self.notification = nil
end

function UI:update(dt, info)
    self.staminaBar:setValue(info.reputation)
    if self.notification then
        self.notification:update(dt)
    end
end

function UI:showNotification(opts)
    local notificationClass = require('game.ui.notification.' .. opts.notification)
    self.notification = notificationClass.create(opts)
    self.notification:load()
    self.notification:show()
end

function UI:hideNotification()
    if self.notification then
        self.notification:hide()
    end
end

function UI:keyreleased(key)
    if self.notification then
        self.notification:keyreleased(key)
    end
end

function UI:draw()
    love.graphics.push()
    love.graphics.translate(10, 10)
    self.staminaBar:draw()
    love.graphics.pop()
    if self.notification then
        self.notification:draw()
    end
end

return UI
