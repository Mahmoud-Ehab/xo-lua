--[[
-- a state is an n*n matrix represents the board at some point of time.
-- an action is an integer ranging from 1 to n*n.
-- pactions of s: is a list of the possible actions that can be applied to some state "s".
-- rstate of a on s: is the resultant state of applying an action "a" on a state "s".
-- bstate is a state whose pactions is an empty list.
-- weight of s: is the sum of weights of each rstate of each paction, of s, on s; whereas s is not a bstate.
-- weight of s: is the interpretation of some bstate s; 1, -1, or 0: x wins, o wins, or draw.
--]]

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
local started = false
function AiAgent:chooseSlot(GameState)
  if not started then
    pick_thread:start(GameState.cur, weights, _G["checks"], self.power)
    started = true
  end
  local picked_action = love.thread.getChannel("picked_action"):pop()
  if picked_action then
    weights = love.thread.getChannel("weights"):demand()
    _G["checks"] = love.thread.getChannel("checks"):demand()
    started = false
    return picked_action
  end
  return picked_action
end

