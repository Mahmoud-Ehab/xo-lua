Player = {}

function Player:new (name)
  local o = { getName = function () return name end }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Player:chooseSlot ()
  local slot = tonumber(_G["selected_slot"])
  _G["selected_slot"] = nil
  return slot
end
