local STI = require 'libs.STI'

local Map = {}

local width, height = love.graphics.getDimensions()

Map.__index = Map

function Map.create(world)
    local self = setmetatable({}, Map)
    self.map = nil
    self.world = world
    return self
end

function Map:load(path)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
end

function Map:update(dt)

end

function Map:draw()
    -- Draw Range culls unnecessary tiles
    self.map:setDrawRange(0, 0, width, height)

    -- Draw the map and all objects within
    self.map:draw()

    -- Draw Collision Map (useful for debugging)
    self.map:bump_draw(self.world)
end


return Map
