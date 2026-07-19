# FREE-FIVEM-SERVER — Initial scaffold

This repository contains a paste-and-run scaffold for a FiveM server using QBCore-style resources.

What this initial commit includes:
- Basic resource scaffold (fivem_scaffold) with client/server/config files.
- Admin panel NUI scaffold (black & orange theme placeholders).
- Respawn/death handler with 100s cooldown and R to respawn.
- Keybinds mapping (F2 inventory, F3 menu, Z crouch).
- /gps <postal> command and postal system (0-10000).
- jobs.json with 50 example jobs.
- README installation steps and server.cfg.example.
- config/admin.lua prepopulated with your SteamID as owner (76561198673222869).

Important: This is a scaffold. You must install QBCore (or ESX) and recommended libraries (ox_inventory, ox_lib, ghmattimysql) separately. See README for instructions.

Next steps after cloning/pasting:
1. Install QBCore and dependencies.
2. Copy the `resources/fivem_scaffold` folder into your server's resources directory (or paste the whole repo as a resource).
3. Add `ensure fivem_scaffold` to server.cfg and configure database credentials in `config.lua`.
4. Replace `logo.png` in `html/img/` with your provided transparent PNG.

I'll follow up by adding more features and wiring the admin NUI after you verify this commit. If you'd like, I can add the provided logo image into the repo — confirm and I will commit it in a follow-up update.
