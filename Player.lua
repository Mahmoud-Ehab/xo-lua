Player = {}

function Player:new (name)
  local o = { getName = function () return name end }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Player:chooseSlot (n)
  io.write(self.getName() .. "'s turn: ")
  local slot = tonumber(io.read())
  if not slot or slot < 1 or slot > n*n then
    print("Invalid input: write number from 1 to " .. n*n)
    return Player:chooseSlot(n)
  end
  return slot
end
