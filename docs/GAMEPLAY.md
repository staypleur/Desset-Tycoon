# Dessert Island v16

## Rewards and economy

- Each of six plots has 60 circular plates: five rows of six per side, following the latest drawing. Native structural parts have Studs on all faces; imported meshes retain their authored geometry.
- Mini desserts follow inward side slopes, the descending center channel and front collection tray. Movement is server-controlled along the slope profile, with a strict 100-model limit per plot, including in-transit minis; overflow goes into the owner’s counted AFK basket rather than creating additional moving models; visible production resumes after pickup; it is not unconstrained rigid-body physics.
- Every displayed dessert produces once per three seconds. Tier values are `3^(tier-1)`: Pudding 1, Custard 3, Strawberry Jelly 9. Nearby pickup adds to the bag; the owner's central cafe pad transfers whole units into their private conversion queue. No cash is credited at deposit. Every two seconds, `min(remaining queue, unitsPerSecond * 2)` units become pending bank cash. R transfers that pending cash to the wallet. Shiny does not add an unstated income bonus.
- Conversion capacity is `3^CafeLevel` units per second (levels 0–29), processed in two-second batches. Upgrade cost is `20 * 4^CafeLevel`: $20, $80, $320, $1,280, $5,120. Pads show additional capacity and price. At a full queue and 1x cash, marginal payback grows from 10 seconds to about 13.3, 17.8 and 23.7 seconds; production, travel and collection can take longer. One starter pudding produces the first $20 in 60 seconds at the average 1x cafe rate, before travel. Fractions drain exactly; empty queues never generate cash. Existing purchased levels are retained. Hot time doubles actual batch cash, not capacity.
- Six plots are 128 by 120 studs, at radius 180, with straight 18-stud paths to the central plaza. One hollow cafe reserves `CentralHub.CentralDisplay` for the user's model; place its interior around CentralShop X/Z at floor height 0.85. Each bank has separate collect/upgrade pads. Shop interaction is a hold-E prompt (0.8s); paid products remain disabled until IDs exist. Cafe benches have real Seat instances.
- Purchase and converter-upgrade pads display the owner's affordability: green when wallet cash meets the current price, red otherwise. The server refreshes them on state changes, including spending and collecting. Unowned plots and maxed upgrades use a neutral color. Price and quantity labels accompany color; the underlying server cost/distance/ownership checks remain authoritative. Free Laurel/Tabler icons, original pastel cards, cream outlines, shadows and FredokaOne style the HUD and world bubbles. Flat building signs are removed; physical SHOP/BANK roof letters remain.
- Buy 1 costs 5 and does not merge unless the player owns AutoMerge. Bulk 10/100/1000 costs 48/450/4000 and automatically merges matching triples, preserving all base-tier units and discoveries. M remains manual. Full plates reject a single purchase atomically without charging. Normal and shiny variants merge separately.
- Crate overflow remains in the owned inventory. At most 60 desserts are displayed and produce; merge to free plates.
- One normal free credit every **18,000 seconds (5h)**. Premium receives **one normal plus one perk** at the same deadline. First gift is five hours after first profile creation. A missed offline deadline grants one gift on return, then starts a new five-hour cycle; it does not accumulate unlimited missed gifts.
- Connected-play credit: each **10,800 saved online seconds (3h)** gives one Normal crate, plus one Perk crate if Premium at the boundary. Active and idle connected time count; offline time does not. Partial progress persists in the existing AFKSeconds field.
- Both crate types use 40/30/20/10% bucket weights. Normal caps are highest minus 4/3/2/1; Perk caps are highest minus 3/2/1/0. Each selected bucket draws uniformly from tier 1 through its cap, clamped to at least 1. Details combines overlapping buckets into joint tier/variant outcomes. Shiny base chance is 1% for every Buy quantity and Normal crates, 10% for Perk crates. Duplicate shiny desserts remain obtainable.
- Production and shiny multipliers unlock sequentially and replace the previous multiplier. Only the next tier appears; the server rejects skipped tiers. Same-server friends add 3 percentage points after purchased luck, or 5 if either player in a friendship pair is Premium. Multiple friends do not stack. Friend lookup runs on joins; cached pairs never yield in the game loop.
- Production tiers: 1.2x/9 R$, 1.5x/39, 2x/89, 3x/169, 4x/279, 5x/429. Luck: 1.2x/39, 1.5x/89, 2x/189. AutoMerge/299, DessertMagnet/199, MoneyMagnet/199. Speed: 1.2x/5, 1.5x/15, 2x/28, 3x/49; sequential like production/luck. Highest contiguous owned speed applies to base WalkSpeed 16, including respawns. Crates Normal1/9, Normal10/69, Perk1/29, Perk10/269. HotTime remains a legacy receipt product, absent from the current shop.
- DessertMagnet automatically collects only its owner's mini drops and AFK/offline balances. New production directly credits the owner's bag without allocating moving models. MoneyMagnet transfers only its owner's pending bank cash automatically; it never skips the conversion queue.

## Purchases and saves

All product/pass IDs are **0** in `src/shared/TycoonConfig.luau`, so Robux purchases are disabled in both UI and server. Prices are the requested base prices; after real IDs are configured, UI reads regional prices with MarketplaceService. Create the products/passes in this experience's Creator Dashboard before setting IDs. No purchase was made during development.

Permanent boosts, Auto Merge, the two magnets, luck and speed use passes. Hot Time and crate packs use developer products. Receipt rewards and purchase IDs are committed together with DataStore UpdateAsync; callbacks return NotProcessedYet until durably saved. Paid crate credits are separate from free credits and cannot be opened by users whose policy restricts paid random items. Policy lookup failure denies paid random items; luck is disabled for restricted users.

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

The right HUD displays the actual shiny purchase chance above the production multiplier, including bought luck and the current nonstacking friend bonus. Crate Details uses the same modifiers with its 1%/10% bases.

Bank pads are named Collect Cash and Upgrade. The Shiny and production multiplier cards share a size at the lower right. Crate odds are absent from the default view; Details discloses exact paid random outcomes before purchase. The central cafe has a closed counter and invisible collision barrier; its interior remains decorative.

New profiles start with zero cash and one free pudding. Existing saved cash is preserved. Cafe has exactly twelve pink dessert stands and three filled displays. Bank doors face into each plot; the BANK roof lettering retains its previous world position and orientation.

Click an indexed dessert's Equip button to attach its companion. The button becomes Unequip; clicking it again clears the saved selection and removes the companion. Players can walk without a companion while their plot desserts keep producing. Selecting another indexed dessert switches companions.

Background Music and Sound Effects have independent 0–100% sliders plus 5% decrement/increment buttons. Drag previews immediately and commits on release; rapid button changes are coalesced. Settings are validated/clamped on the server and saved in the profile. Legacy OFF settings migrate to 0%; defaults are 40% music / 50% effects. Music pauses at 0% and resumes its position when raised. Only this game's background music, click and discovery sounds change; voice and visual transfer effects are unaffected. Music uses approved Smooth Focus Rain Melody.

A visible Microphone button sits before Settings and Profile, reusing Roblox built-in MicLight textures from the requested reference. It binds only the local player's existing AudioDeviceInput and toggles Muted only on an explicit click. No microphone stream or platform permission is created. Studio and unavailable inputs show a muted icon and a status tooltip. Actual voice remains dependent on published experience Communication settings and eligible users. Prices use English Robux; wallet cash remains $0 with the symbol in front.

Normal and Perk crates occupy one centered row, Normal on the left and Perk on the right. Each card places Details below its art, with Open 1 on the left and Open 10 on the right. Free/paid credits are consumed server-side; without credits the same buttons prompt configured purchases. Missing IDs disable paid actions. Details expands exact outcome odds only when requested. Supplied art includes all 23 PNGs, including the multiplier HUD arrow.

The user-provided cafe chef is a single 3,165-triangle rigged mesh, scaled to 8 studs with a foot-center pivot. One server walker uses the imported Walking clip, an anchored non-colliding mesh and a navigation graph built once from actual cafe decorations, including non-queryable props. Destinations stay within a 20-stud interior radius, routes avoid shelves/flowers/counters, and brief pauses alternate with walking. This NPC has no economy actions or player interaction.

Current chef tuning: height 8 studs, travel speed 6 studs/sec, walking animation speed 1.15, heading turn 0.12 seconds. Navigation clearance and obstacle height derive from the chef mesh size.


## Supplied dessert variants, image index and crate reveal (2026-10-15)
Milky Pudding and Galaxy Aurora Pudding are separate tier-one shiny variants, selected 50:50 after a shiny roll. Legacy `1s` saves remain Milky Pudding; `1s2` identifies Galaxy. Inventory, discovery, equipment and matching merges preserve variant identity. The supplied normal Custard and Mini Custard replace tier-two starter art.

Index cards use one transparent image atlas, without 3D scenes or per-card animations. Their images fit within a clipped inset above the name/button. Large unknown question marks are centered in the green card. The heading follows the center of the actual pink artwork, and the responsive grid stays inside its scroll bounds. Higher desserts reuse approved generic artwork until their reference images are supplied.

New discoveries show one temporary, gently floating 3D model with fixed facing and the existing star/heart celebration. Crates show a horizontal train carousel and fixed arrow, stopping on the server-granted result. Known cards use images; unknown cards remain question marks until revealed. Ten opens play sequentially and can skip to the result summary without changing grants.

Producer slots fill entrance-view right row one, left row one, right row two, left row two, and so on. Pad footprints detect grounded landings as well as direct contacts, accommodating decorative floor layers. Standing stays latched; each real jump re-arms a single purchase upon landing. Purchases remain server-authoritative.

Join Group opens a confirmation and the native Roblox join prompt for Cosmon Studio (203626899). Existing members are also eligible once. Server verification grants one free Perk Crate credit, with the receipt saved atomically to prevent duplicates after retries or rejoining. Pending approval/cancel/error does not grant. Membership propagation may delay confirmation by about a minute. Studio does not submit a real account join; live joining and durable storage need the published experience.


## Highest-tier-first production and custard shinies
Production now sorts tiers descending before applying the shared 60-model limit. The highest tiers occupy the front slots, continuing right row one, left row one, right row two, left row two. Offline production uses this same ordering. Index catalog order remains tier order.
Tier-two shiny rolls now choose Rainbow Cotton Candy Custard (`2s`) or Dark Choco Custard (`2s2`) with equal conditional probability. Existing shiny keys and merges keep their variant identity; both have distinct models and index images.
Pad activation uses a consistent home-space footprint and leave/re-enter hysteresis. A jump re-arms only after upward airborne separation with positive vertical speed; ordinary walking and limb contacts do not re-arm. Press tweens cancel and restart from a fixed home CFrame, then restore it, preventing cumulative sinking and disappearance of the colored top.


### Tier-three jelly variants
Strawberry Jelly uses the supplied normal/mini models. Conditional shiny rolls select Strawberry Mint Sherbet Jelly (3s) or Strawberry Mint Ruby Crystal Jelly (3s2) equally. Existing 3s saves retain their counts and now render as Sherbet Jelly; merges preserve variant lineage. Each variant has separate discovery, ownership and equipment identity, with 2D index/carousel art and fixed-facing floating 3D discovery presentation. Shiny minis reuse the supplied face-free MiniJelly with the existing gold treatment until distinct mini variants are provided.

### Tier-four Shortcake update
Tier 4 is Shortcake. Galaxy Aurora Shortcake (4s) and Rainbow Unicorn Shortcake (4s2) split shiny rolls 50:50, with separate inventory/index/equip identities and matching merge lineage. Existing tier-four counts stay intact. Index/roulette use transparent images; discovery keeps the single floating 3D model and approved star/heart effects. MiniShortcake uses the existing guided physical-drop system.

### Tier-five Macaron update
Tier 5 is Macaron. Crystal Gem Macaron (5s) and Pink Gold Dark Macaron (5s2) split conditional shiny rolls 50:50. Ownership, discovery, equipment and merge lineage remain separate. Existing tier-five counts are preserved. Transparent index/roulette images and fixed-facing floating 3D discovery reuse the existing presentation; MiniMacaron uses the guided physical-drop system.
### Tier-six Croissant update
Tier 6 is Croissant. Galaxy Crescent Croissant (6s) and Pink Quartz Rose Gold Croissant (6s2) split conditional shiny rolls 50:50, with separate inventory, index and equipment identities. Macaron merges preserve the shiny lineage. Existing tier-six counts remain intact. Index and roulette use transparent images; discovery uses one floating, fixed-facing native model. MiniCroissant uses the guided physical-drop system.

### Tier-seven Waffle update
Tier 7 is Waffle. Cotton Candy Unicorn Waffle (7s) and Pink Dark Choco Honey Waffle (7s2) split conditional shiny rolls 50:50. Croissant merges preserve variant lineage; ownership, index and equipment identities are separate. Existing tier-seven counts remain intact. Index and roulette use transparent images; discovery retains one floating, fixed-facing 3D model with approved star/heart effects. MiniWaffle uses guided physical drops.

### Tier-eight Patbingsu update
Tier 8 is Patbingsu. Extra Red Bean Bingsu (8s) and Mango Bingsu (8s2) split conditional shiny rolls 50:50. Waffle merges preserve variant lineage; ownership, discovery and equipment remain separate. Existing tier-eight counts remain intact. Transparent index/roulette images and one floating, fixed-facing 3D discovery model use existing presentation. MiniBingsu uses guided physical drops.

### Tier-nine Tiramisu Cake update
Tier 9 is Tiramisu Cake. Prism Cube Tiramisu Cake (9s) and Pink Quartz Rose Gold Tiramisu Cake (9s2) split conditional shiny rolls 50:50. Patbingsu merges preserve variant lineage; ownership, discovery and equipment remain separate. Existing tier-nine counts remain intact. Transparent index/roulette images and one floating, fixed-facing 3D discovery model retain existing presentation. MiniTiramisu uses guided physical drops.

- Tier 10 is Madeleine: normal, Pearl Prism Madeleine (10s), Mint Ocean Crystal Madeleine (10s2). Shiny selection splits 50:50 conditional on a shiny roll; separate inventory/equip/discovery identities, tier-nine merge lineage and image-only index/roulette. Production uses the MiniMadeleine template; higher tiers retain front-row priority.

- Tier 11 is Eclair: normal, Pink Quartz Rose Gold Eclair (11s), Galaxy Aurora Eclair (11s2). Conditional shiny split is 50:50, with separate inventory/equip/discovery and tier-ten merge lineage. Index and roulette use transparent 2D art; mini production uses MiniEclair. Higher tiers retain front-row priority.

- Tier 12 is Panna Cotta: normal, Ruby Strawberry Panna Cotta (12s), Mint Ocean Crystal Panna Cotta (12s2). Conditional shiny split is 50:50, with separate ownership/equip/discovery and tier-eleven merge lineage. Index and roulette use transparent 2D art; mini production uses MiniPannaCotta. Higher tiers retain front-row priority.

- Tier 13 is Souffle Pancake: normal, Sakura Souffle Pancake (13s), Black Hole Choco Souffle Pancake (13s2). Conditional shiny split is 50:50, with separate ownership/equip/discovery and tier-twelve merge lineage. Index and roulette use transparent 2D art; mini production uses MiniSouffle. Higher tiers retain front-row priority.

- Tier 14 is Wagashi: normal, Mint Emerald Crystal Wagashi (14s), Dark Choco Gold Wagashi (14s2). Conditional shiny split is 50:50, with separate ownership/equip/discovery and tier-thirteen merge lineage. Index and roulette use transparent 2D art; mini production uses MiniWagashi. Higher tiers retain front-row priority.

### Tier 15 and 16 user desserts
- Tier 15: Cheesecake; shiny variants Ruby Blueberry Cheesecake and Mint Ocean Emerald Cheesecake.
- Tier 16: Financier; shiny variants Pure Gold Financier and Pink Quartz Financier.
- Each tier has a dedicated miniature, normal character and two independent shiny identities. Conditional on a shiny result, each variant has 50% probability; the overall shiny chance is unchanged. Merge lineage, equip, discovery and crate results preserve the exact identity.
- Index and crate art use transparent 2D atlases; discovery keeps one fixed-facing floating 3D preview.
