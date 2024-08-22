require "GameManager"
require "drawables/StateView"
require "drawables/TextView"

local game = GameManager:new(10)
game.Screen:addComponent("state_view", StateView:new(game.State.cur))
local status = game.Screen:addComponent("status_text_view", TextView:new({ x=20, y=love.graphics.getHeight() - 40}))
function status:update ()
  self.value = _G["status"]
end

function love.load()
  love.window.setMode(480, 600)
  game.Screen:load()
end

function love.update()
  game.Screen:update()
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
