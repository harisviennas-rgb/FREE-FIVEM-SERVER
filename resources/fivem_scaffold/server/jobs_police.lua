-- server/jobs_police.lua
-- Very simple police job flow: create a blip and a sample mission to escort NPC.

local policeCoords = { x = 440.0, y = -975.0, z = 30.8 }

RegisterNetEvent('fivem_scaffold:initPoliceJob')
AddEventHandler('fivem_scaffold:initPoliceJob', function()
  local src = source
  -- give player a blip (client-side)
  TriggerClientEvent('fivem_scaffold:createJobBlip', src, policeCoords, 'Police HQ')
end)

RegisterNetEvent('fivem_scaffold:policeStartPatrol')
AddEventHandler('fivem_scaffold:policeStartPatrol', function()
  local src = source
  TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Police patrol started (placeholder mission)')
  -- more complex missions can be added here
end)
