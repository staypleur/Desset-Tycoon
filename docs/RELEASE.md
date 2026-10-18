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
