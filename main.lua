love = love

require "GameManager"
require "drawables/StateView"
require "drawables/TextView"
require "drawables/Screen"

local game = GameManager:new(3)
local screen = Screen:new()

function love.load()
  love.window.setMode(480, 600)

  -- Add game board to the screen
  screen:addComponent("state_view", StateView:new(game.State.cur))

  -- Add text view at the bottom that tells the status of the game
  local StatusTextView = TextView:new(love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 24, "center")
  screen:addComponent("status_text_view", StatusTextView)

  screen:load()
end

local w = 0 -- winner code
function love.update()
  screen:update()
  screen:getComponent("status_text_view").value = _G["status"]
  if w ~= 0 then
    local winner = w == 1 and "X" or "O"
    _G["status"] = "Gameover: " .. winner .. " won."
  elseif game.State:isOver() then
    _G["status"] = "Gameover: it's draw."
  else
    game:update()
    w = game.State:getWinner()
  end
end

function love.mousereleased(x, y, button)
  screen:mousereleased(x, y, button)
end

function love.draw()
  screen:draw()
end
