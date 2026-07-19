-- client/controls.lua
-- Crouch, inventory F2, etc.
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustReleased(0, 288) then -- F2
      -- Open inventory (integrate with ox_inventory or qb-inventory)
      TriggerEvent('inventory:open')
    end
    if IsControlJustReleased(0, 170) then -- F3
      SetNuiFocus(true, true)
      SendNUIMessage({ action = 'openMenu' })
    end
    if IsControlJustReleased(0, 20) then -- Z
      -- toggle crouch (placeholder)
      TriggerEvent('animation:crouch')
    end
  end
end)
