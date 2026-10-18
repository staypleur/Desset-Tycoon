# Dessert Tycoon release

Published 2026-10-18, place version 4.

- Owner: Cosmon Studio, group 203626899.
- Universe: 10771069736; start place: 98510499854486.
- Current title: [BETA] Dessert Tycoon. Existing owner-edited description and icon retained.
- Access: Public; group-members-only restriction disabled. Creator Dashboard currently permits players aged 16+. Under-16 reach remains subject to Roblox's review; identity, 2FA, content review and Kids/Select fee show completed. Refund date shown: 2027-01-13. No additional fee was paid.
- Game icon and promotional thumbnails are managed by the owner. All monetization images reuse the approved existing UI art.
- Server capacity corrected from the default 50 to 6 players, matching the six personal plots. Existing Roblox-optimized social slots retained.

## Permanent passes

Prices below are configured base prices. Roblox may return a different regional price; the game obtains displayed prices through MarketplaceService.GetProductInfoAsync.

| Key | Pass ID | Base Robux |
| --- | --- | ---: |
| Boost12 | 2036222705 | 9 |
| Boost15 | 2038304654 | 39 |
| Boost2 | 2039546504 | 89 |
| Boost3 | 2036384677 | 169 |
| Boost4 | 2036756633 | 279 |
| Boost5 | 2037410662 | 429 |
| AutoMerge | 2039846451 | 299 |
| DessertMagnet | 2036924694 | 199 |
| MoneyMagnet | 2036996679 | 199 |
| Luck12 | 2036618669 | 39 |
| Luck15 | 2038292663 | 89 |
| Luck2 | 2039894464 | 189 |
| Speed12 | 2036576724 | 5 |
| Speed15 | 2036444654 | 15 |
| Speed2 | 2037122701 | 28 |
| Speed3 | 2036222715 | 49 |

Progression passes require preceding tiers; multipliers do not multiply together. Server ownership queries determine benefits. Paid random-item policy restrictions disable paid crates and luck passes where required.

## Repeatable products

| Key | Product ID | Base Robux | Grant |
| --- | --- | ---: | --- |
| Normal1 | 3718782799 | 9 | 1 paid normal crate token |
| Normal10 | 3718783210 | 69 | 10 paid normal crate tokens |
| Perk1 | 3718783337 | 29 | 1 paid perk crate token |
| Perk10 | 3718783430 | 269 | 10 paid perk crate tokens |
| HotTime | 3718783865 | 19 | 15 minutes of 2x cafe cash; repeat purchases extend duration |

ProcessReceipt writes reward and purchase ledger atomically before acknowledging a purchase. Missing players, closing profiles and unknown products remain pending. Uncertain commits cannot be overwritten by stale saves; reconnect and retry recover without duplicate grants.

## Verification

- MarketplaceService returned all 21 real IDs on sale with nonzero image asset IDs; all 16 passes report Cosmon Studio as creator. Developer products were verified in this universe's dashboard.
- tests/Monetization.studio.luau passed against the actual server receipt handler with a mock DataStore: all five mappings, exact token counts, duplicate and reconnect safety, hot-time extension, unknown/missing/closing receipts, timeout-after-commit recovery, pass prerequisites and nonstacking multipliers.
- All 35 game sources compile and match the source tree. 123 model templates remain; no foreign scripts, PackageLinks or temporary test scripts in the saved place.
- Studio Play rendered the English HUD, dark-green tutorial marker and existing shop art. Studio profiles do not write production saves or grant paid receipts.
- Chef animation 79831780716711 was granted use by universe 10771069736. AnimationClipProvider then loaded its KeyframeSequence with 27 children successfully.
- Studio confirmed PublishSuccessful and published place version 4. No real Robux payment was performed.


2026-10-18 17:41 KST: published version 8 with the requested UI, balance, preview, repeatable reset and saved idle-reconnect patch. See WORKLOG for test evidence and the unverified published 18-minute reconnect limitation. Dashboard UI auto-translation enabled for 17 target languages with English source; string capture/translation population may take days. Standard TextChatService enabled; chat translation respects player settings.


2026-10-18 18:08 KST: published version 10, tier-based shiny rates (1/0.7/0.5/0.3/0.1/0.05 percent), relative friend +10% and own Premium +30%, actual-tier HUD/details, individual crate outcome disclosures. Six-million-draw statistical check plus boundary/rules/Play verification passed. Saved 35-source XML audit passed. Existing Luck/Perk benefits and 50% test override retained. See WORKLOG for exact results.

2026-10-18 crate reward update: Normal crates award highest owned tier minus 4/3/2/1 with weights 40/30/20/10%; Perk uses minus 3/2/1/0 with the same weights. Clamp each result to tier 1, combining duplicate weights. This replaces uniform rolls from tier 1 through each cap, for both earned and paid credits. Conditional shiny rates and pass prices/IDs are unchanged. All final named outcome probabilities remain available before purchase.

Paid credits consumed at opening award 1 shard per Normal or 3 per Perk. Free credits are consumed first and award no shards. Shards persist, do not expire and survive progression reset. Exchange 30 for one exact normal dessert or 150 for one chosen shiny variant, at any already-discovered tier; no random roll or luck effect. Server commits credit consumption, rolled inventory and shards together; exchanges debit shards and grant inventory in one profile mutation. No retroactive grant for previously spent credits; existing unused paid credits qualify when opened after this update.

Published successfully at 2026-10-18 18:35:29 KST to the existing Cosmon Studio place. Native 35-source comparison/compile and saved XML audit passed. Actual Play verified exact exchange/equipment and paid Perk shard increment with temporary isolated Studio data; fixtures were removed. Receipt and fake durable-store regressions passed. No real payment. Join an updated server to receive the changes.

## Latest balance revision — full-range collectible crates

Supersedes nearby-tier crate pools and relative social boosts above. Both crate types select every tier from 1 through highest currently owned, including that highest tier, with equal tier probability. Normal crate base shiny rate is 3%; Perk is 10%, independent of result tier. Purchase and merge result tiers 1-10 use 1%, 11-20 use 0.5%, 21-30 use 0.1%.

Any number of friends in the same server adds ONE percentage point total. Own Premium adds THREE points. Friend Premium adds no separate bonus. Final probability is (applicable base + friend/Premium points) times highest owned Luck multiplier, capped at 100%. Starter base 1% + Premium 3 points + one or more friends 1 point = 5% before Luck. The explicit 50% debug code still overrides all factors. Each of two shiny variants receives half the combined shiny probability. Actual final outcome probabilities remain available before purchase. Atomic receipt/opening handling, existing prices and purchase prerequisites are retained.

Latest owner steering supersedes the shard paragraphs: shard accrual, exchange action, balance display and reward notes have been removed. Existing paid credits, receipt ledger, inventory and all current probability rules remain. Legacy shard fields, if present in old saves, are unused; this release does not reset player saves. Crate openings still atomically commit credit debit and dessert inventory.

Crates page is now compact: existing pictures, Open 1 / Open 10, current prices and owned credits. No odds percentages, formulas, tier tables or shard explanation on the main page. A small descriptive View Odds button opens a separate exact-outcome screen and is accessible before purchase, as required by Roblox paid-random-item policy. The optional HUD odds screen remains available for Luck and social benefit details. No cumulative production-pass price disclosure added.

2026-10-18 19:12:40 KST: Studio reported PublishSuccessful, published v16, existing place 98510499854486. Saved XML has all 35 exact project sources (97,921,749 bytes), no foreign scripts/packages or temporary fixtures. Play verified compact cards without percentages/shards, separate View Odds, actual state chance, and a tier-10 account receiving tier-1 dessert from a normal opening. Updated probability, receipt and durable-opening regressions passed. New servers receive the release; no real payments or production profile resets were performed.

2026-10-18 19:39:37 KST: Studio confirmed PublishSuccessful, version 20, existing place 98510499854486. Replaced only NormalCustard, DarkChocoCustard and GalaxyPudding with the owner's October 18 FBX files and matching colors, uploaded under Cosmon Studio. All six mesh/image assets loaded successfully; runtime world and companion sizes verified at 5 and 3.25 studs with upright bottom pivots. Matching local place XML and template XML saved, 35 exact project sources audited, other 120 templates unchanged, no temporary imports/previews or foreign scripts. Existing inventory, variant keys, mini models and economy remain intact. New servers receive these replacements.
