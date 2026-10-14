# Dessert Island v11

## Rewards and economy

- Each of six plots has 60 circular plates: five rows of six per side, following the latest drawing. Native structural parts have Studs on all faces; imported meshes retain their authored geometry.
- Mini desserts follow inward side slopes, the descending center channel and front collection tray. Movement is server-controlled along the slope profile, with bounded counted bundles (120 visible drops per plot); it is not unconstrained rigid-body physics.
- Every displayed dessert produces once per three seconds. Tier values are `3^(tier-1)`: Pudding 1, Custard 3, Strawberry Jelly 9. Nearby pickup adds to the bag; selling at the cafe adds pending cash; R transfers pending cash to the wallet. Shiny does not add an unstated income bonus.
- Buy 1/10/100/1000 costs five cash per pudding and always carries every complete triple. Normal and shiny desserts merge separately. M merges all available triples; tier 30 is the cap. Every discovered intermediate tier is recorded even when a bulk purchase immediately merges it onward.
- Crate overflow remains in the owned inventory. At most 60 desserts are displayed and produce; merge to free plates.
- One normal free credit every **18,000 seconds (5h)**. Premium receives **one normal plus one perk** at the same deadline. First gift is five hours after first profile creation. A missed offline deadline grants one gift on return, then starts a new five-hour cycle; it does not accumulate unlimited missed gifts.
- AFK normal credit is independent: each **18,000 accumulated idle seconds**. Idle begins after 60 seconds without movement/input; active time and offline time do not count. Partial progress persists. Roblox's normal idle-disconnect behavior is not bypassed.
- Normal tier offsets/weights: -4/70%, -3/20%, -2/9%, -1/1%. Perk: -3/40%, -2/30%, -1/20%, current/10%. Lower tiers clamp to 1 and UI combines duplicate outcomes. Shiny odds: normal 1%, perk 10%; eligible luck pass doubles them. UI shows joint tier/variant percentages before opening.
- Permanent production boosts use the highest owned multiplier, without stacking. Money hot time is **2x sale cash for 15 minutes**. Repeated purchases extend the duration.

## Purchases and saves

All product/pass IDs are **0** in `src/shared/TycoonConfig.luau`, so Robux purchases are disabled in both UI and server. Prices are the requested base prices; after real IDs are configured, UI reads regional prices with MarketplaceService. Create the products/passes in this experience's Creator Dashboard before setting IDs. No purchase was made during development.

Permanent boosts, Auto Merge, Magnet and Luck use passes. Hot Time and crate packs use developer products. Receipt rewards and purchase IDs are committed together with DataStore UpdateAsync; callbacks return NotProcessedYet until durably saved. Paid crate credits are separate from free credits and cannot be opened by users whose policy restricts paid random items. Policy lookup failure denies paid random items; luck is disabled for restricted users.

Published servers load/save profiles with a renewable session lock, 60-second autosave and leave/shutdown saves. Studio intentionally uses session data and never overwrites live profiles or grants paid receipts. Live persistence/receipt processing must be validated in a published test experience once IDs exist; they have not been live-tested here.

`DessertIsland` generator and the old `DessertProduction` prototype are disabled in the saved place. Enabled runtime scripts are PlotAllocator and DessertGame; PlayerProfiles is a ModuleScript. StarterPlayerScripts contains DessertClient. Rojo can generate the native map, while the saved place includes the free imported props/templates.

Set the published experience's maximum player count to **6** in Creator Dashboard. The allocator supports six plots and queues any additional Studio players. The central display remains reserved for the user's later model.

## Checks

- Edit-mode `tests/DessertRules.studio.luau`: five-hour boundary, duplicate prevention, synchronized Premium gifts, accumulated AFK, exact odds, bulk auto merge/conservation, shiny discovery, 60 model variants and missing-ID lock.
- Play server `tests/DessertGame.studio.luau`: buy/merge, three-second production, nearby pickup, bag/cafe/R sequence, distance validation, companion, settings and disabled purchases.
- Production slopes checked with downward raycasts: outside edge higher than inside edge on all 60 side ramps.
- Historical v8/v10 layout tests target earlier arrangements and are not current v11 acceptance tests.

The 30 dessert visuals are native procedural starter models with different dessert families, pastel colors and faces. They are replaceable templates, not a purchased 30-model art pack. English HUD, Index, Settings, Shop, Crates and discovery effects use native Roblox UI components; no external UI package is required.

Client regression check: `tests/DessertClient.studio.luau` verifies immediate settings after an activity ping and hiding/restoring another companion while plot floors stay visible.

Storage mock: `tests/PlayerProfiles.studio.luau` checks clock persistence, idempotent grants and a timeout after commit. An uncertain receipt disconnects the player and prevents stale profile saves; rejoin may wait for the old session lease (up to three minutes), then Roblox retries the pending receipt. This mock does not replace published-experience validation.
