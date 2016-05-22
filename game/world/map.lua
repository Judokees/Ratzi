local STI = require 'libs.STI'
local Util = require 'util'
local Camera = require 'game.camera'

local Map = {}

local width, height = love.graphics.getDimensions()

Map.__index = Map

function Map.create(world)
    local self = setmetatable({}, Map)
    self.map = nil
    self.world = world
    self.characterLayer = nil
    self.started = false
    return self
end

function Map:getSpawn()
    return self.spawn
end

function Map:load(path, player)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
    for i, layer in ipairs(self.map.layers) do
        if layer.name == 'Player' then
            self:addPlayer(i, player)
        end
        if layer.properties and (layer.properties.id == 'objects' or layer.properties.collidable == 'true') then
            self.map:removeLayer(layer.name)
        end
    end
end

function Map:addPlayer(index, player)
    self.characterLayer = self.map:convertToCustomLayer(index)
    self.characterLayer.characters = {}
    table.insert(self.characterLayer.characters, player)
    local map = self
    function self.characterLayer:update(dt)
        if not map.started then return end
        for _, ch in ipairs(self.characters) do
            ch:update(dt)
        end
    end
    function self.characterLayer:draw()
        for _, ch in ipairs(self.characters) do
            ch:draw()
        end
    end
end

function Map:addCharacter(character)
    table.insert(self.characterLayer.characters, character)
end

function Map:update(dt)
    self.map:update(dt)
end

function Map:draw()
    -- Draw Range culls unnecessary tiles
    self.map:setDrawRange(Camera.x, Camera.y, width, height)

    -- Draw the map and all objects within
    self.map:draw()

    if Util:isDebug() then
        -- Draw Collision Map (useful for debugging)
        self.map:bump_draw(self.world)
    end

end

function Map:getBounds()
    local firstLayer = self.map
    return {
        x = 0,
        y = 0,
        width = self.map.width * self.map.tilewidth,
        height = self.map.height * self.map.tileheight
    }
end


return Map
