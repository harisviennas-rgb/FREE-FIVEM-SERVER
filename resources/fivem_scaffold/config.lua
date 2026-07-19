-- config.lua
Config = {}

Config.AdminSteamIDs = {
  'steam:76561198673222869' -- your SteamID (prefixed with steam: for QBCore)
}

Config.RespawnCooldown = 100 -- seconds
Config.EnableAutoBan = false -- scaffold: must be configured

-- Keybinds
Config.Keybinds = {
  inventory = 288, -- F2
  menu = 170,      -- F3
  crouch = 20,     -- Z
  respawn = 45     -- R
}

-- Postal settings
Config.MaxPostal = 10000
