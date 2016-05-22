local Character = require 'game.world.character.character'

local RIGHT_KEY = 'd'
local LEFT_KEY = 'a'
local UP_KEY = 'w'
local DOWN_KEY = 's'
local SPACE_KEY = 'space'

local Player = {}
Player.__index = Player

setmetatable(Player, { __index = Character })

function Player.create(world, x, y)
    local self = Character.create(world, x, y)
    setmetatable(self, Player)
    self.path = "media/Ronny_"
    self.reputation = 1
    self.pulse = false
    self.pulseRadius = 100
    self.gameOver = false
    return self
end

function Player:load()
    Character.load(self)
end

function Player:update(dt)
    if love.keyboard.isDown(RIGHT_KEY) then
        self:moveRight()
        if self:isMovingLeft() then
            self:stopLeftRight()
        end
    elseif love.keyboard.isDown(LEFT_KEY) then
        self:moveLeft()
        if self:isMovingRight() then
            self:stopLeftRight()
        end
    else
        self:stopLeftRight()
    end

    if love.keyboard.isDown(DOWN_KEY) then
        self:moveDown()
        if self:isMovingUp() then
            self:stopUpDown()
        end
    elseif love.keyboard.isDown(UP_KEY) then
        self:moveUp()
        if self:isMovingDown() then
            self:stopUpDown()
        end
    else
        self:stopUpDown()
    end

    if love.keyboard.isDown(SPACE_KEY) and not self.pulse then
        self.pulse = true
        self.reputation = math.max(self.reputation - 0.001, 0)
    end

    self:checkReputation()

    self.vx = math.min(400, math.max(self.vx, -400))
    self.vy = math.min(400, math.max(self.vy, -400))

    self:move(self.x + (self.vx * dt), self.y + (self.vy * dt))
    Character.update(self, dt)
end

function Player:solveCollision(x, y, ax, ay, cols, len)
    ax, ay, cols, len = Character.solveCollision(self, x, y, ax, ay, cols, len)
    for _, col in ipairs(cols) do
        if col.other.type == 'fan' and col.type == 'slide' then
            if col.normal.y ~= 0 then
                col.other.vy = self.vy * 0.5
            end
            if col.normal.x ~= 0 then
                col.other.vx = self.vx * 0.5
            end
        end
        if col.other.type == 'marker' then
            love.event.push('collect')
        end
    end
    return ax, ay, cols, len
end

function Player:checkReputation()
    if self.reputation == 0 then
        self.gameOver = true
        love.event.push("gameOver")
    end
end

function Player:draw()
    Character.draw(self)
end

function Player:getDebug()
    return {
        "Player:",
        "x " .. math.floor(self.x) .. " y ".. math.floor(self.y),
        "vx " .. math.floor(self.vx) .. " vyr " .. math.floor(self.vy)
    }
end

return Player
