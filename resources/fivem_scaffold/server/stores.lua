-- server/stores.lua (updated)

-- Example store definitions and buy handler
local stores = {
  { id = 'general_1', name = '24/7 Supermarket', coords = { x = 24.5, y = -1347.3, z = 29.5 }, pedModel = 's_m_m_ammucountry', items = { { name = 'bread', label = 'Bread', price = 10 }, { name = 'water', label = 'Water', price = 5 } } },
  { id = 'pharmacy_1', name = 'Pharmacy', coords = { x = 196.3, y = -934.0, z = 30.7 }, pedModel = 's_f_y_cop_01', items = { { name = 'medkit', label = 'Medkit', price = 100 } } }
}

RegisterNetEvent('fivem_scaffold:buyItem')
AddEventHandler('fivem_scaffold:buyItem', function(storeId, itemName)
  local src = source
  local store = nil
  for _, s in ipairs(stores) do if s.id == storeId then store = s end end
  if not store then return end
  local item = nil
  for _, it in ipairs(store.items) do if it.name == itemName then item = it end end
  if not item then return end

  -- QBCore money handling example
  if GetResourceState('qb-core') == 'started' then
    local QBCore = exports['qb-core']:GetCoreObject()
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if xPlayer and xPlayer.PlayerData.money.bank >= item.price then
      xPlayer.Functions.RemoveMoney('bank', item.price, 'store-purchase')
      -- give item via inventory integration (use ox_inventory or qb-inventory integration if present)
      -- Placeholder: Trigger an event that inventory resource should listen for
      TriggerClientEvent('fivem_scaffold:giveItem', src, item.name)
      TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Purchased ' .. item.label)
    else
      TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Not enough money')
    end
  else
    TriggerClientEvent('fivem_scaffold:notifyNUI', src, 'Store is not available (qb-core not installed)')
  end
end)

-- Return stores to requesting client
RegisterNetEvent('fivem_scaffold:requestStores')
AddEventHandler('fivem_scaffold:requestStores', function()
  local src = source
  TriggerClientEvent('fivem_scaffold:returnStores', src, stores)
end)

-- Export stores table for server-side scripts if needed
exports('GetStores', function()
  return stores
end)
