require "drawables.Screen"
require "Player"
require "GameState"

GameManager = {}
local playerInTurn

function GameManager:new (n)
  local o = {}
  o.State = GameState:new(n or 3)
  o.Screen = Screen:new()
  o.Players = {
    Player:new("X"),
    Player:new("O")
  }
  playerInTurn = o.Players[1]
  self.__index = self
  setmetatable(o, self)
  return o
end

function GameManager:reset (n)
  self.State = GameState:new(n)
  playerInTurn = self.Players[1]
  _G["status"] = nil
  _G["status_changed"] = nil
end

function GameManager:update ()
  _G["status"] = playerInTurn.getName() .. " player turn."
  self:action(playerInTurn)
end

function GameManager:action (player)
  local state = self.State.cur
  local n = #state
  local slot = player:chooseSlot()
  if not slot then return false end

  local row = math.ceil(slot/n)
  local col = ((slot-1)%n)+1

  if (state[row][col] ~= 0) then
    print("Error: you can't play in this location!")
    return false
  end

  state[row][col] = player.getName() == "X" and 1 or -1
  for _, v in ipairs(self.Players) do
    if v ~= playerInTurn then playerInTurn = v; break end
  end
  _G["state_changed"] = true -- to inform changes to GameState:getWinner method
  return true
end
