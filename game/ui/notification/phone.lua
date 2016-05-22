local Notification = require 'game.ui.notification.notification'
local SoundManager = require 'game.sound_manager'
local Util = require 'util'

local Phone = {}
Phone.__index = Phone

setmetatable(Phone, { __index = Notification })

function Phone.create(opts)
    local self = Notification.create()
    setmetatable(self, Phone)
    self.path = 'res/images/notifications/' .. opts.image .. '.png'
    return self
end

function Phone:load()
    self.image = love.graphics.newImage(self.path)
    local width, height = self.image:getDimensions()
    self.scale = 400 / width
    self.width = width * self.scale
    self.height = height * self.scale
    Notification.load(self)
end

function Phone:show()
    Notification.show(self)
    SoundManager:get('vibration'):play()
end

function Phone:update(dt)
    Notification.update(self, dt)
end

function Phone:draw()
    Notification.draw(self)
    if self:shouldDraw() then
        love.graphics.draw(self.image, self.x, self.y)
    end
end

return Phone
