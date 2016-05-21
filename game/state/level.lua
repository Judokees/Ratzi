local bump = require 'libs.bump.bump'
local GameState = require 'game.state.game_state'
local Player = require 'game.world.character.player'
local Fan = require 'game.world.character.fan'
local Map = require 'game.world.map'
local Camera = require 'game.camera'
local NewsPaper = require 'game.world.notification.newspaper'
local Util = require 'util'

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
    self.news = NewsPaper.create('Super rich guy buys toilet paper')
    self.id = id
    return self
end

function Level:load()
    self.map:load('res/map/' .. self.id .. '.lua')
    self.player:load(self.world)
    self.fan:load()
    self.news:load()
    self.news:show()
end

function Level:update(dt)
    self.map:update(dt)
    self.player:update(dt)
    self.fan:update(dt)
    self.news:update(dt)
    Camera:focus({ x = self.player.x, y = self.player.y }, self.map:getBounds())
    Util:stackDebug(self.player:getDebug())
end

function Level:draw()
    Camera:set()
    self.map:draw(Camera.x, Camera.y, windowWidth, windowHeight)
    self.player:draw()
    self.fan:draw()
    Camera:unset()
    self.news:draw()
end

return Level
