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
    return self
end

function Map:getSpawn()
    return self.spawn
end

function Map:load(path)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
    local toRemove = {}
    for i, layer in pairs(self.map.layers) do
        -- select the `objects` layer
        if layer.properties and layer.properties.id == 'objects' then
            for _, object in ipairs(layer.objects) do
                if object.properties and object.properties.type == 'spawn' then
                    self.spawn = { x = object.x, y = object.y }
                end
            end
        end
        if layer.properties and (layer.properties.id == 'objects' or layer.properties.collidable == 'true') then
            self.map:removeLayer(i)
        end
    end
end

function Map:update(dt)

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
