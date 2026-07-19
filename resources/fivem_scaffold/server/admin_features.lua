-- server/admin_features.lua
-- Large admin features registry and handler skeleton. This file defines many admin actions and exposes an RPC

local features = {
  -- core
  "kick","ban","tempban","giveMoney","removeMoney","setJob","setJobGrade","teleport","teleportHere","bring","goto",
  "spawnVehicle","deleteVehicle","repairVehicle","flipVehicle","saveVehicle","unsaveVehicle","setVehicleFuel","setVehicleOwner",
  -- economy
  "giveBank","giveCash","setBank","setCash","giveBlackMoney","setBlackMoney","taxPlayer","announce","setSalary",
  -- players
  "freeze","unfreeze","spectate","stoptSpectate","revive","heal","setHealth","setArmor","setModel","setSkin",
  "wipeInventory","giveItem","removeItem","setVIP","removeVIP","setRank","resetPlayer","wipePlayerData",
  -- world
  "setWeather","setTime","addPoliceAlert","clearAlerts","setGravity","spawnObject","deleteObject",
  -- moderation
  "viewLogs","exportLogs","clearLogs","warnPlayer","clearWarnings","tempMute","mute","unmute",
  -- economy tools
  "addShopItem","removeShopItem","setShopPrice","listShopItems","addDealerStock","removeDealerStock",
  -- jobs
  "createJobBlip","removeJobBlip","setJobPay","giveJobVehicle","revokeJobVehicle",
  -- anti-cheat
  "banForCheat","tempbanForCheat","flagPlayer","viewCheatLogs","toggleAutoBan","setAutoBanThreshold",
  -- misc
  "spawnPed","deletePed","teleportToWaypoint","setWaypointForPlayer","openInventoryForPlayer","forceRespawn",
  -- debug
  "toggleGodMode","showPlayerCoords","copyPlayerCoords","teleportToCoords","setPlayerPermissionLevel",
}

-- expose features list
exports('GetAdminFeatures', function() return features end)

-- helper to run feature by name; maps well-known actions to existing handlers
RegisterNetEvent('fivem_scaffold:runAdminFeature')
AddEventHandler('fivem_scaffold:runAdminFeature', function(data)
  local src = source
  local callerIds = GetPlayerIdentifiers(src)
  -- simple admin check using Config.AdminSteamIDs
  local allowed = false
  for _, id in ipairs(callerIds) do
    for _, adm in ipairs(Config.AdminSteamIDs or {}) do
      if tostring(id) == tostring(adm) then allowed = true end
    end
  end
  if not allowed then
    print(('Unauthorized admin feature attempt by %s'):format(src))
    return
  end
  local feature = data.feature
  local target = data.target
  local payload = data.payload or {}

  -- route known feature names to handlers
  if feature == 'kick' then
    if target then DropPlayer(tonumber(target), payload.reason or 'Kicked by admin') end
  elseif feature == 'ban' then
    if target then
      TriggerEvent('fivem_scaffold:adminAction', { action = 'ban', target = tostring(target), payload = { reason = payload.reason } })
    end
  elseif feature == 'giveMoney' or feature == 'giveBank' then
    if target and tonumber(payload.amount) and GetResourceState('qb-core') == 'started' then
      local QBCore = exports['qb-core']:GetCoreObject()
      local xPlayer = QBCore.Functions.GetPlayer(tonumber(target))
      if xPlayer then xPlayer.Functions.AddMoney('bank', tonumber(payload.amount), 'admin-give') end
    end
  elseif feature == 'spawnVehicle' then
    if target and payload.model then
      TriggerClientEvent('fivem_scaffold:clientSpawnVehicle', tonumber(target), payload.model)
    end
  elseif feature == 'giveItem' then
    if target and payload.item then
      if GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local xPlayer = QBCore.Functions.GetPlayer(tonumber(target))
        if xPlayer then xPlayer.Functions.AddItem(payload.item, tonumber(payload.count) or 1)
        end
      else
        TriggerClientEvent('fivem_scaffold:notifyNUI', tonumber(target), 'Server: cannot give item - QBCore missing')
      end
    end
  elseif feature == 'setSkin' or feature == 'setModel' then
    if target and payload.model then
      TriggerClientEvent('fivem_scaffold:setPlayerModel', tonumber(target), payload.model)
    end
  else
    print(('Admin feature invoked but not implemented: %s'):format(tostring(feature)))
    TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Feature ' .. tostring(feature) .. ' is not yet implemented.')
  end
end)
