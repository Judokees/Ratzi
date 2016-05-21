local GameState = require 'game.state.game_state'

local windowWidth, windowHeight = love.graphics.getDimensions()

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
end

function Splash:update(dt)
    if love.timer.getTime() - self.startTime > 2 and not self.done then
        love.event.push('nextstate')
        self.done = true
    end
end

function Splash:draw()
    love.graphics.printf("Winning...", 0, windowHeight / 2, windowWidth, 'center')
end

return Splash
