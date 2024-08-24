-- 0 represents blank, 1 represents X, and -1 represents O
GameState = {}

function GameState:new (n)
  local o = {
    cur = {}, -- currect state
    prev = {}, -- history list of previous states
  }
  for _ = 1, n, 1 do
    local row = {}
    for _ = 1, n, 1 do table.insert(row, 0) end
    table.insert(o.cur, row)
  end
  self.__index = self
  setmetatable(o, self)
  return o
end

function GameState:updateSlot (row, col, val)
  if (not self.cur[row][col] == 0) then
    table.insert(self.prev, self.cloneState(self.cur))
    self.cur[row][col] = val
  else
    error("cannot update a slot more than once", 2)
  end
end

function GameState:cloneState (state)
  local clone = {}
  local n = #state
  for r = 1, n, 1 do
    local row = {}
    for c = 1, n, 1 do table.insert(row, state[r][c]) end
    table.insert(clone, row)
  end
  return clone
end

function GameState:isOver ()
  for _, row in ipairs(self.cur) do
    for _, val in ipairs(row) do
      if val == 0 then return false end
    end
  end
  return true
end

local memo_winner = 0
function GameState:getWinner ()
  if memo_winner ~= 0 then return memo_winner end
  if not _G["state_changed"] then return 0 end
  local winner = self.check(self.cur)
  if winner == 0 then _G["state_changed"] = false end -- to save computations for next (love.update) loops
  return winner
end

-- checks the state and returns 1, -1, or 0 if X wins, O wins, or noone.
local checked = {}
function GameState.check (state)
  local state_key = GameState.genKey(state)
  if checked[state_key] then return checked[state_key] end

  local n = #state
  local w = n > 5 and 5 or n -- winning threshold value
  -- check for rows and columns
  for row_index, row in ipairs(state) do
    local rowSum = 0
    for i = 1, n, 1 do
      local absDiff = math.abs(rowSum + row[i]) - math.abs(rowSum)
      rowSum = absDiff < 1 and row[i] or rowSum + row[i]
      if (rowSum == w or rowSum == -w ) then
        checked[state_key] = rowSum/w
        return rowSum/w
      end
    end
    local colSum = 0
    for i = 1, n, 1 do
      local absDiff = math.abs(colSum + state[i][row_index]) - math.abs(colSum)
      colSum = absDiff < 1 and state[i][row_index] or colSum + state[i][row_index]
      if (colSum == w or colSum == -w) then
        checked[state_key] = colSum/w
        return colSum/w
      end
    end
  end

  -- check for main diagonals
  for i = 1, n-w+1, 1 do
    local topDiagSum = 0
    local botDiagSum = 0
    for k = 1, n-i+1, 1 do
      -- check top diagonals
      local absDiff = math.abs(topDiagSum + state[i+k-1][k]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[i+k-1][k] or topDiagSum + state[i+k-1][k]
      if (topDiagSum == w or topDiagSum == -w) then
        checked[state_key] = topDiagSum/w
        return topDiagSum/w
      end
      -- check bottom diagonals
      absDiff = math.abs(botDiagSum + state[k][i+k-1]) - math.abs(botDiagSum)
      botDiagSum = absDiff < 1 and state[k][i+k-1] or botDiagSum + state[k][i+k-1]
      if (botDiagSum == w or botDiagSum == -w) then
        checked[state_key] = botDiagSum/w
        return botDiagSum/w
      end
    end
  end

  -- check for antidiagonals
  for i = 1, n-w+1, 1 do
    local topDiagSum = 0
    local botDiagSum = 0
    for k = 1, n-i+1, 1 do
      -- check bottom diagonals
      local absDiff = math.abs(botDiagSum + state[i+k-1][n-k+1]) - math.abs(botDiagSum)
      botDiagSum = absDiff < 1 and state[i+k-1][n-k+1] or botDiagSum + state[i+k-1][n-k+1]
      if (botDiagSum == w or botDiagSum == -w) then
        checked[state_key] = botDiagSum/w
        return botDiagSum/w
      end
      if i == 1 then goto continue end
      -- check top diagonals
      absDiff = math.abs(topDiagSum + state[k][n-k-i+2]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[k][n-k-i+2] or topDiagSum + state[k][n-k-i+2]
      if (topDiagSum == w or topDiagSum == -w) then
        checked[state_key] = topDiagSum/w
        return topDiagSum/w
      end
      ::continue::
    end
  end

  -- otherwise return 0 indicating that no winners yet
  checked[state_key] = 0
  return 0
end

function GameState.genKey(state)
  local key = ""
  local lastseen = 0
  local count = 1
  for _, row in ipairs(state) do
    for _, slot in ipairs(row) do
      if lastseen ~= slot then
        key = string.format("%s(%d)%d", key, count, lastseen)
        lastseen = slot
        count = 1
      else
        count = count + 1
      end
    end
  end
  return key
end
