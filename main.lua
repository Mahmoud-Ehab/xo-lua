require "GameManager"
require "drawables/StateView"
require "drawables/TextView"

local game = GameManager:new(10)

function love.load()
  love.window.setMode(480, 600)

  -- Add game board to the screen
  game.Screen:addComponent("state_view", StateView:new(game.State.cur))

  -- Add text view at the bottom that tells the status of the game
  local StatusTextView = TextView:new(love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 24, "center")
  game.Screen:addComponent("status_text_view", StatusTextView)

  game.Screen:load()
end

function love.update()
  game.Screen:update()
  game.Screen:getComponent("status_text_view").value = _G["status"]
  local w = game.State:getWinner()
  if w ~= 0 then
    local winner = w == 1 and "X" or "O"
    _G["status"] = "Gameover: " .. winner .. " won."
    return
  end
  if game.State:isOver() then
    _G["status"] = "Gameover: it's draw."
    return
  end
  game:update()
end

function love.mousereleased(x, y, button)
  game.Screen:mousereleased(x, y, button)
end

function love.draw()
  game.Screen:draw()
end
