require "drawables.Screen"
require "drawables.Button"
require "drawables.Select"

MainScreen = {}

function MainScreen:new()
  local o = Screen:new()
  self.__index = Screen:new()
  setmetatable(o, self)

  local StartBtn = Button:new(
    love.graphics.getWidth()/2,
    love.graphics.getHeight() - 50,
    "Start",
    function () Game:setScreen(Game.SCREENS.playground) end
  )
  o:addComponent("start_button", StartBtn)

  local SelectN = Select:new("Size:", {3,4,5,6,7,8,9,10}, "_n")
  local SelectPower = Select:new("Ai Level:", {1,2,3,4,5,6,7,8,9,10}, "_power")
  local SelectThreads = Select:new("Threads:", {1,2,4,8,16}, "_threads")
  SelectN.y = 0*love.graphics.getHeight()/4 + 50
  SelectPower.y = 1*love.graphics.getHeight()/4 + 50
  SelectThreads.y = 2*love.graphics.getHeight()/4 + 50
  o:addComponent("select_n", SelectN)
  o:addComponent("select_power", SelectPower)
  o:addComponent("select_threads", SelectThreads)

  return o
end

