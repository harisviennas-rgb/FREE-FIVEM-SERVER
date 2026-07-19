-- client/admin.lua (updated with buyItem NUI callback)

local QBCore = nil

Citizen.CreateThread(function()
  if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
  end
end)

-- Open admin panel with F7
RegisterKeyMapping('openAdmin', 'Open Admin Panel (F7)', 'keyboard', 'F7')
RegisterCommand('openAdmin', function()
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'openAdmin' })
end)

-- NUI callbacks -> forward to server
RegisterNUICallback('adminAction', function(data, cb)
  -- data.action, data.target, data.payload
  TriggerServerEvent('fivem_scaffold:adminAction', data)
  cb({ status = 'ok' })
end)

RegisterNUICallback('buyItem', function(data, cb)
  -- data.storeId, data.itemName
  TriggerServerEvent('fivem_scaffold:buyItem', data.storeId, data.itemName)
  cb({ status = 'ok' })
end)

RegisterNUICallback('buyWeapon', function(data, cb)
  TriggerServerEvent('fivem_scaffold:buyWeapon', data.weaponName)
  cb({ status = 'ok' })
end)

RegisterNUICallback('close', function(data, cb)
  SetNuiFocus(false, false)
  cb('ok')
end)

-- Listen for server notifications to show in NUI
RegisterNetEvent('fivem_scaffold:notifyNUI')
AddEventHandler('fivem_scaffold:notifyNUI', function(msg)
  SendNUIMessage({ action = 'notify', message = msg })
end)
