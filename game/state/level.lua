local bump = require 'libs.bump.bump'
local GameState = require 'game.state.game_state'
local Player = require 'game.world.character.player'
local Map = require 'game.world.map'
local Camera = require 'game.camera'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Level = {}
Level.__index = Level

setmetatable(Level, { __index = GameState })

function Level.create(id)
    local self = GameState.create()
    setmetatable(self, Level)
    self.world = bump.newWorld()
    self.player = Player.create(self.world)
    self.map = Map.create(self.world)
    self.id = id
    return self
end

function Level:load()
    self.map:load('res/map/' .. self.id .. '.lua')
    self.player:load(self.world)
end

function Level:update(dt)
    self.map:update(dt)
    self.player:update(dt)
    Camera:focus({ x = self.player.x, y = self.player.y }, self.map:getBounds())
end

function Level:draw()
    Camera:set()
    self.map:draw(Camera.x, Camera.y, windowWidth, windowHeight)
    self.player:draw()
    Camera:unset()
end

return Level
