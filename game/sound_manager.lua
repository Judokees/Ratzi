local SoundManager = {}

SoundManager.sounds = {}

function SoundManager:add(id, state)
    SoundManager.sounds[id] = state
end

function SoundManager:remove(id)
    SoundManager.sounds[id] = nil
end

function SoundManager:load()
    SoundManager.sounds.intro = love.audio.newSource("res/sounds/intro.mp3", "static")
end

function SoundManager:get(id)
    return SoundManager.sounds[id]
end

return SoundManager
