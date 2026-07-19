-- client/dealer_client.lua was already updated; ensure client/admin.lua listens for returnWeapons and returnDealer
-- Add handlers in client/admin.lua to forward returned lists to NUI

RegisterNetEvent('fivem_scaffold:returnWeapons')
AddEventHandler('fivem_scaffold:returnWeapons', function(weapons)
  SendNUIMessage({ action = 'openWeapons', weapons = weapons })
end)

RegisterNetEvent('fivem_scaffold:returnDealer')
AddEventHandler('fivem_scaffold:returnDealer', function(dealer)
  SendNUIMessage({ action = 'openDealer', dealer = dealer })
end)
