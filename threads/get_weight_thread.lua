local index, state, weights, checks, power = ...
power = tonumber(power)
_G["checks"] = checks

require "GameState"
require "threads/utils"

local function getWeightOf(s, depth)
  if not depth then depth = 1 end
  if depth >= power then return 0 end

  local state_key = GenKey(s)
  if weights[state_key] then return weights[state_key] / depth end

  local bstate_check = CheckState(s)
  if bstate_check ~= 0 then
    weights[state_key] = bstate_check
    return bstate_check / depth
  end

  local pactions = GetActionsOf(s)
  if #pactions == 0 then
    weights[state_key] = bstate_check
    return bstate_check / depth
  end

  local weight = 0
  local rstates = {}
  for _, action in ipairs(pactions) do
    local rstate = GetRState(action, s, pactions.ivalue)
    local checkval = CheckState(rstate)
    if checkval ~= 0 then weight = weight + checkval
    else table.insert(rstates, rstate) end
  end

  if weight == 0 then
    for _, rstate in ipairs(rstates) do
      weight = weight + getWeightOf(rstate, depth + 1)
    end
  end

  weights[state_key] = weight
  return weight / depth
end

local eval_weight = getWeightOf(state)
love.thread.getChannel("eval_weight"):push(eval_weight)
love.thread.getChannel("weight_index"):push(index)
love.thread.getChannel("weights"):push(weights)
love.thread.getChannel("checks"):push(checks)
