require "drawables.Screen"
require "drawables.TextView"
require "drawables.StateView"
require "drawables.Button"

LevelScreen = Screen:new()

function LevelScreen:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)

  -- Go to MainMenu button
  local Btn = Button:new(
    love.graphics.getWidth()/2, 20, "Go to MainMenu",
    function () Game:setScreen(Game.SCREENS.mainmenu) end
  )
  o:addComponent("goto_mainmenu_btn", Btn)
  -- Add game board to the screen
  o:addComponent("state_view", StateView:new(Game:getState()))
  -- Add text view at the bottom that tells the status of the game
  local StatusTextView = TextView:new(love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 24, "center")
  o:addComponent("status_text_view", StatusTextView)
  return o
end

local update = LevelScreen.update
function LevelScreen:update()
  update(self)
  self:getComponent("status_text_view").value = _G["status"]
  if self.winner and self.winner ~= 0 then
    local winner = self.winner == 1 and "X" or "O"
    _G["status"] = "Gameover: " .. winner .. " won."
  elseif Game.State:isOver() then
    _G["status"] = "Gameover: it's draw."
  else
    Game:update()
    self.winner = Game.State:getWinner()
  end
end
