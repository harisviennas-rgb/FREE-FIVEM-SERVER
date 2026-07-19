-- server/shop_npcs.lua
-- Responsible for any server-side NPC config or dynamic adjustments. Currently minimal; exists for future expansion.

-- In this scaffold stores are defined in server/stores.lua and returned to clients on request.

-- Example hook: log when shop purchases happen
AddEventHandler('fivem_scaffold:buyItem', function(storeId, itemName)
  local src = source
  print(('Player %s bought %s from %s'):format(src, tostring(itemName), tostring(storeId)))
  -- Log to DB/natch
  if GetResourceState('oxmysql') == 'started' then
    -- Placeholder: implement logs insertion if desired
  end
end)
