local AnnoyingBastard = require 'game.world.character.annoyingBastard'
local Util = require 'util'

local Fan = {}
Fan.__index = Fan

setmetatable(Fan, { __index = AnnoyingBastard })

function Fan.create(world, player, x, y, npcNumber)
    local self = AnnoyingBastard.create(world, player, x, y, npcNumber)
    setmetatable(self, Fan)
    self.path = "media/NPC/npc" .. npcNumber .. "_"
    self.type = 'fan'
    return self
end

return Fan