-- server/weapons.lua

-- Weapon shop + admin spawn endpoints
local weaponsForSale = {
  { name = 'weapon_pistol', label = 'Pistol', price = 1500 },
  { name = 'weapon_assaultrifle', label = 'Assault Rifle', price = 25000 }
}

RegisterNetEvent('fivem_scaffold:buyWeapon')
AddEventHandler('fivem_scaffold:buyWeapon', function(weaponName)
  local src = source
  if GetResourceState('qb-core') == 'started' then
    local QBCore = exports['qb-core']:GetCoreObject()
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for _, w in ipairs(weaponsForSale) do
      if w.name == weaponName then
        if xPlayer.PlayerData.money.bank >= w.price then
          xPlayer.Functions.RemoveMoney('bank', w.price, 'weapon-purchase')
          TriggerClientEvent('fivem_scaffold:clientGiveWeapon', src, weaponName)
          TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Purchased weapon: ' .. w.label)
        else
          TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Not enough money')
        end
        return
      end
    end
  else
    TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'QBCore not running')
  end
end)

-- Admin weapon spawn
RegisterNetEvent('fivem_scaffold:adminGiveWeapon')
AddEventHandler('fivem_scaffold:adminGiveWeapon', function(target, weaponName)
  TriggerClientEvent('fivem_scaffold:clientGiveWeapon', target, weaponName)
end)
