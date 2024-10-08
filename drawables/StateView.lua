require "drawables.Slot"

StateView = {}

function StateView:new (state)
  local o = { state=state, slotlen=love.graphics.getWidth()/#state - 10, slots={} }
  self.__index = self
  setmetatable(o, self)
  return o
end

function StateView:load ()
  for ri, row in ipairs(self.state) do
    for ci in ipairs(row) do
      local newSlot = Slot:new(self.state, ri, ci, self.slotlen)
      newSlot.position = {
        x = love.graphics.getWidth()/2 + (ri - 1 - #self.state/2) * self.slotlen,
        y = love.graphics.getHeight()/3 + (ci - 1 - #self.state/3) * self.slotlen
      }
      newSlot:load()
      self.slots[ri .. ',' .. ci] = newSlot
    end
  end
end

function StateView:update ()
  for _, slot in pairs(self.slots) do if slot.update then slot:update() end end
end

function StateView:mousereleased (x, y, button)
  for _, slot in pairs(self.slots) do slot:mousereleased(x, y, button) end
end

function StateView:draw ()
  for _, slot in pairs(self.slots) do slot:draw() end
end
