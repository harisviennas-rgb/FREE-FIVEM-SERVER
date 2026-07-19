-- client/talking_marker.lua
-- Draws a red circle under every player who is currently talking (voice active).
-- This runs client-side: each player's game will draw markers for talking players they can 'hear'.

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0) -- run every frame for smooth marker rendering

    local activePlayers = GetActivePlayers()
    for _, player in ipairs(activePlayers) do
      -- NetworkIsPlayerTalking expects a player index (returned by GetActivePlayers)
      if NetworkIsPlayerTalking(player) then
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
          local px, py, pz = table.unpack(GetEntityCoords(ped, true))
          -- draw a slightly imperfect red circle using two overlapping markers to give a 'not perfect' look
          DrawMarker(1, px, py, pz - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.6, 1.6, 0.2, 200, 20, 20, 180, false, false, 2, false, nil, nil, false)
          DrawMarker(25, px + 0.08, py - 0.05, pz - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.2, 220, 30, 30, 120, false, false, 2, false, nil, nil, false)
        end
      end
    end
  end
end)
