local StateManager = require 'game.state.state_manager'
local Splash = require 'game.state.splash'
local Level = require 'game.state.level'
local Util = require 'util'

function love.load(args)
    love.handlers.nextstate = function (a, b, c, d)
        if StateManager:getStateId() == 'splash' then
            local level = Level.create('whatever-i-want')
            StateManager:add('level', level)
            StateManager:show('level')
            StateManager:load(args)
        end
    end
    local splash = Splash.create()
    StateManager:add('splash', splash)
    StateManager:show('splash')
    StateManager:load(args)
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
