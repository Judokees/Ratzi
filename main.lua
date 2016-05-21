local StateManager = require 'game.state.state_manager'
local Splash = require 'game.state.splash'
local Level = require 'game.state.level'

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
    StateManager:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit();
    end
    StateManager:keypressed(key)
end

function love.keyreleased(key)
    StateManager:keyreleased(key)
end

function love.draw()
    StateManager:draw()
end
