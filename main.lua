--[[ 0 represents blank, 1 represents X, and -1 represents O ]]--
local state = {}
local n = 3
local xTurn = true


function InitGame ()
  io.write("Put the value of n (to init n*n matrix): ")
  local new_n = io.read("*n")
  if new_n then n = new_n end
  for _ = 1, n, 1 do
    local row = {}
    for _ = 1, n, 1 do table.insert(row, 0) end
    table.insert(state, row)
  end
  local _ = io.read() -- To catch the last \n char
end

local function printState ()
  local hold_padding = " "
  local empty_padding = "-"
  print()
  for row_index, row in ipairs(state) do
    for col_index, box in ipairs(row) do
      if (box == 0) then
        local index = n * (row_index - 1) + col_index
        local str = index <= 9 and "0" .. tostring(index) or tostring(index)
        io.write(empty_padding .. str .. empty_padding)
      elseif box == 1 then
        io.write(hold_padding .. " X" .. hold_padding)
      elseif box == -1 then
        io.write(hold_padding .. " O" .. hold_padding)
      end
      if col_index % n == 0 then
        io.write("\n")
      else
        io.write("|")
      end
    end
    if row_index == n then break end
    for col_index in ipairs(row) do
      for _ = 1, 2 * (string.len(empty_padding) + 1), 1 do
        io.write(empty_padding)
      end
      if col_index % n == 0 then
        io.write("\n")
      else
        io.write("|")
      end
    end
  end
  print()
end

local function isGameOver ()
  for _, row in ipairs(state) do
    for _, val in ipairs(row) do
      if val == 0 then return false end
    end
  end
  return true
end

local function checkState ()
  local w = n > 5 and 5 or math.ceil(4/5 * 5) -- winning threshold value

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
  local diagSum = 0
  local twinDiagSum = 0
  for i = 1, n-w+1, 1 do
    for k = 1, n-i+1, 1 do
      -- check bottom diagonals
      local absDiff = math.abs(diagSum + state[i+k-1][k]) - math.abs(diagSum)
      diagSum = absDiff < 1 and state[i+k-1][k] or diagSum + state[i+k-1][k]
      if (diagSum == w or diagSum == -w) then return diagSum / w end
      -- check top diagonals
      absDiff = math.abs(twinDiagSum + state[k][i+k-1]) - math.abs(twinDiagSum)
      twinDiagSum = absDiff < 1 and state[k][i+k-1] or twinDiagSum + state[k][i+k-1]
      if (twinDiagSum == w or twinDiagSum == -w) then return twinDiagSum / w end
    end
  end

  -- check for antidiagonals
  diagSum = 0
  twinDiagSum = 0
  for i = 1, n-w+1, 1 do
    for k = 1, n-i+1, 1 do
      -- check bottom diagonals
      local absDiff = math.abs(diagSum + state[i+k-1][n-k+1]) - math.abs(diagSum)
      diagSum = absDiff < 1 and state[i+k-1][n-k+1] or diagSum + state[i+k-1][n-k+1]
      if (diagSum == w or diagSum == -w) then return diagSum / w end
      -- check top diagonals
      absDiff = math.abs(twinDiagSum + state[n-k+1][i+k-1]) - math.abs(twinDiagSum)
      twinDiagSum = absDiff < 1 and state[n-k+1][i+k-1] or twinDiagSum + state[n-k+1][i+k-1]
      if (twinDiagSum == w or twinDiagSum == -w) then return twinDiagSum / w end
    end
  end

  return 0
end

local function invokeGameLoop ()
  local whoseInTurn = (xTurn and "X") or "O"

  local loc
  repeat
    io.write(whoseInTurn .. "'s turn: ")
    loc = tonumber(io.read())
    if not loc then print("Invalid input: write number from 1 to " .. n*n) end
  until loc

  if (loc < 1 or loc > n*n) then
    print("Invalid input: write number from 1 to " .. n*n)
    return false
  end

  local row = math.ceil(loc/n)
  local col = ((loc-1)%n)+1

  if (state[row][col] ~= 0) then
    print("Error: you can't play in this location!")
    return false
  end

  state[row][col] = xTurn and 1 or -1
  xTurn = not xTurn
  return true
end

function StartGame ()
  printState()
  while true do
    if isGameOver() then
      print("GameOver: draw")
      break
    end
    local winning = checkState()
    if (winning == 0) then
      local switched = invokeGameLoop()
      if switched then printState() end
    else
      local whoWins = "Nobody"
      if (winning == 1) then
        whoWins = "X"
      elseif winning == -1 then
        whoWins = "O"
      end
      print("GameOver: " .. whoWins .. " has won!")
      break
    end
  end
end

InitGame()
StartGame()
