require "drawables.TextView"
require "drawables.Button"

Select = {}

function Select:new(label, values, globalkey)
  local o = { label=label, values=values, btns={}, globalkey=globalkey }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Select:mousereleased(x, y, button)
  for _, btn in ipairs(self.btns) do
    btn:mousereleased(x,y,button)
  end
end

function Select:load()
  self.x = self.x or 20
  self.y = self.y or 20
  self.width = self.width or love.graphics.getWidth() - 50
  self.height = self.height or 45

  self.textview = TextView:new(20, self.y, 18, "left")
  self.textview.value = self.label
  if self.textview.load then self.textview:load() end

  for i, val in ipairs(self.values) do
    local sidelen = math.min(self.width/(#self.values+1) - 15, 40)
    local btn = Button:new(i*(sidelen+10), self.y + 35, val, function() _G[self.globalkey]=val Game:reset() end)
    btn.width = sidelen
    btn.height = sidelen
    btn.bgcolor = {241,243,194}
    btn.textcolor = {161,214,178}
    btn.fontSize = 14
    if btn.load then btn:load() end
    table.insert(self.btns, btn)
  end
end

function Select:update()
  self.textview:update()
  for _, btn in ipairs(self.btns) do btn:update() end
end

function Select:draw()
  local r, g, b = love.math.colorFromBytes({161,214,178})
  love.graphics.setColor(r,g,b)
  self.textview:draw()
  for _, btn in ipairs(self.btns) do
    if tostring(btn.label) == tostring(_G[self.globalkey]) then
      btn.bgcolor = {161,214,178}
      btn.textcolor = {241,243,194}
    else
      btn.bgcolor = {241,243,194}
    btn.textcolor = {161,214,178}
    end
    btn:draw()
  end
end
