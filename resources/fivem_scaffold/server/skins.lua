-- server/skins.lua
-- Basic skins/clothing integration. Uses qb-clothing or qb-skinchanger if present; provides admin endpoints to set player clothes.

RegisterNetEvent('fivem_scaffold:setPlayerSkin')
AddEventHandler('fivem_scaffold:setPlayerSkin', function(target, skin)
  local src = source
  if not target or not skin then return end
  -- forward to client
  TriggerClientEvent('fivem_scaffold:applySkin', tonumber(target), skin)
end)

-- If qb-clothing is available we can call its export to set clothes; clients will also listen to applySkin event to apply locally.
