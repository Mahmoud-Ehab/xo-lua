TextView = {}

function TextView:new (pos)
  local o = {
    value="",
    position={ x=pos.x, y=pos.y }
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function TextView:draw ()
  love.graphics.print(self.value or "", self.position.x or 0, self.position.y or 0)
end
