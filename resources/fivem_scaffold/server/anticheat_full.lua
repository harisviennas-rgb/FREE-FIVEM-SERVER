-- server/anticheat_full.lua
-- Enhanced anticheat: speed, teleport, godmode, weapon spawn detection, RPC flood, health checks, and logging.

local pos_history = {}
local last_check = {}
local rpc_counts = {}
local RPC_LIMIT = Config.AntiCheat and Config.AntiCheat.rpcLimitPerMinute or 200
local RPC_WINDOW = 60 * 1000
local SPEED_LIMIT = 50.0 -- meters per second unrealistic

local function logEvent(src, typ, details)
  print(('[anticheat][%s] player=%s details=%s'):format(typ, tostring(src), tostring(details)))
  if GetResourceState('oxmysql') == 'started' then
    local ids = GetPlayerIdentifiers(src)
    local steam = ids[1]
    exports.oxmysql:insert('INSERT INTO ff_server_logs (type, actor, target, details) VALUES (?, ?, ?, ?)', { typ, 'anticheat', steam, tostring(details) })
  end
  TriggerClientEvent('fivem_scaffold:notifyNUI', -1, ('[ANTICHEAT] %s flagged: %s'):format(tostring(src), tostring(typ)))
end

-- RPC tracker
local function incr_rpc(src)
  local now = GetGameTimer()
  rpc_counts[src] = rpc_counts[src] or { count = 0, ts = now }
  if now - rpc_counts[src].ts > RPC_WINDOW then
    rpc_counts[src].count = 0
    rpc_counts[src].ts = now
  end
  rpc_counts[src].count = rpc_counts[src].count + 1
  if rpc_counts[src].count > RPC_LIMIT then
    logEvent(src, 'rpc_flood', rpc_counts[src].count)
    -- conservative: tempban for 1 hour
    TriggerEvent('fivem_scaffold:adminAction', { action = 'tempban', target = tostring(src), payload = { reason = 'RPC flood', duration = 3600 } })
  end
end

-- position updates from client
RegisterNetEvent('fivem_scaffold:playerPositionUpdate')
AddEventHandler('fivem_scaffold:playerPositionUpdate', function(data)
  local src = source
  incr_rpc(src)
  if not data or not data.x then return end
  local now = GetGameTimer()
  local pt = pos_history[src] or { last = now, x = data.x, y = data.y, z = data.z }
  local dt = math.max(1, (now - (pt.last or now))) / 1000
  local dx = data.x - (pt.x or data.x)
  local dy = data.y - (pt.y or data.y)
  local dz = data.z - (pt.z or data.z)
  local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
  local speed = dist / dt
  if speed > SPEED_LIMIT then
    logEvent(src, 'speed_hack', { speed = speed, dt = dt })
  end
  -- teleport check: sudden large displacement
  if dist > 200.0 and dt < 2.0 then
    logEvent(src, 'teleport_detect', { dist = dist, dt = dt })
  end
  -- store
  pos_history[src] = { last = now, x = data.x, y = data.y, z = data.z }
end)

-- client requested a weapon (could be legit, but track frequency)
RegisterNetEvent('fivem_scaffold:clientRequestedWeapon')
AddEventHandler('fivem_scaffold:clientRequestedWeapon', function(weaponName)
  local src = source
  incr_rpc(src)
  logEvent(src, 'weapon_request', weaponName)
end)

-- detect suspicious health/godmode
RegisterNetEvent('fivem_scaffold:reportHealth')
AddEventHandler('fivem_scaffold:reportHealth', function(health)
  local src = source
  incr_rpc(src)
  if not health then return end
  if tonumber(health) and tonumber(health) > 200 then
    logEvent(src, 'health_unusual', health)
  end
end)

-- periodic cleanup
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    -- cleanup old pos_history entries
    for k,v in pairs(pos_history) do
      if v.last and (GetGameTimer() - v.last) > (5 * 60 * 1000) then pos_history[k] = nil end
    end
  end
end)
