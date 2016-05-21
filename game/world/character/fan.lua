local Character = require 'game.world.character.character'

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
    love.graphics.print('vx: ' .. self.vx .. ', vy: ' .. self.vy, 105, 105)
    love.graphics.print('x: ' .. self.x .. ', y: ' .. self.y, 105, 125)
    love.graphics.circle('fill', self.x + 5, self.y + 5, 5)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

return Fan