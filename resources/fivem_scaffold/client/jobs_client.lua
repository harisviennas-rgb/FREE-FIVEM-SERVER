-- client/jobs_client.lua

RegisterNetEvent('fivem_scaffold:createJobBlip')
AddEventHandler('fivem_scaffold:createJobBlip', function(coords, label)
  local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
  SetBlipSprite(blip, 60)
  SetBlipDisplay(blip, 4)
  SetBlipScale(blip, 0.9)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString(label or 'Job')
  EndTextCommandSetBlipName(blip)
end)
