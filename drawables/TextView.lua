TextView = {}

function TextView:new (x, y, fontSize, align)
  local o = {
    value="",
    position={
      x=x or 0,
      y=y or 0,
    },
    fs=fontSize or 24,
    align=align or "left",
    origin={x=0,y=0}
  }
  self.font = love.graphics.newFont(o.fs)
  self.__index = self
  o.origin.y = self.font:getHeight()/2
  assert(o.align == "left" or o.align == "center" or o.align == "right")
  setmetatable(o, self)
  return o
end

function TextView:load ()
  self.font = love.graphics.newFont(self.fs)
  if self.align == "left" then
    self.origin.x = 0
  elseif self.align == "center" then
    self.origin.x = self.font:getWidth(self.value or "")/2
  elseif self.align == "right" then
    self.origin.x = self.font:getWidth(self.value or "")
  end
end

function TextView:update ()
  self.font = love.graphics.newFont(self.fs)
  if self.align == "left" then
    self.origin.x = 0
  elseif self.align == "center" then
    self.origin.x = self.font:getWidth(self.value or "")/2
  elseif self.align == "right" then
    self.origin.x = self.font:getWidth(self.value or "")
  end
end

function TextView:draw ()
  if string.find(self.value or "", "Gameover") then
    love.graphics.setColor(0,1,0)
  end
  love.graphics.print(
    self.value or "",
    self.font,
    self.position.x - self.origin.x,
    self.position.y - self.origin.y
  )
end
