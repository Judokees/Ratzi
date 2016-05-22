local StateManager = require 'game.state.state_manager'
local FontManager = require 'game.font_manager'
local Splash = require 'game.state.splash'
local Intro = require 'game.state.intro'
local Level = require 'game.state.level'
local Util = require 'util'
local levels = require 'res.levels.levels'

function loadLevel(levelIndex)
    local level = Level.create(levels[levelIndex])
    StateManager:add('level', level)
    StateManager:show('level')
    StateManager:load(args)
end

function love.load(args)
    local levelIndex = 1
    FontManager:load()
    love.handlers.nextstate = function (a, b, c, d)
        if StateManager:getStateId() == 'splash' then
            local intro = Intro.create()
            StateManager:add('intro', intro)
            StateManager:show('intro')
            StateManager:load(args)
        elseif StateManager:getStateId() == 'intro' then
            loadLevel(levelIndex)
        elseif StateManager:getStateId() == 'level' then
            levelIndex = levelIndex + 1
            loadLevel(levelIndex)
        end
    end
    local splash = Splash.create()
    StateManager:add('splash', splash)
    StateManager:show('splash')
    StateManager:load(args)
    love.graphics.setBackgroundColor(185, 185, 185)
end

function love.update(dt)
    dt = math.min(1/60, dt)
    Util:update(dt)
    StateManager:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit();
    end
    StateManager:keypressed(key)
    if key == "tab" then
        Util:setDebug(not Util:isDebug())
    end
end

function love.keyreleased(key)
    StateManager:keyreleased(key)
end

function love.draw()
    StateManager:draw()
    Util:draw()
end
