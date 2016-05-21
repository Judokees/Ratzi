local camera = {}

camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.intensity = 0

local ww, wh = love.graphics.getDimensions()

function camera:set()
    local shaking = math.random() > 0.5 and self.intensity or -self.intensity
    love.graphics.push()
    love.graphics.rotate(-self.rotation)
    love.graphics.scale(1 / self.scaleX, 1/ self.scaleY)
    love.graphics.translate(-self.x + shaking, -self.y)
end

function camera:unset()
    love.graphics.pop()
end

function camera:move(x, y)
    self.x = self.x + (x or 0)
    self.y = self.y + (y or 0)
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:rotate(dir)
    self.rotation = self.rotation + dir
end

function camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function camera:shake(intensity)
    self.intensity = intensity
end

function camera:focus(target, bounds)

    -- Center on target
    local tx = target.x - ww / 2
    local ty = target.y - wh / 2

    -- prevent out of bounds
    tx = math.min(math.max(tx, bounds.x), bounds.width - ww)
    ty = math.min(math.max(ty, bounds.y), bounds.height - wh)

    if bounds.width < ww then
        tx = -(ww / 2 - bounds.width / 2)
    end

    if bounds.height < wh then
        ty = -(wh / 2 - bounds.height / 2)
    end

    self:setPosition(tx, ty)

end

return camera
