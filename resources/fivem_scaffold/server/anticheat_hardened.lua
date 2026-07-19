-- server/anticheat_hardened.lua

local suspicious_counts = {}
local rpc_counts = {}
local RPC_LIMIT = 200 -- per minute limit (example)
local RPC_WINDOW = 60 * 1000

-- Example: track RPC calls per player
AddEventHandler('onServerResourceStart', function(resName)
  -- placeholder
end)

-- Generic helper to increment and check
local function incr_rpc(src)
  local now = GetGameTimer()
  rpc_counts[src] = rpc_counts[src] or { count = 0, ts = now }
  if now - rpc_counts[src].ts > RPC_WINDOW then
    rpc_counts[src].count = 0
    rpc_counts[src].ts = now
  end
  rpc_counts[src].count = rpc_counts[src].count + 1
  if rpc_counts[src].count > RPC_LIMIT then
    TriggerEvent('fivem_scaffold:adminAction', { action = 'tempban', target = tostring(src), payload = { reason = 'RPC flood', duration = 3600 } })
  end
end

-- Hook into common events as an example
RegisterNetEvent('fivem_scaffold:playerPositionUpdate')
AddEventHandler('fivem_scaffold:playerPositionUpdate', function(data)
  local src = source
  incr_rpc(src)
  -- additional speed checks could go here
end)

-- Weapon spawn detection: monitor when a client requests a weapon spawn (example event)
RegisterNetEvent('fivem_scaffold:clientRequestedWeapon')
AddEventHandler('fivem_scaffold:clientRequestedWeapon', function(weaponName)
  local src = source
  -- suspicious if player requests restricted weapons too frequently
  incr_rpc(src)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    -- periodic cleanup or checks
  end
end)
