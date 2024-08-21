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

function GameState:getWinner ()
  local state = self.cur
  local n = #state
  local w = n > 5 and 5 or math.ceil(4/5 * 5) -- winning threshold value
  w = n < w and n or w

  -- check for rows and columns
  for row_index, row in ipairs(state) do
    local rowSum = 0
    for i = 1, n, 1 do
      local absDiff = math.abs(rowSum + row[i]) - math.abs(rowSum)
      rowSum = absDiff < 1 and row[i] or rowSum + row[i]
      if (rowSum == w or rowSum == -w ) then return rowSum / w end
    end
    local colSum = 0
    for i = 1, n, 1 do
      local absDiff = math.abs(colSum + state[i][row_index]) - math.abs(colSum)
      colSum = absDiff < 1 and row[i] or colSum + state[i][row_index]
      if (colSum == w or colSum == -w) then return colSum / w end
    end
  end

  -- check for main diagonals
  local topDiagSum = 0
  local botDiagSum = 0
  for i = 1, n-w+1, 1 do
    for k = 1, n-i+1, 1 do
      -- check bottom diagonals
      local absDiff = math.abs(topDiagSum + state[i+k-1][k]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[i+k-1][k] or topDiagSum + state[i+k-1][k]
      if (topDiagSum == w or topDiagSum == -w) then return topDiagSum / w end
      -- check top diagonals
      absDiff = math.abs(botDiagSum + state[k][i+k-1]) - math.abs(botDiagSum)
      botDiagSum = absDiff < 1 and state[k][i+k-1] or botDiagSum + state[k][i+k-1]
      if (botDiagSum == w or botDiagSum == -w) then return botDiagSum / w end
    end
  end

  -- check for antidiagonals
  topDiagSum = 0
  botDiagSum = 0
  for i = 1, n-w+1, 1 do
    for k = 1, n-i+1, 1 do
      -- check bottom diagonals
      local absDiff = math.abs(topDiagSum + state[i+k-1][n-k+1]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[i+k-1][n-k+1] or topDiagSum + state[i+k-1][n-k+1]
      if (topDiagSum == w or topDiagSum == -w) then return topDiagSum / w end
      -- check top diagonals
      absDiff = math.abs(botDiagSum + state[n-k+1][i+k-1]) - math.abs(botDiagSum)
      botDiagSum = absDiff < 1 and state[n-k+1][i+k-1] or botDiagSum + state[n-k+1][i+k-1]
      if (botDiagSum == w or botDiagSum == -w) then return botDiagSum / w end
    end
  end

  -- otherwise return 0 indicating that no winners yet
  return 0
end
