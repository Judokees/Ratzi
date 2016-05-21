local Character = {}

Character.__index = Character

function Character.create(world, x, y)
    local self = setmetatable({}, Character)
    self.x = x
    self.y = y
    self.vx = 0
    self.vy = 0
    self.accel = 20
    self.decel = 23
    self.world = world
    self.width = 10
    self.height = 10
    self.world:add(self, self.x, self.y, self.width, self.height)
    return self
end

function Character:update(dt)

end

function Character:draw()
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function Character:moveRight()
    self.vx = self.vx + self.accel
end

function Character:moveLeft()
    self.vx = self.vx - self.accel
end

function Character:moveRight()
    self.vx = self.vx + self.accel
end

function Character:moveUp()
    self.vy = self.vy - self.accel
end

function Character:moveDown()
    self.vy = self.vy + self.accel
end

function Character:stopLeftRight()
    if self.vx < 0 then
        self.vx = math.min(0, self.vx + self.decel)

    elseif self.vx > 0 then
        self.vx = math.max(0, self.vx - self.decel)
    end
end

function Character:stopUpDown()
    if self.vy < 0 then
        self.vy = math.min(0, self.vy + self.decel)
    elseif self.vy > 0 then
        self.vy = math.max(0, self.vy - self.decel)
    end
end

function Character:isMovingUpOrDown()
    return self.vy ~= 0
end

function Character:isMovingLeftOrRight()
    return self.vx ~= 0
end

function Character:isMovingUp()
    return self.vy < 0
end

function Character:isMovingDown()
    return self.vy > 0
end

function Character:isMovingLeft()
    return self.vx < 0
end

function Character:isMovingRight()
    return self.vx > 0
end

function Character:move(x, y)
    local ax, ay, cols, len = self.world:check(self, x, y)

    self.x = ax
    self.y = ay

    self.world:update(self, self.x, self.y)
end

return Character
