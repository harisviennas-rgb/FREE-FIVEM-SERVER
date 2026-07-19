-- client/dealer_client.lua (expanded to request dealer stock and open NUI)

-- Simple command-based car dealer UI (placeholder). Use /cardealer to open.
RegisterCommand('cardealer', function()
  TriggerServerEvent('fivem_scaffold:requestDealer')
end)

RegisterNetEvent('fivem_scaffold:returnDealer')
AddEventHandler('fivem_scaffold:returnDealer', function(dealer)
  -- transform dealer into store shape understood by NUI
  local store = { id = dealer.id, name = dealer.name, items = {} }
  for _, v in ipairs(dealer.stock or {}) do
    table.insert(store.items, { name = v.model, label = v.label, price = v.price })
  end
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'openStore', store = store })
end)

-- Spawn purchased vehicle (client-side event called after purchase)
RegisterNetEvent('fivem_scaffold:clientSpawnVehicle')
AddEventHandler('fivem_scaffold:clientSpawnVehicle', function(model, plate)
  local player = PlayerPedId()
  local modelHash = GetHashKey(model)
  RequestModel(modelHash)
  local timeout = GetGameTimer() + 5000
  while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do
    Citizen.Wait(50)
  end
  if HasModelLoaded(modelHash) then
    local x, y, z = table.unpack(GetEntityCoords(player))
    local veh = CreateVehicle(modelHash, x + 3.0, y, z, GetEntityHeading(player), true, false)
    SetVehicleNumberPlateText(veh, plate or ('FREE' .. math.random(1000,9999)))
    TaskWarpPedIntoVehicle(player, veh, -1)
  else
    TriggerEvent('fivem_scaffold:notifyNUI', 'Failed to spawn vehicle: model not found')
  end
end)
