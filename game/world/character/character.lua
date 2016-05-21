local Util = require 'util'
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
    self.frame = 1
    self.totalFrames = 4
    -- this is set by the classes that use character.lua
    self.path = ""
    self.images = {}
    self.updateTime = 0.1
    self._dt = 0
    return self
end

function Character:load()
    self.images = self:loadImages()
    self.width, self.height = self.images[self.frame]:getDimensions()
    self.world:add(self, self.x, self.y, self.width, self.height)
end

function Character:loadImages()
    if self.path == "" then
        print("ERROR: Need to set image!")
        return
    end

    local imageArray = {}
    for i = 1, self.totalFrames do
        imageArray[i] = love.graphics.newImage(self:getImagePath(i))
    end
    return imageArray
end

function Character:getImagePath(frame)
    return self.path .. frame .. ".png"
end

function Character:update(dt)
    if self:isMovingLeftOrRight() or self:isMovingUpOrDown() then
        if self._dt > self.updateTime then
            self:updateFrame()
            self._dt = 0
        else
            self._dt = self._dt + dt
        end
    end
end

function Character:updateFrame()
    self.frame = (self.frame) % self.totalFrames + 1
    return self.frame
end

function Character:getImageFromFrame()
    return self.images[self.frame]
end

function Character:draw()
    if Util:isDebug() then
        love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    end
    local image = self:getImageFromFrame()
    love.graphics.draw(image, self.x, self.y)
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

    for i, col in ipairs(cols) do
        if col.type == 'slide' then
            if col.normal.x ~= 0 then
                -- bounce a bit ;)
                self.vx = -(self.vx) * 0.4
            end
            if col.normal.y ~= 0 then
                -- bounce a bit ;)
                self.vy = -(self.vy) * 0.4
            end
        end
    end

    self.x = ax
    self.y = ay

    self.world:update(self, self.x, self.y)
end

return Character
