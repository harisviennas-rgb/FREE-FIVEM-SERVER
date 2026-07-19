-- client/emotes.lua

-- Basic emote toggles (uses dpEmotes or built-in animations if available)
RegisterCommand('emotes', function()
  -- open a simple emote menu (placeholder)
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'openEmotes' })
end)

RegisterNetEvent('fivem_scaffold:doEmote')
AddEventHandler('fivem_scaffold:doEmote', function(dict, anim)
  local ped = PlayerPedId()
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
  TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end)
