local Util = require 'util'
local ProgressBar = require 'game.ui.progressbar'

local windowWidth, windowHeight = love.graphics.getDimensions()

local UI = {}

function UI:load()
    self.staminaBar = ProgressBar.create(0, 1, {
        padding = 5,
        backColor = {0, 0, 0},
        fillColor = {155, 155, 155},
        width = 300,
        height = 40
    })
    self.notification = nil
    self.arrowImage = love.graphics.newImage("media/compass-arrow.png")
    self.compassImage = love.graphics.newImage("media/compass.png")
end

function UI:update(dt, info)
    self.staminaBar:setValue(info.reputation)
    self.destX = info.destX
    self.destY = info.destY
    self.playerX = info.playerX
    self.playerY = info.playerY

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
    love.graphics.push()
    love.graphics.translate(windowWidth - 60, 60)
    self:drawArrow(self.destX, self.destY)
    love.graphics.pop()
    if self.notification then
        self.notification:draw()
    end
end

function UI:drawArrow(destx, desty)
    local arrowWidth, arrowHeight = self.arrowImage:getDimensions()
    local xOffset = arrowWidth / 2
    local yOffset = arrowHeight / 2
    local angle = math.atan2(desty - self.playerY, destx - self.playerX) + math.pi /2
    love.graphics.draw(self.compassImage, 0, 0, angle, 1, 1, xOffset, yOffset)
    love.graphics.draw(self.arrowImage, 0, 0, angle, 1, 1, xOffset, yOffset)
end

return UI
