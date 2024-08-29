love = love

require "GameManager"

_G["_n"] = 3
_G["_power"] = 3
_G["_threads"] = 1

Game = GameManager:new()

function love.load()
  love.window.setMode(480, 600)
  love.window.setTitle("xo-lua")
  Game:setScreen(Game.SCREENS.mainmenu)
  Game.screen:load()
end

function love.update()
  Game.screen:update()
end

function love.mousereleased(x, y, button)
  Game.screen:mousereleased(x, y, button)
end

function love.draw()
  Game.screen:draw()
end
