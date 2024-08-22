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
  local state = self.cur
  local n = #state
  local w = n > 5 and 5 or 3 -- winning threshold value

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
      colSum = absDiff < 1 and state[i][row_index] or colSum + state[i][row_index]
      if (colSum == w or colSum == -w) then return colSum / w end
    end
  end

  -- check for main diagonals
  local topDiagSum = 0
  local botDiagSum = 0
  for i = 1, n-w+1, 1 do
    for k = 1, n-i+1, 1 do
      -- check top diagonals
      local absDiff = math.abs(topDiagSum + state[i+k-1][k]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[i+k-1][k] or topDiagSum + state[i+k-1][k]
      if (topDiagSum == w or topDiagSum == -w) then return topDiagSum / w end
      -- check bottom diagonals
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
      local absDiff = math.abs(botDiagSum + state[i+k-1][n-k+1]) - math.abs(botDiagSum)
      botDiagSum = absDiff < 1 and state[i+k-1][n-k+1] or botDiagSum + state[i+k-1][n-k+1]
      if (botDiagSum == w or botDiagSum == -w) then return botDiagSum / w end
      if i == 1 then goto continue end
      -- check top diagonals
      absDiff = math.abs(topDiagSum + state[i+k-2][n-k]) - math.abs(topDiagSum)
      topDiagSum = absDiff < 1 and state[i+k-2][n-k] or topDiagSum + state[i+k-2][n-k]
      if (topDiagSum == w or topDiagSum == -w) then return topDiagSum / w end
    end
      ::continue::
  end

  -- otherwise return 0 indicating that no winners yet
  return 0
end

function GameState:toString ()
  local res = ""
  local n = #self.cur -- used in evaluating the order of any slot according to its row and column indexes
  local hold_padding = "  "
  local empty_padding = "--"
  for row_index, row in ipairs(self.cur) do
    for col_index, col in ipairs(row) do
      if (col == 0) then
        local index = n * (row_index - 1) + col_index
        local str = index <= 9 and "0" .. tostring(index) or tostring(index)
        res = res .. (empty_padding .. str .. empty_padding)
      elseif col == 1 then
        res = res .. (hold_padding .. "X" .. hold_padding)
      elseif col == -1 then
        res = res .. (hold_padding .. "O" .. hold_padding)
      end
      if col_index % n == 0 then res = res .. "\n" else res = res .. "|" end
    end
    if row_index == n then break end
    for col_index in ipairs(row) do
      for _ = 1, 1 + string.len(empty_padding), 1 do
        res = res .. empty_padding
      end
      if col_index % n == 0 then res = res .. "\n" else res = res .. "|" end
    end
  end
  return res
end
