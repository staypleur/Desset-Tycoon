# Dessert Island v16

## Rewards and economy

- Each of six plots has 60 circular plates: five rows of six per side, following the latest drawing. Native structural parts have Studs on all faces; imported meshes retain their authored geometry.
- Mini desserts follow inward side slopes, the descending center channel and front collection tray. Movement is server-controlled along the slope profile, with a strict 100-model limit per plot, including in-transit minis; overflow goes into the owner’s counted AFK basket rather than creating additional moving models; visible production resumes after pickup; it is not unconstrained rigid-body physics.
- Every displayed dessert produces once per three seconds. Tier values are `3^(tier-1)`: Pudding 1, Custard 3, Strawberry Jelly 9. Nearby pickup adds to the bag; the owner's central cafe pad transfers whole units into their private conversion queue. No cash is credited at deposit. Every two seconds, `min(remaining queue, unitsPerSecond * 2)` units become pending bank cash. R transfers that pending cash to the wallet. Shiny does not add an unstated income bonus.
- Conversion capacity is `3^CafeLevel` units per second (levels 0–29), processed in two-second batches. Upgrade cost is `60 * 3^CafeLevel`; pads show the additional per-second capacity and price. At a full queue, each upgrade has a 30-second marginal payback at 1x cash, before travel/collection time. Fractions drain exactly; empty queues never generate cash. Existing purchased levels are retained. Hot time doubles actual batch cash, not capacity.
- Six plots are 128 by 120 studs, at radius 180, with straight 18-stud paths to the central plaza. One hollow cafe reserves `CentralHub.CentralDisplay` for the user's model; place its interior around CentralShop X/Z at floor height 0.85. Each bank has separate collect/upgrade pads. Shop interaction is a hold-E prompt (0.8s); paid products remain disabled until IDs exist. Cafe benches have real Seat instances.
- Purchase and converter-upgrade pads display the owner's affordability: green when wallet cash meets the current price, red otherwise. The server refreshes them on state changes, including spending and collecting. Unowned plots and maxed upgrades use a neutral color. Price and quantity labels accompany color; the underlying server cost/distance/ownership checks remain authoritative. Free Laurel/Tabler icons, original pastel cards, cream outlines, shadows and FredokaOne style the HUD and world bubbles. Flat building signs are removed; physical SHOP/BANK roof letters remain.
- Buy 1 costs 5 and does not merge unless the player owns AutoMerge. Bulk 10/100/1000 costs 48/450/4000 and automatically merges matching triples, preserving all base-tier units and discoveries. M remains manual. Full plates reject a single purchase atomically without charging. Normal and shiny variants merge separately.
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
- Production slopes were checked with downward raycasts in v11: outside edge higher than inside edge on all 60 side ramps. v12 widens those side ramps with the same slope height profile.
- Historical v8/v10/v11 layout tests target earlier arrangements; use `tests/CentralCafe.studio.luau` for current layout and conversion rules.
- `tests/DessertUI.studio.luau` in a fresh Play server checks affordability colors before/after spending, upgrade cost, bubble styling and building sign removal.

The 30 dessert visuals are native procedural starter models with different dessert families, pastel colors and faces. They are replaceable templates, not a purchased 30-model art pack. English HUD, Index, Settings, Shop, Crates and discovery effects use native Roblox UI components; no external UI package is required.

Client regression check: `tests/DessertClient.studio.luau` verifies immediate settings after an activity ping and hiding/restoring another companion while plot floors stay visible.

Storage mock: `tests/PlayerProfiles.studio.luau` checks clock persistence, idempotent grants and a timeout after commit. An uncertain receipt disconnects the player and prevents stale profile saves; rejoin may wait for the old session lease (up to three minutes), then Roblox retries the pending receipt. This mock does not replace published-experience validation.

## Cafe sale market / voice readiness (v14)

The server changes a shared cafe rate every 30 seconds, uniformly selecting a different tenth-step value from 0.5 through 1.5. The cake billboard shows the current rate and countdown using replicated attributes and synchronized server time. On a valid owner deposit, the entire bag (including fractions) is emptied and `bag * current rate` is added to that owner's CafeQueue. The credited queue is locked; future rate changes cannot change existing queued units. Conversion still runs every 2 seconds and bank upgrades still affect its rate. Fractional units and cash are retained, with one decimal displayed for small values. Hot time remains a separate multiplier at conversion.

VoiceChatService is configured for Roblox's default proximity voice using the Audio API. The game does not force microphone activation or bypass Roblox eligibility/consent. The Settings panel reports local voice availability. This local file currently has universe/place IDs 0, so live voice requires a published experience, the Communication voice setting and eligible opted-in accounts. No live voice call was tested.

## Unified presentation and limits (v16)

All game-owned opening panels use the approved ToffeeCraft Pastel Dream FREE PNG atlas. It contains artwork only; interaction code is ours. Stats track actual cash generated into Pending (not wallet transfers), actual mini units collected, and connected play seconds, including save waits. Counters begin at zero for legacy profiles because previous lifetime totals were not recorded.

Approved white fences and street lamps are reused around the plaza and outer path sections, keeping entrance/deposit gaps. Rounded pad bases use one approved union each instead of coplanar Center/Cross/corner pieces.

No automatic rejoin was added, at the user’s request. A temporary ordinary LocalScript test of VirtualUser:CaptureController failed with LocalUser capability missing. VirtualInputManager is an internal Roblox service. No virtual input, external executor or OS macro was installed. At the user’s explicit request, experimental ordinary camera motion is enabled: after 120 seconds without real input, apply a 0.03-degree yaw once per 60 seconds after the normal camera update. The standard camera restores its usual frame afterwards. It does not move the character or send Activity pings. Executing the motion can be tested with the HUD IdleCameraNudges attribute; whether it prevents Roblox’s 20-minute idle kick remains UNVERIFIED. Automatic rejoin is excluded. Voice defaults are enabled, but this unpublished place has PlaceId/GameId zero; live microphone visibility needs the published experience Communication setting and an eligible opted-in account.

## AFK overflow and offline earnings

The physical tray plus in-flight mini models remain capped at 100. Each further three-second producer tick adds its weighted `3^(tier-1) * highest owned production boost` value to persisted AFKStored. The left pink free basket in front of Merge displays AFK Desserts and its count. The right pink basket displays Offline Desserts. Both baskets stay empty, at the user’s latest request; only counter labels represent stored amounts. Only the owner within six studs can move those counters into Bag; the transfer increments TotalMiniCollected once and never credits wallet cash directly. Counts reset when a plot is vacant.

Normal saves and receipt writes record server LastSeen. On successful profile load, before production/actions start, credit `elapsed offline seconds * last saved displayed-pet base value / 3 * 0.5 * current highest owned production boost` into OfflineStored. Use the same sorted 60 slots as the real producers; hidden crate inventory produces neither online nor offline. No upper offline-time cap was imposed. A repeated timestamp credits zero; clock reversal never moves the grant timestamp backward. Existing stored balances persist, and old profiles without LastSeen start the clock now rather than receiving guessed historical earnings. Aborted joins preserve LastSeen. The existing session lock protects against parallel loads. Studio uses throwaway profiles, so durable offline rejoin must be validated in a published experience. The conversion queue remains separate and does not process while offline.

Baskets and their labels are hidden when their stored count is zero. Each appears independently when AFK/offline earnings exist. Owner proximity collection empties its counter and hides it again; the mesh remains empty.

The right HUD displays Shiny purchase chance above the production multiplier: 1% normally, 2% with the active luck entitlement. Crate windows retain their separate 1%/10% chances, doubled by luck.

Bank pads are named Collect Cash and Upgrade. The Shiny and production multiplier cards share a size at the lower right. Crate odds are absent from the default view; Details discloses exact paid random outcomes before purchase. The central cafe has a closed counter and invisible collision barrier; its interior remains decorative.
