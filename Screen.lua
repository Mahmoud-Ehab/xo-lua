Screen = {}

function Screen:new (state)
  local o = { state = state }
  self.__index = self
  setmetatable(o, self)
  return o
end

-- 0 represents blank, 1 represents X, and -1 represents O
function Screen:print ()
  local n = #self.state -- used in evaluating the order of any slot according to its row and column indexes
  local hold_padding = " " -- used for styling purposes; it's a horizontal-padding for slots that holds values or X or O
  local empty_padding = "-" -- alike hold_padding but for empty slots
  print()
  for row_index, row in ipairs(self.state) do
    for col_index, col in ipairs(row) do
      if (col == 0) then
        local index = n * (row_index - 1) + col_index
        local str = index <= 9 and "0" .. tostring(index) or tostring(index)
        io.write(empty_padding .. str .. empty_padding)
      elseif col == 1 then
        io.write(hold_padding .. " X" .. hold_padding)
      elseif col == -1 then
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
