local StateManager = {}

StateManager.states = {}
StateManager.stateIndex = nil

function StateManager:add(id, state)
    StateManager.states[id] = state
end

function StateManager:remove(id)
    StateManager.states[id] = nil
end

function StateManager:show(id)
    StateManager.stateIndex = id
end

function StateManager:getStateId()
    return self.stateIndex
end

function StateManager:getState()
    return StateManager.states[StateManager.stateIndex]
end

function StateManager:canRender()
    return StateManager.stateIndex and StateManager.states[StateManager.stateIndex]
end

function StateManager:load()
    if not StateManager:canRender() then return end
    StateManager:getState():load()
end

function StateManager:keypressed(key)
    if not StateManager:canRender() then return end
    StateManager:getState():keypressed(key)
end

function StateManager:keyreleased(key)
    if not StateManager:canRender() then return end
    StateManager:getState():keyreleased(key)
end

function StateManager:update(dt)
    if not StateManager:canRender() then return end
    StateManager:getState():update(dt)
end

function StateManager:draw()
    if not StateManager:canRender() then return end
    StateManager:getState():draw()
end

return StateManager
