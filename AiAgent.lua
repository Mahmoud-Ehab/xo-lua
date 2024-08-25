require "Player"

-- this table maps each state to it's corresponding pre-computed weight
-- each state represented (as a key) by a string of its slots values
-- for example: "(9)0" represents the state of empty 3*3 board matrix
-- it highly enhances performance
local weights = {}

AiAgent = {}

function AiAgent:new(name, power)
  local o = Player:new(name)
  o.power = power or 10
  self.__index = self
  setmetatable(o, self)
  return o
end

local pick_thread = love.thread.newThread("threads/pick_action_thread.lua")
function AiAgent:chooseSlot(GameState)
  local picked_action = love.thread.getChannel("picked_action"):pop()
  if picked_action then
    weights = love.thread.getChannel("weights"):pop() or weights
    return picked_action
  end
  if not pick_thread:isRunning() then pick_thread:start(GameState.cur, weights, self.power) end
  return picked_action
end

