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

AiAgent = Player:new()

-- this table maps each state to it's corresponding pre-computed weight
-- each state represented (as a key) by a string of its slots values
-- for example: "0,0,0,0,0,0,0,0,0" represents the state of empty 3*3 board matrix
-- it highly enhances performance
local weights = {}
local maxint = 9999999999

function AiAgent:chooseSlot(GameState)
  local pactions = self:getActionsOf(GameState.cur)
  local rstates = {}
  for _, action in ipairs(pactions) do
    table.insert(rstates, self:getRState(action, GameState.cur, pactions.ivalue))
  end

  local picked_index = 1
  local max_weight = maxint * pactions.ivalue
  for i, state in ipairs(rstates) do
    -- pactions.ivalue here specifies if the ai is playing as X or O
    local w = self:getWeightOf(state, GameState.check) * pactions.ivalue
    if w > max_weight then
      max_weight = w
      picked_index = i
    end
  end
  return pactions[picked_index]
end

function AiAgent:getWeightOf(state, checkfunc, depth)
  if not depth then depth = 1 end
  local state_key = self:genKey(state)
  if weights[state_key] then return weights[state_key] end

  local bstate_check = checkfunc(state)
  if bstate_check ~= 0 then
    weights[state_key] = bstate_check
    return weights[state_key]
  end

  local pactions = self:getActionsOf(state)
  if #pactions == 0 then
    weights[state_key] = bstate_check
    return weights[state_key]
  end

  local weight = 0
  local rstates = {}
  for _, action in ipairs(pactions) do
    local rstate = self:getRState(action, state, pactions.ivalue)
    local checkval = checkfunc(rstate)
    if checkval ~= 0 then weight = weight + checkval
    else table.insert(rstates, rstate) end
  end

  if weight == 0 then
    for _, rstate in ipairs(rstates) do
      weight = weight + self:getWeightOf(rstate, checkfunc, depth + 1)
    end
  end

  weights[state_key] = weight / depth
  return weights[state_key]
end

function AiAgent:getActionsOf(state)
  local n = #state
  local pactions = {}
  local x, o = 0, 0
  for r, row in ipairs(state) do
    for c, slot in ipairs(row) do
      if slot == 0 then table.insert(pactions, n * (r - 1) + c)
      elseif slot == 1 then x = x + 1
      elseif slot == -1 then o = o + 1
      end
    end
  end
  pactions.ivalue = o < x and -1 or 1
  return pactions
end

function AiAgent:getRState(action, state, ivalue)
  assert(ivalue <= 1 and ivalue >= -1)
  local n = #state
  local rstate = self:cloneState(state)
  rstate[math.ceil(action/n)][(action-1) % n + 1] = ivalue
  return rstate
end

function AiAgent:cloneState(state)
  local clone = {}
  for r, row in ipairs(state) do
    clone[r] = {}
    for c, slot in ipairs(row) do
      clone[r][c] = slot
    end
  end
  return clone
end

function AiAgent:genKey(state)
  local key = ""
  for _, row in ipairs(state) do
    if key ~= "" then key = key .. "," end
    key = key .. table.concat(row, ",")
  end
  return key
end
