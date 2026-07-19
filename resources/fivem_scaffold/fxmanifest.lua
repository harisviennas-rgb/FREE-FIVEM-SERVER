fx_version 'cerulean'

games { 'gta5' }

author 'assistant-scaffold'
description 'FREE-FIVEM-SERVER scaffold: controls, respawn, postal, admin NUI, anticheat, jobs, stores'
version '0.2.0'

shared_script 'config.lua'

client_scripts {
  'client/main.lua',
  'client/controls.lua',
  'client/admin.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/admin.lua',
  'server/anticheat.lua',
  'server/stores.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/script.js',
  'html/img/logo.png'
}
