local Character = {}

Character.__index = Character

function Character.create()
    local self = setmetatable({}, Character)
    self.x = 0
    self.y = 0
    self.vx = 0
    self.vy = 0
    self.accel = 20
    self.decel = 23
    return self
end

function Character:draw()
    -- I want to be implemented really bad!!!
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

return Character
