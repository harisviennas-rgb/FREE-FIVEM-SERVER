-- server/car_persistence.lua
-- Create vehicle persistence table and endpoints to save/restore vehicles

if GetResourceState('oxmysql') == 'started' then
  exports.oxmysql:execute([[CREATE TABLE IF NOT EXISTS ff_server_player_vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    steam_id VARCHAR(255),
    model VARCHAR(255),
    plate VARCHAR(64),
    stored TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );]], {}, function() end)
end

RegisterNetEvent('fivem_scaffold:savePlayerVehicle')
AddEventHandler('fivem_scaffold:savePlayerVehicle', function(model, plate)
  local src = source
  local ids = GetPlayerIdentifiers(src)
  local steam = ids[1]
  if GetResourceState('oxmysql') == 'started' then
    exports.oxmysql:insert('INSERT INTO ff_server_player_vehicles (steam_id, model, plate, stored) VALUES (?, ?, ?, ?)', { steam, model, plate or '', 1 })
  end
end)

RegisterNetEvent('fivem_scaffold:requestPlayerVehicles')
AddEventHandler('fivem_scaffold:requestPlayerVehicles', function()
  local src = source
  local ids = GetPlayerIdentifiers(src)
  local steam = ids[1]
  if GetResourceState('oxmysql') == 'started' then
    exports.oxmysql:execute('SELECT * FROM ff_server_player_vehicles WHERE steam_id = ?', { steam }, function(rows)
      TriggerClientEvent('fivem_scaffold:returnOwnedVehicles', src, rows)
    end)
  else
    TriggerClientEvent('fivem_scaffold:returnOwnedVehicles', src, {})
  end
end)
