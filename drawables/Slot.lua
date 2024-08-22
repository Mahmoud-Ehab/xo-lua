Slot = {}

function Slot:new (state, ri, ci)
  local o = { position={x=0, y=0}, state=state, ri=ri, ci=ci }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Slot:load ()
  local index = #self.state * (self.ri - 1) + self.ci
  self.index = index
  self.label = ""
end

function Slot:update()
  local newStateVal = self.state[self.ri][self.ci]
  if newStateVal == 1 then
    self.label = "X"
  elseif newStateVal == -1 then
    self.label = "O"
  end
end

function Slot:mousereleased (x, y, button)
  if button == 1 then
    if x < self.position.x or x > self.position.x + 20 then return end
    if y < self.position.y or y > self.position.y + 20 then return end
    _G["selected_slot"] = self.index
  end
end

function Slot:draw ()
  love.graphics.rectangle("fill", self.position.x, self.position.y, 20, 20)
  love.graphics.print({{100,0,0,255}, self.label}, self.position.x + 2, self.position.y + 2)
end
