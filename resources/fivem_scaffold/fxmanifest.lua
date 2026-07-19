fx_version 'cerulean'

games { 'gta5' }

author 'assistant-scaffold'
description 'FREE-FIVEM-SERVER scaffold: controls, respawn, postal, admin NUI, anticheat, jobs, stores, dealer'
version '0.4.0'

shared_script 'config.lua'

client_scripts {
  'client/main.lua',
  'client/controls.lua',
  'client/admin.lua',
  'client/dealer_client.lua',
  'client/weapons_client.lua',
  'client/emotes.lua',
  'client/shop_client.lua',
  'client/pos_reporter.lua',
  'client/skins_client.lua',
  'client/jobs_client.lua',
  'client/talking_marker.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/admin.lua',
  'server/admin_features.lua',
  'server/anticheat.lua',
  'server/anticheat_hardened.lua',
  'server/anticheat_full.lua',
  'server/stores.lua',
  'server/shop_npcs.lua',
  'server/car_dealer.lua',
  'server/car_persistence.lua',
  'server/weapons.lua',
  'server/skins.lua',
  'server/jobs_police.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/script.js',
  'html/img/logo.png'
}
