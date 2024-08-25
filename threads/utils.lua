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

function CloneStateWithAction(state, action, ivalue)
  local n = #state
  local x, y = math.ceil(action/n), (action-1) % n + 1
  local tmp = state[x][y]
  state[x][y] = ivalue

  local clone = {}
  local lastseen = nil
  local count = 0

  for r, row in ipairs(state) do
    clone[r] = {}
    for c, slot in ipairs(row) do
      clone[r][c] = slot
      if lastseen == nil then lastseen = slot end
      if lastseen ~= slot then
        clone.key = string.format("%s(%d)%d", clone.key, count, lastseen)
        lastseen = slot
        count = 1
      else
        count = count + 1
      end
    end
  end
  clone.key = string.format("%s(%d)%d", clone.key, count, lastseen)
  state[x][y] = tmp
  return clone
end

function GetRState(action, state, ivalue)
  assert(ivalue <= 1 and ivalue >= -1)
  return CloneStateWithAction(state, action, ivalue)
end


