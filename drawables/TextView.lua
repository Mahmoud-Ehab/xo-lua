TextView = {}

local origin = {
  x=0,
  y=0
}
local font

function TextView:new (x, y, fontSize, align)
  local o = {
    value="",
    position={
      x=x or 0,
      y=y or 0,
    },
    fs=fontSize or 24,
    align=align or "left",
  }
  assert(o.align == "left" or o.align == "center" or o.align == "right")
  font = love.graphics.newFont(24)
  origin.y = font:getHeight()/2
  self.__index = self
  setmetatable(o, self)
  return o
end

function TextView:update ()
  if self.align == "left" then
    origin.x = 0
  elseif self.align == "center" then
    origin.x = font:getWidth(self.value or "")/2
  elseif self.align == "right" then
    origin.x = font:getWidth(self.value or "")
  end
end

function TextView:draw ()
  if string.find(self.value or "", "Gameover") then
    love.graphics.setColor(0,1,0)
  end
  love.graphics.print(
    self.value or "",
    font,
    self.position.x,
    self.position.y,
    0,1,1,
    origin.x,
    origin.y
  )
end
