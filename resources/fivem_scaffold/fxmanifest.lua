fx_version 'cerulean'
games { 'gta5' }

author 'assistant-scaffold'
description 'FREE-FIVEM-SERVER scaffold: controls, respawn, postal, admin NUI'
version '0.1.0'

shared_script 'config.lua'

client_scripts {
  'client/main.lua',
  'client/controls.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/style.css',
  'html/script.js',
  'html/img/logo.png'
}
