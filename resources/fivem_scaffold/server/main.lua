-- server/main.lua
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
  -- log death
  print(('Player %s died, respawn cooldown %s'):format(src, cooldown))
end)

RegisterNetEvent('fivem_scaffold:requestPostal', function(postal)
  local src = source
  postal = tonumber(postal)
  if not postal then return end
  -- placeholder: map postal to coords (simple hash). In next iteration we'll add a real mapping.
  local x = (postal % 100) * 10 - 250
  local y = ((postal // 100) % 100) * 8 - 1000
  local z = 30.0
  TriggerClientEvent('fivem_scaffold:setWaypoint', src, { x = x, y = y, z = z })
end)
