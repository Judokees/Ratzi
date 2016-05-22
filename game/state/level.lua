local bump = require 'libs.bump.bump'
local GameState = require 'game.state.game_state'
local Player = require 'game.world.character.player'
local Fan = require 'game.world.character.fan'
local Ratzi = require 'game.world.character.ratzi'
local Map = require 'game.world.map'
local Camera = require 'game.camera'
local Util = require 'util'
local UI = require 'game.ui.ui'
local Marker = require 'game.world.marker'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Level = {}
Level.__index = Level

setmetatable(Level, { __index = GameState })

function Level.create(id)
    local self = GameState.create()
    setmetatable(self, Level)
    local opts = require('res.levels.' .. id)
    self.world = bump.newWorld()
    self.fans = {}
    self.ratzis = {}
    self.map = Map.create(self.world)
    self.id = id
    self.name = opts.name
    self.intro = opts.intro
    self.spawn = opts.spawn
    self.target = opts.target
    self.marker = opts.marker
    self.mapId = opts.map
    self.uiInfo = {}
    self.started = false
    self.steps = opts.steps
    self.currentStep = 1
    love.handlers.startlevel = function (a, b, c, d)
        self:start()
        UI:hideNotification()
    end
    love.handlers.collect = function (a, b, c, d)
        self:nextStep()
    end
    self.markers = {}
    return self
end

function Level:nextStep()
    self.world:remove(self.markers[self.currentStep])
    if self.currentStep + 1 > #self.steps then

        -- TODO Make it win and then move to the next state
        love.event.push('nextstate')
    else
        self.currentStep = self.currentStep + 1
    end
end

function Level:load()
    self.map:load('res/map/' .. self.mapId .. '.lua')
    self.player = Player.create(self.world, self.spawn.x, self.spawn.y)
    self.player:load()
    local bounds = self.map:getBounds()

    -- load fans
    for i=1, 300 do
        local npcNumber = math.floor(math.random(14))
        local fanPos = { x = math.floor(love.math.random() * bounds.width), y = math.floor(love.math.random() * bounds.height)}
        local fan = Fan.create(self.world, self.player, fanPos.x, fanPos.y, npcNumber)
        fan:load()
        table.insert(self.fans, fan)
    end

    -- load ratzis
    for i=1, 300 do
        local npcNumber = math.floor(math.random(8))
        local ratziPos = { x = math.floor(love.math.random() * bounds.width), y = math.floor(love.math.random() * bounds.height)}
        local ratzi = Ratzi.create(self.world, self.player, ratziPos.x, ratziPos.y, npcNumber)
        ratzi:load()
        table.insert(self.ratzis, ratzi)
    end
    for i, step in ipairs(self.steps) do
        local marker = Marker.create(step.position.x, step.position.y)
        marker:load(step.marker)
        table.insert(self.markers, marker)
        self.world:add(marker, step.position.x, step.position.y, 35, 35)
    end
    UI:load()
    UI:showNotification(self.intro)
end

function Level:start()
    self.started = true
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
        for _, ratzi in ipairs(self.ratzis) do
            if ratzi:isWithinDistanceFromPlayer(self.player.pulseRadius) then
                ratzi:beingPulsed()
            end
        end
        self.player.pulse = false

    end
end

function Level:update(dt)
    if self.started then
        self.player:update(dt)
        self:pulse()
        for _, fan in ipairs(self.fans) do
            fan:update(dt)
        end
        for _, ratzi in ipairs(self.ratzis) do
            ratzi:update(dt)
        end
        Camera:focus({ x = self.player.x, y = self.player.y }, self.map:getBounds())
        Util:stackDebug(self.player:getDebug())
    end
    self.markers[self.currentStep]:update(dt)
    self.map:update(dt)
    self.uiInfo.reputation = self.player.reputation
    UI:update(dt, self.uiInfo)
end

function Level:draw()
    Camera:set()
    self.map:draw(Camera.x, Camera.y, windowWidth, windowHeight)
    self.player:draw()
    self.markers[self.currentStep]:draw()
    for _, fan in ipairs(self.fans) do
        fan:draw()
    end
    for _, ratzi in ipairs(self.ratzis) do
        ratzi:draw()
    end
    Camera:unset()
    UI:draw()
end

function Level:keyreleased(key)
    UI:keyreleased(key)
end

return Level
