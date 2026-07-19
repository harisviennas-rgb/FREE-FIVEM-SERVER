-- client/main.lua
local respawnAllowed = false
local respawnTimer = 0

RegisterCommand('gps', function(source, args)
  local postal = tonumber(args[1])
  if not postal then
    print('Usage: /gps <postal>')
    return
  end
  -- Client-side placeholder: trigger server to resolve postal to coords
  TriggerServerEvent('fivem_scaffold:requestPostal', postal)
end)

RegisterKeyMapping('openmenu', 'Open Main Menu (F3)', 'keyboard', 'F3')
RegisterCommand('openmenu', function()
  -- open main NUI menu
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'openMenu' })
end)

-- Respawn handling
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if respawnTimer > 0 then
      respawnTimer = respawnTimer - 1
      if respawnTimer <= 0 then
        respawnAllowed = true
        -- notify player
        QBCore = QBCore or exports['qb-core']:GetCoreObject()
        if QBCore then
          QBCore.Functions.Notify('You may now press R to respawn.', 'success')
        end
      end
    end
  end
end)

RegisterCommand('respawn', function()
  if respawnAllowed then
    respawnAllowed = false
    respawnTimer = 0
    -- simple respawn: revive and set coords to hospital (placeholder)
    local player = PlayerPedId()
    NetworkResurrectLocalPlayer(307.0, -1430.0, 29.8, true, true, true)
    ClearPedBloodDamage(player)
    SetEntityHealth(player, 200)
  else
    local remaining = respawnTimer
    if remaining > 0 then
      local mins = math.floor(remaining / 60)
      local secs = remaining % 60
      QBCore = QBCore or exports['qb-core']:GetCoreObject()
      if QBCore then
        QBCore.Functions.Notify(('You must wait %s:%02d to respawn.'):format(mins, secs), 'error')
      end
    end
  end
end, false)

RegisterKeyMapping('respawn', 'Respawn (R)', 'keyboard', 'R')
