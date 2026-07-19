-- client/weapons_client.lua

RegisterNetEvent('fivem_scaffold:clientGiveWeapon')
AddEventHandler('fivem_scaffold:clientGiveWeapon', function(weaponName)
  local player = PlayerPedId()
  local hash = GetHashKey(weaponName)
  GiveWeaponToPed(player, hash, 250, false, true)
  SetPedAmmo(player, hash, 250)
  -- notify
  SendNUIMessage({ action = 'notify', message = 'Received weapon: ' .. weaponName })
end)
