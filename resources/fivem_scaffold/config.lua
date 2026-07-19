-- config.lua additions
Config = Config or {}

-- Inventory integration
Config.EnableInventoryIntegration = true -- set to false if you do not use ox_inventory/other

-- Dealer settings
Config.Dealer = {
  defaultPriceMultiplier = 1.0,
  persistenceTable = 'ff_server_player_vehicles'
}

-- Weapons/shop settings
Config.Weapons = {
  enableWeaponShop = true,
  defaultAmmo = 250
}

-- Anticheat tuning
Config.AntiCheat = {
  rpcLimitPerMinute = 200,
  enableAutoBan = false -- keep conservative default
}
