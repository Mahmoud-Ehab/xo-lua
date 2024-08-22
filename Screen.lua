Screen = {}

function Screen:new (width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")
  local o = { components = {}, width=width, height=height }
  self.__index = self
  setmetatable(o, self)
  return o
end

function Screen:mousereleased (x, y, button)
  for _, v in pairs(self.components) do if v.load then v:mousereleased(x, y, button) end end
end

function Screen:load ()
  for _, v in pairs(self.components) do if v.load then v:load() end end
end

function Screen:update ()
  for _, v in pairs(self.components) do if v.update then v:update() end end
end

function Screen:draw ()
  for _, v in pairs(self.components) do v:draw() end
end

function Screen:addComponent (id, drawable)
  self.components[id] = drawable
  return drawable
end

function Screen:getComponenet (id)
  assert(self.components[id])
  return self.components[id]
end

function Screen:rmvComponent (id)
  if not self.components[id] then error("Screen: no drawable found with the id: " .. id) end
  self.components[id] = nil
end
