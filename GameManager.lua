require "Screen"
require "Player"
require "GameState"

GameManager = {}

function GameManager:new (n)
  local o = {}
  o.State = GameState:new(n or 3)
  o.Screen = Screen:new(o.State.cur)
  o.Players = {
    Player:new("X"),
    Player:new("O")
  }
  self.__index = self
  setmetatable(o, self)
  return o
end

function GameManager:reset (n)
  self.State = GameState:new(n)
end

function GameManager:start ()
  local winner
  self.Screen:print()
  while not self.State:isOver() do
    for _, player in ipairs(self.Players) do
      winner = self.State:getWinner()
      if winner ~= 0 then break end
      self:action(player)
    end
    if winner ~= 0 then break end
  end
  if winner == 1 then
    print("Gameover: X won!")
  elseif winner == -1 then
    print("Gameover: O won!")
  else
    print("Gameover: it's draw.")
  end
end

function GameManager:action (player)
  local state = self.State.cur
  local n = #state
  local slot = player:chooseSlot(n)

  local row = math.ceil(slot/n)
  local col = ((slot-1)%n)+1

  if (state[row][col] ~= 0) then
    print("Error: you can't play in this location!")
    return false
  end

  state[row][col] = player.getName() == "X" and 1 or -1
  self.Screen:print()
end
