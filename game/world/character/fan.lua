local Character = require 'game.world.character.character'
local Util = require 'util'

local Fan = {}
Fan.__index = Fan

setmetatable(Fan, { __index = Character })

function Fan.create(world, player)
    local self = Character.create(world, 100, 100)
    setmetatable(self, Fan)
    self.player = player
    return self
end

function Fan:load()

end

function Fan:update(dt)
    self.vx = math.min(400, math.max(self.player.vx, -400))
    self.vy = math.min(400, math.max(self.player.vy, -400))

    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
end

function Fan:draw()
    love.graphics.circle('fill', self.x + 5, self.y + 5, 5)
    if Util:isDebug() then
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
end

return Fan
