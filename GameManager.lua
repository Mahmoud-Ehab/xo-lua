_G["checks"] = {} -- needs to be initialized before importing GameState
require "GameState"
require "Player"
require "AiAgent"
require "screens.MainScreen"
require "screens.LevelScreen"

GameManager = {}

function GameManager:new ()
  local o = { SCREENS={} }
  o.State = GameState:new(_G["_n"])
  o.Players = {
    Player:new("X player turn."),
    AiAgent:new("AI thinking...", _G["_power"])
  }
  self.playerInTurn = o.Players[1]
  self.__index = self
  setmetatable(o, self)

  o:addScreen("mainmenu", MainScreen)
  o:addScreen("playground", LevelScreen)

  return o
end

function GameManager:addScreen(key, screen)
  self.SCREENS[key] = screen
end

function GameManager:setScreen(screen)
  self.screen = screen:new()
  self.screen:load()
end

function GameManager:reset ()
  self.State = GameState:new(_G["_n"])
  self:addScreen("mainmenu", MainScreen)
  self:addScreen("playground", LevelScreen)
  self.playerInTurn = self.Players[1]
  _G["status"] = nil
  _G["status_changed"] = nil
  collectgarbage("collect")
end

function GameManager:getState()
  return self.State.cur
end

function GameManager:update ()
  _G["status"] = self.playerInTurn.getName()
  self:action(self.playerInTurn)
end

function GameManager:action (player)
  local state = self.State.cur
  local n = #state
  local slot = player:chooseSlot(self.State)
  if not slot then return false end

  local row = math.ceil(slot/n)
  local col = ((slot-1)%n)+1

  if (state[row][col] ~= 0) then
    print("Error: you can't play in this location!")
    return false
  end

  self.State:updateSlot(row, col, string.find(player.getName(), "X") and 1 or -1)
  for _, v in ipairs(self.Players) do
    if v ~= self.playerInTurn then self.playerInTurn = v; break end
  end
  _G["state_changed"] = true -- to inform changes to GameState:getWinner method
  return true
end
