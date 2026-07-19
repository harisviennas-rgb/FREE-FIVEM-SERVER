-- server/admin.lua

local QBCore = nil
local Admins = {}
local bans = {}

CreateThread(function()
  if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
  end
  -- populate admin list from config
  for _, sid in ipairs(Config.AdminSteamIDs) do
    Admins[sid] = true
  end
end)

local function isAdmin(source)
  local identifiers = GetPlayerIdentifiers(source)
  for _, id in ipairs(identifiers) do
    if Admins[id] then return true end
  end
  return false
end

RegisterNetEvent('fivem_scaffold:adminAction')
AddEventHandler('fivem_scaffold:adminAction', function(data)
  local src = source
  if not isAdmin(src) then
    print(('fivem_scaffold: Player %s attempted admin action without permission'):format(src))
    return
  end
  local action = data.action
  local target = tonumber(data.target)
  local payload = data.payload or {}

  if action == 'kick' then
    if target then
      DropPlayer(target, payload.reason or 'Kicked by admin')
    end
  elseif action == 'ban' then
    if target then
      local reason = payload.reason or 'Banned by admin'
      bans[target] = { reason = reason, by = src, time = os.time() }
      DropPlayer(target, reason)
    end
  elseif action == 'tempban' then
    -- store tempban in bans table with expiry
    if target then
      local duration = tonumber(payload.duration) or 3600
      bans[target] = { reason = payload.reason or 'Tempbanned', by = src, time = os.time(), expires = os.time() + duration }
      DropPlayer(target, payload.reason or 'Tempbanned')
    end
  elseif action == 'giveMoney' then
    if target and QBCore then
      local amount = tonumber(payload.amount) or 0
      local xPlayer = QBCore.Functions.GetPlayer(target)
      if xPlayer then
        xPlayer.Functions.AddMoney('bank', amount, 'admin-give')
      end
    end
  elseif action == 'setJob' then
    if target and QBCore then
      local job = payload.job
      local grade = tonumber(payload.grade) or 0
      local xPlayer = QBCore.Functions.GetPlayer(target)
      if xPlayer then
        xPlayer.Functions.SetJob(job, grade)
      end
    end
  elseif action == 'teleport' then
    if target then
      TriggerClientEvent('fivem_scaffold:teleportPlayer', target, payload.coords)
    end
  elseif action == 'spawnVehicle' then
    if target then
      TriggerClientEvent('fivem_scaffold:spawnVehicle', target, payload.model)
    end
  else
    print('Unknown admin action: ' .. tostring(action))
  end
end)

-- Basic ban check on player connect
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
  local src = source
  local ids = GetPlayerIdentifiers(src)
  for id, b in pairs(bans) do
    for _, pid in ipairs(ids) do
      if tostring(pid) == tostring(id) then
        setKickReason('You are banned: ' .. (b.reason or 'No reason'))
        CancelEvent()
        return
      end
    end
  end
end)
