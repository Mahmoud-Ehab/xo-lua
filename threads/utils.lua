function GetActionsOf(state)
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

function CloneState(state)
  local clone = {}
  for r, row in ipairs(state) do
    clone[r] = {}
    for c, slot in ipairs(row) do
      clone[r][c] = slot
    end
  end
  return clone
end

function GetRState(action, state, ivalue)
  assert(ivalue <= 1 and ivalue >= -1)
  local n = #state
  local rstate = CloneState(state)
  rstate[math.ceil(action/n)][(action-1) % n + 1] = ivalue
  return rstate
end


