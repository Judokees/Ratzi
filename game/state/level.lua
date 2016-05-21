local bump = require 'libs.bump.bump'
local GameState = require 'game.state.game_state'
local Player = require 'game.world.character.player'
local Fan = require 'game.world.character.fan'
local Map = require 'game.world.map'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Level = {}
Level.__index = Level

setmetatable(Level, { __index = GameState })

function Level.create(id)
    local self = GameState.create()
    setmetatable(self, Level)
    self.world = bump.newWorld()
    self.player = Player.create(self.world)
    self.fan = Fan.create(self.world, self.player)
    self.map = Map.create(self.world)
    self.id = id
    return self
end

function Level:load()
    self.map:load('res/map/' .. self.id .. '.lua')
    self.player:load(self.world)
    self.fan:load()
end

function Level:update(dt)
    self.map:update(dt)
    self.player:update(dt)
    self.fan:update(dt)
end

function Level:draw()
    self.map:draw()
    self.player:draw()
    self.fan:draw()
end

return Level
