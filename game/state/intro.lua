local GameState = require 'game.state.game_state'

local ww, wh = love.graphics.getDimensions()

local Intro = {}
Intro.__index = Intro

setmetatable(Intro, { __index = GameState })

function Intro.create()
    local self = GameState.create()
    setmetatable(self, Intro)
    self.scale = 10
    self.rotation = math.rad(-720)
    return self
end

function Intro:load()
    self.image = love.graphics.newImage('res/images/intro.png')
    self.imgWidth, self.imgHeight = self.image:getDimensions()
    self.x = ww / 2 - self.imgWidth / 2
    self.y = wh - self.imgHeight + 10
end

function Intro:update(dt)
    self.rotation = math.min(0, self.rotation + math.rad(10))
    self.scale = math.max(0.8, self.scale - 9 * (10 / 720))
end

function Intro:draw()
    love.graphics.setBackgroundColor(55, 196, 202)
    love.graphics.push()
    love.graphics.translate(ww / 2, wh / 2)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.rotate(self.rotation)
    love.graphics.draw(self.image, -self.imgWidth / 2 + 30, -self.imgHeight / 2)
    love.graphics.pop()
end

function Intro:keyreleased(key)
    love.event.push('nextstate')
end

return Intro
