-- client/skins_client.lua

RegisterNetEvent('fivem_scaffold:applySkin')
AddEventHandler('fivem_scaffold:applySkin', function(skin)
  -- If qb-clothing or qb-skinchanger available, forward via their events
  if GetResourceState('qb-clothing') == 'started' then
    TriggerEvent('qb-clothing:client:loadOutfit', skin)
  else
    -- fallback: try to set ped model if model string provided
    if skin.model then
      local hash = GetHashKey(skin.model)
      RequestModel(hash)
      while not HasModelLoaded(hash) do Citizen.Wait(10) end
      SetPlayerModel(PlayerId(), hash)
      SetModelAsNoLongerNeeded(hash)
    end
  end
end)
