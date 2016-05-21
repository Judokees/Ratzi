local FontManager = {}

FontManager.fonts = {}

function FontManager:add(id, state)
    FontManager.fonts[id] = state
end

function FontManager:remove(id)
    FontManager.fonts[id] = nil
end

function FontManager:load()
    FontManager.fonts['default'] = love.graphics.newFont("res/fonts/lineto-circular-black.ttf", 15)
    FontManager.fonts['headline'] = love.graphics.newFont("res/fonts/lineto-circular-black.ttf", 20)
end

function FontManager:get(id)
    return FontManager.fonts[id]
end

return FontManager
