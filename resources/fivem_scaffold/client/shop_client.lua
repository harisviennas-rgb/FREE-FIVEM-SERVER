-- client/shop_client.lua

local stores = {}
local storePeds = {}

-- Helper to draw 3D text
local function DrawText3D(x, y, z, text)
  SetDrawOrigin(x, y, z, 0)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextScale(0.35, 0.35)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry('STRING')
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end

-- Request stores from server on load
Citizen.CreateThread(function()
  TriggerServerEvent('fivem_scaffold:requestStores')
end)

RegisterNetEvent('fivem_scaffold:returnStores')
AddEventHandler('fivem_scaffold:returnStores', function(s)
  stores = s or {}
  -- spawn peds and blips
  for _, store in ipairs(stores) do
    Citizen.CreateThread(function()
      local model = store.pedModel or 'a_m_m_aldinapoli'
      local hash = GetHashKey(model)
      RequestModel(hash)
      local t0 = GetGameTimer() + 5000
      while not HasModelLoaded(hash) and GetGameTimer() < t0 do Citizen.Wait(10) end
      if HasModelLoaded(hash) then
        local ped = CreatePed(4, hash, store.coords.x, store.coords.y, store.coords.z - 1.0, 0.0, false, false)
        SetEntityHeading(ped, 0.0)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        FreezeEntityPosition(ped, true)
        table.insert(storePeds, { ped = ped, store = store })
      end
    end)
  end
end)

-- Draw markers and detect E press
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local playerPed = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(playerPed))
    for _, entry in ipairs(storePeds) do
      local s = entry.store
      local sx, sy, sz = s.coords.x, s.coords.y, s.coords.z
      local dist = #(vector3(px,py,pz) - vector3(sx,sy,sz))
      if dist < 20.0 then
        DrawMarker(1, sx, sy, sz - 1.0, 0,0,0, 0,0,0, 1.0,1.0,0.3, 255, 165, 0, 120, false, false, 2, false, nil, nil, false)
      end
      if dist < 2.0 then
        DrawText3D(sx, sy, sz + 1.0, '[E] Enter ' .. s.name)
        if IsControlJustReleased(0, 38) then -- E
          SetNuiFocus(true, true)
          SendNUIMessage({ action = 'openStore', store = s })
        end
      end
    end
  end
end)

-- Receive purchase success notifications from server (via notifyNUI event) handled globally in admin NUI
