local GameState = require 'game.state.game_state'
local Player = require 'game.world.character.player'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Level = {}
Level.__index = Level

setmetatable(Level, { __index = GameState })

function Level.create(id)
    local self = GameState.create()
    setmetatable(self, Level)
    self.player = Player.create()
    return self
end

function Level:load()
    self.player:load()
end

function Level:update(dt)
    self.player:update(dt)
end

function Level:draw()
    self.player:draw()
end

return Level
