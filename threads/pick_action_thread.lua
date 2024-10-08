require "threads/utils"

-- thread inputs
local state, weights, checks, power, threads_num = ...

local threads = { }
for i = 1, tonumber(threads_num), 1 do
  threads[i] = love.thread.newThread("threads/get_weight_thread.lua")
end

local function selectThread()
  for _, thread in ipairs(threads) do
    if not thread:isRunning() then return thread end
  end
  return selectThread()
end

local function threadsDone()
  for _, thread in ipairs(threads) do
    if thread:isRunning() then return false end
  end
  return true
end

local pactions = GetActionsOf(state)
local rstates = {}
for _, action in ipairs(pactions) do
  table.insert(rstates, GetRState(action, state, pactions.ivalue))
end

local picked_index = 1
local max_weight = 9999999999 * pactions.ivalue

for i, s in ipairs(rstates) do
  local thread = selectThread()
  -- update weights tables to enhance performance
  local weights_table = love.thread.getChannel("weights"):pop()
  while weights_table do
    local mt = { __index=weights }
    setmetatable(weights_table, mt)
    weights = weights_table
    weights_table = love.thread.getChannel("weights"):pop()
  end
  -- update checks tables to enhance performance
  local checks_table = love.thread.getChannel("checks"):pop()
  while checks_table do
    local mt = { __index=checks }
    setmetatable(checks_table, mt)
    checks = checks_table
    checks_table = love.thread.getChannel("checks"):pop()
  end
  thread:start(i, s, weights, checks, power)
end

local eval_weights = {}
local weight_indexes = {}
while not threadsDone() do
  table.insert(eval_weights, love.thread.getChannel("eval_weight"):pop())
  table.insert(weight_indexes, love.thread.getChannel("weight_index"):pop())
end
table.insert(eval_weights, love.thread.getChannel("eval_weight"):pop())
table.insert(weight_indexes, love.thread.getChannel("weight_index"):pop())

for i, w in ipairs(eval_weights) do
  -- pactions.ivalue here specifies if the ai is playing as X or O
  w = w * pactions.ivalue
  -- (esp case) once you find a win (w == 1), jump to it!
  if w == 1 then
    picked_index = weight_indexes[i]
    break
  end
  if w > max_weight then
    max_weight = w
    picked_index = weight_indexes[i]
  end
end

love.thread.getChannel("picked_action"):push(pactions[picked_index])
love.thread.getChannel("weights"):push(weights)
love.thread.getChannel("checks"):push(checks)
