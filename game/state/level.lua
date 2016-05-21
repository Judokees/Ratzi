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
    self.fans = {}
    self.map = Map.create(self.world)
    self.id = id
    return self
end

function Level:load()
    self.map:load('res/map/' .. self.id .. '.lua')
    self.player:load(self.world)
    local spawn = self.map:getSpawn()
    --self.player:move(spawn.x, spawn.y)
    local bounds = self.map:getBounds()
    for i=1,500 do
        local npcNumber = math.floor(math.random(14))
        local fan = Fan.create(self.world, self.player, npcNumber)
        fan:load()
        fan:move(math.floor(love.math.random() * (bounds.width - fan.width)), math.floor(love.math.random() * (bounds.height - fan.height)))
        table.insert(self.fans, fan)
    end
end

function Level:pulse()
    -- need to show the pulse. Don't reset the value until the pulse has been drawn.
    -- get player position
    -- tell each fan in certain radius of player to step back from player
    if self.player.pulse then
        for _, fan in ipairs(self.fans) do
            if fan:isWithinDistanceFromPlayer(self.player.pulseRadius) then
                fan:beingPulsed()
            end
        end
        self.player.pulse = false

    end
end

function Level:update(dt)
    self.map:update(dt)
    self.player:update(dt)
    self:pulse()
    for _, fan in ipairs(self.fans) do
        fan:update(dt)
    end
    Camera:focus({ x = self.player.x, y = self.player.y }, self.map:getBounds())
    Util:stackDebug(self.player:getDebug())
end

function Level:draw()
    Camera:set()
    self.map:draw(Camera.x, Camera.y, windowWidth, windowHeight)
    self.player:draw()
    for _, fan in ipairs(self.fans) do
        fan:draw()
    end
    Camera:unset()
end

return Level
