local GameState = require 'game.state.game_state'

local ww, wh = love.graphics.getDimensions()

local Splash = {}
Splash.__index = Splash

setmetatable(Splash, { __index = GameState })

function Splash.create()
    local self = GameState.create()
    setmetatable(self, Splash)
    self.startTime = nil
    self.done = false
    return self
end

function Splash:load()
    self.startTime = love.timer.getTime()
    self.image = love.graphics.newImage('res/images/Title_screen.png')
    self.imgWidth, self.imgHeight = self.image:getDimensions()
end

function Splash:update(dt)
    if love.timer.getTime() - self.startTime > 2 and not self.done then
        love.event.push('nextstate')
        self.done = true
    end
end

function Splash:draw()
    love.graphics.setBackgroundColor(55, 196, 202)
    love.graphics.draw(self.image, ww / 2 - self.imgWidth / 2, wh / 2 - self.imgHeight / 2)
end

return Splash
