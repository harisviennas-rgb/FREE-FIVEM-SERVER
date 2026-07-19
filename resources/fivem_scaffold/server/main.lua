-- server/main.lua (updated)
local QBCore = nil

CreateThread(function()
  if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
  end
end)

RegisterNetEvent('fivem_scaffold:playerDied', function()
  local src = source
  local cooldown = Config.RespawnCooldown or 100
  TriggerClientEvent('fivem_scaffold:setRespawnTimer', src, cooldown)
  print(('Player %s died, respawn cooldown %s'):format(src, cooldown))
end)

RegisterNetEvent('fivem_scaffold:requestPostal', function(postal)
  local src = source
  postal = tonumber(postal)
  if not postal then return end
  -- simple mapping function: this is placeholder; later we can provide a robust postal->coords table
  local x = (postal % 100) * 11 - 300
  local y = ((math.floor(postal / 100)) % 100) * 8 - 1200
  local z = 30.0
  TriggerClientEvent('fivem:setWaypoint', src, x, y)
  TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Waypoint set to postal: ' .. tostring(postal))
end)

-- Teleport / spawn handlers (called from admin.lua via TriggerClientEvent)
RegisterNetEvent('fivem_scaffold:teleportPlayer')
AddEventHandler('fivem_scaffold:teleportPlayer', function(coords)
  local src = source
  if coords and type(coords) == 'table' then
    TriggerClientEvent('fivem_scaffold:clientTeleport', src, coords)
  end
end)

RegisterNetEvent('fivem_scaffold:spawnVehicle')
AddEventHandler('fivem_scaffold:spawnVehicle', function(model)
  local src = source
  TriggerClientEvent('fivem_scaffold:clientSpawnVehicle', src, model)
end)
