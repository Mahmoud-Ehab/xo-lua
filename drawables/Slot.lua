Slot = {}

local x_img, o_img, scale

function Slot:new (state, ri, ci, len)
  local o = { position={x=0, y=0}, state=state, ri=ri, ci=ci, len=len }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Slot:load ()
  self.index = #self.state * (self.ri - 1) + self.ci
  self.label = ""
  -- the two images shall have the same width
  x_img = love.graphics.newImage("assets/x.png")
  o_img = love.graphics.newImage("assets/o.png")
  scale = self.len / x_img:getWidth() - 0.1
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
    if x < self.position.x or x > self.position.x + self.len then return end
    if y < self.position.y or y > self.position.y + self.len then return end
    _G["selected_slot"] = self.index
  end
end

function Slot:draw ()
  local r, g, b = love.math.colorFromBytes(197, 112, 93)
  love.graphics.setColor(r, g, b)
  love.graphics.setLineWidth(4)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.len, self.len)
  if self.label ~= "" then
    local img = self.label == "X" and x_img or o_img
    love.graphics.draw(
      img,
      self.position.x + self.len/2,
      self.position.y + self.len/2,
      0, scale, scale,
      img:getWidth()/2,
      img:getHeight()/2
    )
  end
end
