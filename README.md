# README — Expanded install / paste-and-run guide

This scaffold aims to be as close to a "paste everything and it works" package as possible for a QBCore-based FiveM server. Read carefully.

1) Requirements
- FXServer (FiveM)
- QBCore (recommended) installed in resources and ensured in server.cfg
- ox_lib, ox_inventory or another inventory resource (optional, scaffold integrates with these if present)
- MySQL server + ghmattimysql or oxmysql resource

2) Quick paste-and-run steps
- Copy the entire repository (or the `resources/fivem_scaffold` folder) into your FXServer `resources/` directory.
- Ensure QBCore and dependencies are installed (see their docs). The scaffold expects QBCore; if you use ESX, request a conversion.
- Add to your server.cfg (or keep server.cfg.example as a reference):
    ensure qb-core
    ensure ox_lib
    ensure ox_inventory
    ensure ghmattimysql
    ensure fivem_scaffold
- Create a database and run the SQL in `resources/fivem_scaffold/sql/schema.sql`.
- Edit `resources/fivem_scaffold/config.lua` and set your admin SteamIDs, DB settings as needed.
- Start server. Open your FiveM client and join the server.

3) Controls
- F2: Inventory open (integrates with your inventory resource if present)
- F3: Main menu (placeholder NUI)
- F7: Admin panel (open; if you are in Config.AdminSteamIDs you will have access)
- Z: Crouch (placeholder)
- R: Respawn when allowed after death (100s cooldown)
- /gps <postal>: Set GPS to postal (postal 0-10000)

4) Admin Panel
- Press F7 to open the admin NUI. It provides player management, economy actions, teleport/spawn, and job assignments.
- The admin list is set in config.lua (steam:... identifiers). The scaffold uses simple identifier matching for admin checks.

5) Anti-cheat
- The scaffold includes a basic anticheat skeleton with logging and a safe default (auto-ban disabled). Configure `Config.EnableAutoBan = true` only after testing.

6) Vehicles / Weapons / Assets
- Custom vehicles and weapon models are NOT included. Add any custom car/weapon resource folders under `resources/` and ensure them in server.cfg.

7) Next steps I can do for you
- Integrate real postal->coords mapping
- Flesh out job scripts (deliveries, missions)
- Add car dealer UI and stock management
- Add dances/props resource and keybinds
- Enhance anticheat detectors and add admin review workflow

If you want me to continue building more features now, reply and I'll implement them on the `feat/full-server-scaffold` branch.
