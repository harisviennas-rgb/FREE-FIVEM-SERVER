-- server/car_dealer.lua
-- Simple car dealer scaffold: handles purchases, stores vehicles to DB (placeholder)

local oxmysql = GetResourceState('oxmysql') == 'started'

local Dealers = {
  { id = 'downtown', name = 'Downtown Dealer', coords = { x = -56.71, y = -1096.85, z = 26.42 } }
}

RegisterNetEvent('fivem_scaffold:buyVehicle')
AddEventHandler('fivem_scaffold:buyVehicle', function(model, plate)
  local src = source
  local price = 100000 -- placeholder price logic
  if GetResourceState('qb-core') == 'started' then
    local QBCore = exports['qb-core']:GetCoreObject()
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer and xPlayer.PlayerData.money.bank >= price then
      xPlayer.Functions.RemoveMoney('bank', price, 'vehicle-purchase')
      -- persist vehicle to DB if oxmysql available
      if oxmysql then
        exports.oxmysql:insert('INSERT INTO ff_server_player_vehicles (steam_id, model, plate, stored) VALUES (?, ?, ?, ?)', { xPlayer.PlayerData.steam, model, plate or '', 1 })
      end
      TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Vehicle purchased: ' .. model)
    else
      TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Not enough money')
    end
  else
    TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'QBCore not available; cannot complete purchase')
  end
end)

RegisterNetEvent('fivem_scaffold:requestOwnedVehicles')
AddEventHandler('fivem_scaffold:requestOwnedVehicles', function()
  local src = source
  if oxmysql then
    local ids = GetPlayerIdentifiers(src)
    local steam = ids[1]
    exports.oxmysql:execute('SELECT * FROM ff_server_player_vehicles WHERE steam_id = ?', { steam }, function(rows)
      TriggerClientEvent('fivem_scaffold:returnOwnedVehicles', src, rows)
    end)
  else
    TriggerClientEvent('fivem_scaffold:returnOwnedVehicles', src, {})
  end
end)
