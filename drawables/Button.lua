require "drawables.TextView"

Button = {}

function Button:new(x, y, label, onclick)
  local o = { x=x, y=y, label=label, onclick=onclick }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Button:load()
  self.width = self.width or love.graphics.getWidth() - 100
  self.height = self.height or 45
  self.bgcolor = self.bgcolor or {161,214,178}
  self.textcolor = self.textcolor or {241,243,194}
  self.textview = TextView:new(self.x or 0, self.y or 0, self.fontSize or 24, "center")
  self.textview.value = self.label
  self.textview:load()
end

function Button:update()
  self.textview:update()
end

function Button:mousereleased(x, y, button)
  if button == 1 then
    if x < self.x - self.width/2 or x > self.x + self.width/2 then return end
    if y < self.y - self.height/2 or y > self.y + self.height/2 then return end
    self.onclick()
  end
end

function Button:draw()
  local unpack = table.unpack or unpack
  local r, g, b = love.math.colorFromBytes(unpack(self.bgcolor))
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle(
    "fill",
    self.x - self.width/2,
    self.y - self.height/2,
    self.width,
    self.height
  )
  r, g, b = love.math.colorFromBytes(unpack(self.textcolor))
  love.graphics.setColor(r,g,b)
  self.textview:draw()
end
