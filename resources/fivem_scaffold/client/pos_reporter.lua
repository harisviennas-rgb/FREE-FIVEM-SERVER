-- client/pos_reporter.lua
-- Sends periodic position and health updates to the server to support anticheat checks

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000) -- every second
    local ped = PlayerPedId()
    if ped and DoesEntityExist(ped) then
      local x,y,z = table.unpack(GetEntityCoords(ped))
      local health = GetEntityHealth(ped) or 0
      local data = { x = tonumber(x), y = tonumber(y), z = tonumber(z), timestamp = GetGameTimer(), health = tonumber(health) }
      TriggerServerEvent('fivem_scaffold:playerPositionUpdate', data)
      TriggerServerEvent('fivem_scaffold:reportHealth', health)
    end
  end
end)
