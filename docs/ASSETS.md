# 무료 에셋 적용 기록

2026-10-14 Roblox Studio Toolbox → Creator Store에서 **무료** 표시를 확인하고 가져왔습니다. Roblox가 직접 제작한 에셋이라는 뜻은 아니며, 아래 커뮤니티 제작자의 무료 모델입니다.

| Creator Store 표시 이름 | 제작자 | 적용 |
| --- | --- | --- |
| [Low poly Bench](https://create.roblox.com/store/asset/8924251735) | I4supraa | 구역 사이 언덕 정원 벤치 6개 |
| [Low Poly Flower](https://create.roblox.com/store/asset/16071638063) | Dashon907AK | 현재 화단 78개 (카페·필드 테두리·구역 사이 정원); 이전 화단은 보관 |
| [Sakura Tree](https://create.roblox.com/store/asset/3725991689) | plentune | 외곽 12그루 + 구역 사이 정원 6그루 |
| [Heart Cake](https://create.roblox.com/store/asset/11382290827/Heart-Cake) | Taiyon | 개인 카페 진열장 안의 케이크 6개 |

원본 템플릿은 장소 파일의 `ServerStorage.FreeBenchTemplate`, `ServerStorage.FreeFlowerTemplate`에 보관했습니다. Creator/SourceTitle 속성도 기록했습니다. 소품의 형태를 유지하고 색상, 재질, 크기를 디저트 섬 테마에 맞췄습니다.

네 모델의 모든 자손을 검사하여 Script/LocalScript/ModuleScript가 없음을 확인했습니다. 소품은 고정하고 충돌을 끄므로 이동과 구역 배치를 방해하지 않습니다. 유료 에셋이나 플러그인은 사용하지 않았습니다. 벚꽃과 케이크 템플릿은 `FreeSakuraTemplate`, `FreeHeartCakeTemplate`에 보관했습니다. 케이크는 생산 펫이 아닌 전시 장식입니다.

원본 검색어: `low poly bench`, `low poly flowers`, `sakura tree`, `heart cake`. 재사용할 때는 Creator Store의 현재 제공 조건을 확인하세요.

## 2026-10-14 — Terrain and cafe landscape update

Studio Toolbox cafe-table search and official Creator Store searches were used to review furniture, lamps, display cases, low-poly terrain, grass, rocks, trees, bakery, pastry, cupcake and macaron candidates. Five free, lightweight models were selected. Paid packs and unrelated franchise props were not selected. Because the detached Toolbox WebView rejected remote clicks, these verified Creator Store models were imported through the supported editor GetObjects API rather than the Toolbox insertion button. No experience security settings were changed.

| Free Creator Store model | Creator | Applied use |
| --- | --- | --- |
| [Cafe Table & Chairs](https://create.roblox.com/store/asset/186713502/Cafe-Table-Chairs) | Elliott_RBLX | 12 pastel table/chair sets across six cafes |
| [Street Lamp](https://create.roblox.com/store/asset/11146095708/Street-Lamp) | BryanROBLOXgamer10 | 12 warm cafe lamps; imported beams disabled |
| [Display Case](https://create.roblox.com/store/asset/5360143567/Display-Case) | QuetzalCoatlus8431 | Six decorative pastry display cases with heart cakes |
| [Low Poly Asset Pack [Grass Biome] V 1.0](https://create.roblox.com/store/asset/14299404156/Low-Poly-Asset-Pack-Grass-Biome-V-10) | Bolt_Confirmed | Low-poly rounded rocks in the pocket gardens; remaining pack assets preserved |
| [Low Poly Asset Pack](https://create.roblox.com/store/asset/18723685255/Low-Poly-Asset-Pack) | Yoopyhoop | Grass tufts, rocks and grassy terrain meshes |

All five imported templates were inspected and contained zero scripts or package links. They live in ServerStorage.FreeEnvironmentAssets with AssetId, Creator and SourceTitle metadata. Derived props are anchored, non-collidable, non-touchable and marked DecorationOnly. Colors, sizes and some baked textures were changed on copies to match the pastel palette; source templates remain available. Terrain consists of native grass/limestone/wood surfaces, rounded Part hills and selected low-poly mesh banks; SmoothTerrain voxels were not modified.

## v11 무료 음원과 UI

- 배경음: [Cozy](https://create.roblox.com/store/asset/88115288095261/Cozy), Creator Store 무료 오디오. Studio PreloadAsync에서 IsLoaded=true, 224.40초 확인.
- 발견 효과음: [Chime](https://create.roblox.com/store/asset/158050602/Chime), Creator Store 무료 오디오. Studio IsLoaded=true, 2.46초 확인.
- UI 클릭: Roblox 내장 `rbxasset://sounds/volume_slider.ogg`.
- HUD/도감/상점/설정/상자 버튼과 하트·별 효과는 무료 네이티브 Roblox UI 컴포넌트로 직접 구성했습니다. 외부 유료 UI팩은 사용하지 않았습니다. 30단계 생산 디저트는 직접 만든 기본 네이티브 모델이며, 기존 무료 Heart Cake는 카페 전시용입니다.
- 게시 경험에서 오디오 권한/가용성은 다시 확인해야 합니다. 모든 ID는 TycoonConfig에서 교체 가능합니다.
- 유료 랜덤 상자와 행운 상품 처리는 [Roblox paid-random-items 지침](https://create.roblox.com/docs/production/monetization/paid-random-items)에 따라 결과별 확률을 표시하고 PolicyService 제한을 확인합니다. 실제 결제 ID는 아직 0입니다.

## v12 중앙 카페와 은행·상점

- [Low Poly Simulator Shop](https://create.roblox.com/store/asset/6237817363/Low-Poly-Simulator-Shop), mewtwo868: 무료 건물. `ServerStorage.FreeShopTemplate`에 보존하고 여섯 구역의 Sugar Shop으로 사용했습니다. 크기와 색을 맞추고 입구가 구역 안을 향하도록 돌렸습니다.
- [Synty City Pack](https://create.roblox.com/store/asset/6933556508/Synty-City-Pack), Roblox 배포: 무료 팩의 `PolygonCity_Buildings_SM_Bld_Station_03`만 선택하여 Dessert Bank 건물로 재사용했습니다. 전체 도시 팩은 장소에 남기지 않았습니다. 원본 건물은 `ServerStorage.FreeBankTemplate`에 보존했습니다.
- 가져온 건물의 스크립트, PackageLink, 기존 상호작용과 음원은 제거했습니다. 장식만 사용하며 게임 동작은 자체 서버 코드가 담당합니다. 복제 건물은 고정되고 충돌하지 않습니다. 네이티브 발판/카페는 돌기 표면, 무료 메시 건물은 원래 메시 형태와 질감을 유지합니다.
- 중앙 카페, 둥근 문틀, 얼굴 없는 3단 지붕 케이크는 직접 구성했습니다. 기존 무료 벤치를 중앙에 여섯 개 복제하고 실제 Seat 두 개씩 추가했습니다. 개인 카페/전시장을 제거했으며 원본 템플릿은 보존했습니다.

## v13 무료 아이콘과 파스텔 UI

- [Laurel Icon Pack](https://github.com/CManReal/laurel), [Tabler Icons](https://tabler.io/icons): 무료 MIT 아이콘. 공개 `IconPackPlugin.rbxmx`의 Decal 데이터에서 필요한 이미지 ID만 추출했습니다. 플러그인을 설치하거나 외부 코드를 실행하지 않았습니다. MIT 저작권 고지와 라이선스를 `LAUREL-LICENSE.txt`에 포함했습니다.
- 도감(book-2), 설정(settings), 상점(shopping-bag), 상자(gift), 디저트(cake), 돈(coins), 카페(coffee), 은행(building-bank), 업그레이드(arrow-up), 잠금/가능 상태(lock/check), 닫기(x), 반짝임(sparkles) 아이콘을 사용합니다. 이미지 ID는 `src/shared/DessertUI.luau`에 있습니다.
- 카드·말풍선·크림 테두리·그림자·그라데이션·호버/클릭 애니메이션은 이 프로젝트에서 직접 구성했습니다. 글꼴은 Roblox 기본 FredokaOne입니다. 외부 완성형 UI 팩을 그대로 가져온 것은 아닙니다.
- 검토한 [FREE Cartoony Roblox UI Pack](https://zxgly.itch.io/free-cartoony-roblox-ui-pack)은 색 변경 제한이 있고, Epic UI Pack은 유료 자료여서 사용하지 않았습니다. Kenney CC0 UI/아이콘도 검토했지만 Roblox에서 바로 사용하는 공개 이미지 ID가 있는 Laurel을 선택했습니다.
- 상점·은행에 추가했던 간판과 상점 지붕의 SHOP 글자 메시를 제거했습니다. 기능을 설명하는 발판 말풍선과 E 프롬프트는 유지했습니다.

## v14 승인된 무료 디자인 소스

사용자에게 썸네일을 보여 준 후 아래 소스를 승인받았습니다. 다음 UI·맵·소품 요청도 무료 소스를 먼저 검색하고, 새 후보 이미지를 보여 주고 선택받습니다. 적합한 무료 모델이 없을 때는 직접 제작 전 확인합니다.

- [White Picket Fence](https://create.roblox.com/store/asset/4539718362), visionpsyche7: 구역 테두리의 흰 울타리. 중앙 입구는 비워 두었습니다.
- [Pink Sky Skybox](https://create.roblox.com/store/asset/107689530722174), BlockadeLabs: 승인된 분홍 하늘/산 배경.
- [Tycoon Button Pack](https://create.roblox.com/store/asset/12528362526), goalmwo: `Head` UnionOperation만 선택해 둥근 발판 위쪽을 구성했습니다. 크기·색상·재질을 변경하고 자체 서버 동작/작은 두 줄 문구를 붙였습니다. 어두운 받침은 네이티브 파트입니다. [제작자 게시물](https://devforum.roblox.com/t/tycoon-map-and-assets/2188535/1000)
- [Coffee Machine](https://create.roblox.com/store/asset/12520208389), Ashbashthesmash: 사용자가 대체 후보 A를 선택했습니다. 카페 카운터 소품이며 원본 작동 스크립트는 사용하지 않습니다.
- [treasure chest](https://create.roblox.com/store/asset/8600350858), peter_gamer2022: 일반/특혜 상점 옆 상자. 가져온 메시 이름은 `PolygonDungeon_Props_SM_Prop_Chest_03`입니다. 특혜 상자 복제본 색을 라벤더로 변경했습니다.
- [Alphabet](https://create.roblox.com/store/asset/4455779753), Xndependence / 원작 umaku_naritai: SHOP/BANK 지붕 글자를 입체 Union으로 배치했습니다. 해당 다운로드에서 이름으로 찾을 수 없는 K는 같은 크기의 네이티브 막대로 보완했습니다.
- [Hapy UI Pack](https://www.shopdehapy.com/ui-pack): 제작자가 FREE로 제공하는 UI v1에서 공개 이미지 ID만 사용했습니다. 흰 상태 바, 도감 가방, 상점 그림, 닫기 아이콘, 창/도감 카드 이미지입니다. 외부 UI 코드와 플러그인을 실행하지 않았습니다. Hapy 소스에 MIT 라이선스를 적용하지 않으며, MIT 고지는 기존 Laurel 아이콘에만 해당합니다.

새 Creator Store 원본은 `ServerStorage.FreeDesignSources`에 보관합니다. 가져온 코드, PackageLink, 프롬프트, ClickDetector, 소리는 제거하고 장식만 사용합니다. 게임 동작은 자체 서버 코드로 처리합니다. 거절한 첫 상자/에스프레소 머신은 맵에 사용하지 않았고 조사용 머신도 제거했습니다. 무료 완제품 원형 카페를 찾지 못해 별도 승인을 받고 사진을 참고한 원형 카운터/상부 링/40개 펜던트 조명을 직접 제작했습니다.

카페 판매 배율 UI는 승인된 Hapy 상태 바 이미지를 재사용하며, 계정 음성 UI는 Roblox 기본 컨트롤입니다. 유료 소스/플러그인은 구매하지 않았습니다.

## v15 선택한 무료 소스와 간결한 화면

- [Pink and blue cotton candy sky](https://create.roblox.com/store/asset/10800422601), momogone: 사용자 선택 하늘 A. 기존 어두운 산 배경을 교체했습니다.
- [Happy Birthday Cake](https://create.roblox.com/store/asset/76551418404097), Marko97_IT: 사용자가 툴박스 썸네일로 직접 지정한 흰색·핑크 케이크입니다. 카페 바닥과 같은 X/Z 중심에 맞춰 지름 약 60 studs로 확대했습니다. 촛불/장식은 보존하고 배율 UI는 앞에 표시합니다. 앞서 승인한 pink cake display는 최종 지붕에 사용하지 않습니다.
- [Cute Pink Park Sign](https://create.roblox.com/store/asset/119414144714376), MidnightFirlefanz, [Cherry Sign cute](https://create.roblox.com/store/asset/9680569807), IMochiButterfly: 모두 승인. 구역별로 번갈아 사용하는 무료 프레임에 앞·뒤 SurfaceGui를 붙였습니다. 얼굴은 Roblox AvatarHeadShot, 이름은 서버가 할당한 OwnerName입니다. 미할당 시 비어 있습니다.
- [cute flower pot](https://create.roblox.com/store/asset/5682830668), [cute flower potted plant](https://create.roblox.com/store/asset/5683155663), eienorid: 두 소스 모두 승인. 각 구역과 중앙 벤치 근처에 배치했습니다.
- [Yasu's Stylized Tree Pack](https://create.roblox.com/store/asset/79689531752352), mvyasu: 승인된 팩에서 Tree_01–Tree_20 모델만 사용합니다. 전시용 바닥/설명판은 복제하지 않습니다. 24개 나무의 Canopy 메시를 민트·핑크·라벤더·피치·블루·크림으로 변경했습니다. 기존 무료 벚꽃은 보존하고 직접 제작한 CandyGarden 나무·덤불을 제거했습니다.
- [Roblox 공식 원형 이미지 사용 예제](https://create.roblox.com/docs/reference/engine/enums/ProximityPromptStyle): 내장 무료 `rbxasset://textures/ui/Controls/RadialFill.png`를 두 반원으로 마스킹하고 파스텔 무지개 UIGradient를 적용했습니다. 사용자에게 실제 게이지 미리보기를 보여 승인받았습니다. 가운데에는 배율만 표시하고 30초 동안 채웁니다.
- 사용자가 제공한 투명 PNG를 그대로 `assets/dessert-counter-plate.png`에 보관하고 Roblox에 업로드했습니다. Decal ID는 **116465391477996**, 실제 이미지 Texture ID는 **73464157423623**입니다. ImageLabel은 Texture ID를 사용하며 실제 클라이언트 IsLoaded 및 화면 표시를 확인했습니다. 외부 무료 팩이 아닌 사용자 제공 그림입니다.

이번 새 소스는 무료 표시/제작자를 확인한 뒤 사용했습니다. 가져올 때 Script·LocalScript·ModuleScript·PackageLink·기존 상호작용·소리를 제거하는 검사를 통과시켰으며 해당 새 모델에서는 제거 대상 코드가 발견되지 않았습니다. 기존 맵, 건물 및 ServerStorage의 원본 템플릿도 검사했으며 외부 실행 코드는 없었습니다. 직접 작성한 게임 코드 20개와 Roblox가 플레이 중 생성하는 기본 캐릭터/채팅 코드는 유지합니다.

v15의 은행·상점 건물은 충돌합니다. 각 구역의 상자는 하나만 남겼고 상점 옆 입구 반대쪽으로 옮겼습니다. 위 v12/v14 항목의 비충돌/두 상자/카페 사각 배율 UI 설명은 해당 버전의 기록입니다.

## 핑크·크림 Kawaii 상점 UI

- [GUI Kawaii Pack FREE](https://pocogamesco.itch.io/ui-user-interface-kawaii-pack), **PocoGamesCo**: 사용자가 앞의 StoreUI/Comet 후보를 제외하고 이 무료 팩의 핑크·크림 구성을 선택했습니다. 실제 무료 ZIP의 `Mega Panel Pack.png`에서 창 배경, 둥근 핑크 버튼, 그림 배경을 골라 사용했습니다. 완제품 Shop 화면은 유료 버전이며 가져오지 않았습니다. 8개 상품 카드·가격·스크롤·화면별 열 수와 구매 연결 코드는 직접 작성했습니다.
- 제작자 라이선스는 상업/비상업 게임 사용과 수정을 허용하고 원본·수정 에셋의 재배포/재판매를 금지합니다. 다운로드 ZIP과 원본 PNG/PSD는 GitHub에 추가하지 않습니다. `.local-ui-review/`를 Git에서 제외했고 저장된 Roblox 장소/코드는 업로드한 이미지 ID만 참조합니다. 원본 그림의 저작권은 PocoGamesCo에 있습니다.
- 업로드한 Decal ID **116058453183198**, 실제 이미지 Texture ID **82678981874379**. 3000×3000 원본을 변경 없이 업로드했고 Frame.ClipsDescendants와 정규화된 비율로 필요한 부분을 표시합니다. 이미지 파일을 직접 잘라 다시 만들지 않았습니다. 카드의 디저트 그림은 기존 프로젝트 모델을 ViewportFrame에서 표시하고, 기능 아이콘은 승인된 Laurel 소스를 재사용합니다.
- 무료 ZIP은 PNG/PSD와 macOS 메타데이터만 포함했습니다. 실행 파일·Luau 스크립트를 실행하지 않았습니다. 상점 동작은 자체 `KawaiiShop` 코드와 기존 서버 구매 검증에 연결됩니다. 상품 ID 0에 대한 구매 잠금은 유지합니다.
- 검토 후 제외: [StoreUI](https://devforum.roblox.com/t/free-storeui-an-animated-modern-gamepass-store-ui/632073), [Comet Shop UI 무료 그래픽](https://devforum.roblox.com/t/shop-ui-free-graphics-tutorial/2297542). 해당 후보 코드는 게임에 가져오지 않았습니다.

## 2026-10-15 — Unified Pastel Dream menus and promenade

User selected the new **Pastel Dream FREE edition** by **ToffeeCraft**, https://toffeecraft.itch.io/ui-user-interface-pack-pastel-dream. The free download is `PastelUIFree.png.zip` (22 kB), containing one 256×300 PNG and macOS metadata, no executable code. Author permits commercial/personal use and editing, prohibits raw redistribution/resale. Paid full edition was excluded. Raw files stay in ignored `.local-ui-review/PastelDream/`, never committed. Uploaded private decal **131118160849287**, actual texture **127272710931588**. Source panel/card/blank-button crops render every opening game menu, including Index, Settings, Shop, Crates, Stats and discovery. Existing owned models supply 3D previews; interaction and purchase code remains ours.

Reused previously approved **White Picket Fence 4539718362** and **Street Lamp 11146095708** (BryanROBLOXgamer10) around the plaza and six paths. Imported LuaSourceContainer/PackageLink are asserted absent. Decorative beams disabled, warm lights softened, clear passage left at path/plot entrances. Reused Tycoon Button Pack 12528362526 single union for pad bases to remove coplanar overlap. Source geometry and unused imported templates were audited again.

Review proof: `docs/previews/index-pastel-dream.png`, `pastel-ui-upload.png`, `index-v16.png`, `stats-v16.png`, `shop-v16.png`. These are project screenshots, not redistributable source atlases.

### Approved AFK / offline baskets

The user approved **basket**, **Glowziing**, free Creator Store asset **6132018569**: https://create.roblox.com/store/asset/6132018569/basket. Search and detail screenshots are in `docs/previews/free-basket-candidate.png`. Imported through editor GetObjects after approval; sanitization found zero foreign executable scripts/interactions. Original stored as ServerStorage.FreeDesignSources.OverflowBasket. Twelve placed copies are recolored pink, texture removed to get the requested true pastel color, widened/lowered, anchored and non-colliding. Counter labels and storage logic are ours. Baskets stay empty at the user’s latest request; stored amounts are represented only by English number labels.

Basket visibility follows its own stored count: zero hides mesh and sign; positive shows the empty basket. Owner pickup hides it again.

### v16.1 promenade refinement
Reuse approved lamp/fence sources: 24 lamps point inward at their own road, 6 central fence sections with clear gaps, no road-side fences. Decoration count reduced from 66 to 30; lamp part and light shadows disabled. No new asset selected.

## 2026-10-15 — Approved Kawaii cafe display
- [Kawaii dessert display](https://create.roblox.com/store/asset/13702399035/Kawaii-dessert-display), R4C3x, verified free in Creator Store and selected by user after rejecting Lite Cafe sample. Source contains 663 anchored parts; 0 executable scripts/package links/interactions found. One 8-stud display in central cafe and two small source-based counter props; no repeated plot copies. Decorative collision/touch/query/shadows disabled. Original clean source stored in ServerStorage.FreeDesignSources.KawaiiDisplay.

## 2026-10-15 — Full cafe decoration and pink stands
- [Pink Plain cake stand](https://create.roblox.com/store/asset/8393777894/Pink-Plain-cake-stand), nNikoshimi: free Creator Store source, user approved after actual image review; 8 parts and no executable scripts/package links/foreign interactions found. Clean template in ServerStorage.FreeDesignSources.PinkCakeStand.
- User reduced 24 stands to exactly 12. Three lightweight versions of approved Kawaii shelves replace repeated 50-97-part pastries with approved 3-14-part food models. Counter has 36 leveled food/drink props, three flower displays; total decorative part count 1,102. Decorative collisions/touch/query and shadows disabled. Coffee machine removed from map and generation.
- Food models imported with roughly 20-degree display tilts are leveled as complete assemblies, retaining relative component transforms. A separate floating chocolate prototype near (23.24,44.85,-33.10) was moved from Workspace.Model to ServerStorage.DessertModelPrototypes.ChocolateCakePreview, preserving its construction.

## 2026-10-15 — Calm cafe background music
- User selected [Smooth Focus Rain Melody](https://create.roblox.com/store/asset/73635875504187), DistrokidOfficial, from three Creator Store audio candidates after rejecting Pastel Afternoon Piano. Public Creator Store audio with Get Audio; listing describes Rainy Day Cozy Cafe Jazz 2026 with smooth piano and gentle rain ambience, duration 1:57. Uses existing asset ID directly; no audio file redistribution or imported scripts. Replaces Cozy (88115288095261).

## 2026-10-15 — User-supplied shop artwork and native microphone
- All 23 supplied PNGs are mapped by original filename and SHA256 in assets/ui/manifest.json. Existing designs/colors retained; resized to 256px cells in two atlases (1024x1024, 768x768) to avoid Roblox UI downscaling/crop mismatches. Final decal IDs 138249659648662 / 132988240594318; actual image texture IDs 96453748274402 / 107649080804389. Used for next-tier production/luck/speed cards, AutoMerge, separate money/dessert magnets, Normal/Perk crates, Index/Shop buttons and cash/shiny/multiplier HUD icons.
- Microphone follows the user's Roblox topbar reference and reuses built-in rbxasset://textures/ui/VoiceChat/MicLight/Muted.png and Unmuted0.png. Verified both files in the installed Roblox texture bundle; no external asset upload, imported script or executable package.

## 2026-10-15 — User-provided rigged cafe chef
- User supplied the Meshy AI chef static FBX/textures ZIP, rigged biped ZIP, and reference portrait. Uses the rigged source, one mesh with 3,165 triangles and 22 bones. Runtime color/geometry unchanged; uniform height 8 studs, foot-center pivot, emissive strength 0 to remove unintended glow. Mesh 124893487789324, color map 81596257819395, Walking clip 79831780716711, uploaded to the signed-in creator through Studio Importer.
- Clean template in ServerStorage.CafeChefTemplate; one CafeChef inside the central cafe. Anchored, non-colliding/non-touching/non-queryable with shadows disabled. No imported executable scripts/package links/interactions. Original animation saves retained for editing. Source hashes recorded in assets/chef/manifest.json.

## 2026-10-15 — User-provided pudding pair
- User supplied Meshy_AI_cute_pudding_characte_1015004459_texture_fbx.zip and Meshy_AI_pastel_pudding_no_fac_1015004443_texture_fbx.zip with matching reference pictures. The face/limbs model replaces tier-1 producers, Index previews and equipped companions; the face-free model replaces tier-1 moving drops and cafe delivery visuals. Higher tiers retain their existing models.
- Normal: 2,914 triangles, 70 cm / 2.5 studs high; mini: 314 triangles, 18 cm / 0.642857 studs high. Uniform scaling preserves source proportions. One mesh each, upright bottom-center pivot, anchored, no collisions/touch/query/shadows. Shiny variants retain the existing gold tint and sparkles. No imported executable scripts/package links.
- Mesh IDs: normal 96350150554296, mini 103427896417724, uploaded through Studio to the signed-in creator. Importer rejected material uploads, so clean geometry-only FBX variants preserve original vertex/UV data and use separately uploaded color maps. Normal decal 112799935838007 → texture 138637996171751. Initial mini PNG image delivery failed with generation/HTTP 502 errors; an RGB-identical BMP conversion resolved it: decal 128560628779702 → texture 133696575078119. Color decals uploaded in the dashboard's selected creator group 차누맨~~ (33020204), Open Use, without Creator Store distribution or permission changes.
- Runtime templates are in ReplicatedStorage.DessertModelTemplates, exported to assets/pudding/DessertModelTemplates.rbxmx for Rojo. Original imported copies are archived in ServerStorage.UserPuddingOriginals. Source files/hashes and final IDs are recorded in assets/pudding/manifest.json. Proof: docs/previews/pudding-producer-live.jpg and pudding-mini-live.jpg.
- User subsequently requested double size for plate desserts and summoned pets: normal world/Index builds now scale uniformly by 2 (pudding height 140 cm / 5 studs); equipped copies retain the 0.65 factor (91 cm / 3.25 studs). Base import templates and 18 cm collection minis retain their original measurements. Viewport cameras fit model bounds.
- Collectibles now have an invisible native sphere collider and welded original art for server physics. Client cosmetic copies retain the same supplied mesh/textures and smoothly follow the replicated body's real position/rotation. No new visual asset was introduced. Producer hops and Index bobbing are scripted presentation only.
- User explicitly requested low barriers above the yellow slopes to stop spills. MintLaneGuard beams reuse the existing approved mint field color/material and follow the feed/main slope surfaces; invisible collectible-only collision boundaries back them. Collector entrance uses an invisible overlapping physical slope. No additional source assets or imported scripts.

## 2026-10-15 — Uniform owner noticeboards
- User selected the already approved Cute Pink Park Sign, MidnightFirlefanz, asset 119414144714376 (ServerStorage.FreeDesignSources.OwnerBoardA), matching their second screenshot. All six plots now reuse that pink frame/post model instead of alternating with Cherry Sign cute 9680569807. Existing front/back owner portrait and name bindings retained. No new download or custom design; geometry remains anchored and non-colliding. CleanPresentation migrates existing boards once and reuses them on subsequent runs.


## 2026-10-15 — Two pudding shiny variants, custard, image index and carousel
- User-supplied Meshy FBX exports: Milk Pudding (3,070 triangles), Galaxy Aurora Pudding (3,116), tier-2 Custard (2,907), and face-free Mini Custard (313). Original mesh/UV/color data retained; geometry-only imports avoid importer material errors. Uniform base heights 70 cm for producers and 18 cm for minis, upright bottom-center pivots. World producers retain the requested 2x display scale, companions 0.65 of that. One clean MeshPart per template; no executable scripts/package links or foreign interactions.
- Templates MilkPudding, GalaxyPudding, NormalCustard and MiniCustard join the existing pudding pair in ReplicatedStorage.DessertModelTemplates. Mesh/color IDs and archive/file hashes are recorded in assets/desserts/manifest.json. Native imported originals remain in ServerStorage.UserDessertOriginals.
- User confirmed the two tier-1 shiny variants are selected 50:50 after the existing shiny roll. Existing 1s inventory/discovery/equip keys become Milk Pudding without deleting or resetting counts; 1s2 identifies Galaxy Aurora Pudding. Merges preserve variant identity and producing/offline counts use the same 60-slot ordering.
- Four user reference portraits were cut out through the built-in image_gen edit tool with transparent alpha, packed into a shared 1024px atlas. Prompt and mode are saved in assets/desserts/icons/prompts.json. Index, crate carousel and result summary use 2D ImageLabels, with no Index ViewportFrames or per-card 3D animation. Unsupplied higher-tier artwork temporarily reuses the approved Dessert Magnet icon and the actual dessert name; the user will supply subsequent images.
- Index panel/card/button art reuses the approved ToffeeCraft Pastel Dream FREE source. Content is inset within the pink artwork, clipped scrolling prevents overflow, unknown marks use 58px text, and titles align to the visible header center rather than transparent pixels in the crop.
- Discovery keeps exactly one fixed-facing 3D floating preview and bounded star/heart effects. Free Rainbow Confetti by TieSkyGuy (https://create.roblox.com/store/asset/945340401/Rainbow-Confetti) was shown for review; user chose to retain the existing star/heart effects. No new confetti model/code was acquired or applied.
- Crates reuse approved UI art for a horizontal image carousel with a fixed arrow. The server grants results once and supplies pre-roll discovery knowledge; unknown cards remain question marks until their actual stop. Skip affects only presentation, and the image summary lists every granted result. Only new discoveries receive the 3D celebration.
- Producer fill order alternates both sides for each six-plate row before moving backwards. Existing plate positions, slopes and collector physics remain in place.

Index thumbnails have a clipped 20px inset and Fit scaling; unknown marks are centered within the green card. No new visual sources were added for these layout adjustments.

## Cosmon Studio join button (2026-10-15)
- User-provided transparent PNG `codex-clipboard-3b977cc2-d4cb-42fe-a552-f060f392e23e.png`, retained unchanged as `assets/ui/group-join.png`. Decal 86863203944007, image 89761423925798, uploaded under the same selected creator as the other approved UI. Source hash is recorded in assets/ui/manifest.json. No downloaded code or added source art.
- Button sits above Index, opens an English confirmation, then Roblox's native GroupService:PromptJoinAsync for [Cosmon Studio](https://www.roblox.com/communities/203626899/Cosmon-Studio). Server GetGroupInfoAsync verified the ID/name. Actual membership changes require the published game; Studio deliberately does not join the operator's account.
- Reference: [official GroupService documentation](https://create.roblox.com/docs/reference/engine/classes/GroupService). Reward confirmation uses server IsInGroupAsync, with a delayed recheck for membership cache propagation, never a trusted client boolean. One free PerkTokens credit and a permanent community receipt are persisted atomically through the existing profile receipt writer.

## Supplied custard shiny variants and plot repairs (2026-10-15)
- User archives: `Meshy_AI_iridescent_egg_custar_1015071247_texture_fbx.zip` and `Meshy_AI_iridescent_black_choc_1015073924_texture_fbx.zip`, located in the user's dessert asset folder. Originals, prepared FBX files, textures and hashes retained under assets/desserts/rainbow-custard and dark-choco-custard.
- Rainbow Cotton Candy Custard (`2s`): mesh 131508904993465, texture 72584377487680 (decal 111642900720036), 2,955 triangles. Dark Choco Custard (`2s2`): mesh 109807250478265, texture 82354773271014 (decal 105095541091725), 3,081 triangles from the user's corrected source archive. The earlier mistaken high-poly asset was replaced before the final save; no decimation is used in the final template. Original corrected FBX and color texture remain intact. Both have normalized 2.5-stud base height, bottom-center pivots, white material tint and script-free templates.
- Transparent cutouts created with built-in image_gen from the two supplied references; exact prompts and mode recorded in assets/desserts/icons/prompts.json. New atlas 1024x512: decal 77178095030342, image 117870878192537; 512px cells for 2s and 2s2. No new visual source/design was added. Mini Custard retains its existing shiny fallback because separate shiny mini meshes were not supplied.
- Existing approved furniture moved as complete sets to local (+/-55, -23), with a two-stud button clearance regression across all six plots. RaisedFieldGround filler width inset from 52 to 51.5 to separate its sides from the overlapping shelf faces; shelf, plate, lane and collectible collision dimensions stay intact.


## 2026-10-15 — User-provided tier-three strawberry jellies
- User supplied the face-free Strawberry Jelly mini (212 triangles), Strawberry Jelly (3,042), Strawberry Mint Sherbet Jelly (2,905) and Strawberry Mint Ruby Crystal Jelly (2,977). The last two are tier-three shiny variants. Original geometry/UV/color retained; clean geometry-only imports and independently uploaded textures avoid importer material errors.
- Templates MiniJelly, NormalJelly, SherbetJelly and RubyJelly extend the shared model folder to twelve. Base heights are 18 cm for the mini and 70 cm for producers; existing 2x producer display and 0.65 companion multiplier remain. One MeshPart each with bottom-center pivot, automatic render fidelity and no shadows, scripts or package links.
- Mesh IDs respectively 113858503243198, 138699807859155, 99142049695757 and 79986430669397. Color IDs and original archive/file hashes are recorded in assets/desserts/manifest.json. Source files live under assets/desserts/{mini-strawberry-jelly,strawberry-jelly,sherbet-jelly,ruby-jelly}.
- Three supplied character references received transparent background cutouts using the built-in image_gen edit tool. Prompts/mode recorded in assets/desserts/icons/prompts.json; packed atlas jelly-index-atlas.png uses image 78200800148968 (decal 101974423900380). Index, crate carousel and summaries reuse this 2D atlas; discovery uses the native floating 3D model. No external visual source was added.
- Normal Jelly PNG image delivery returned AssetFetchStatus.Failure in Play. Re-uploaded an RGB-identical BMP without changing any pixels: decal 99000398352397 → final texture 136064848332451. Native client preload and visible rendering succeeded; source PNG is preserved.

## Tier 4 Shortcake — user assets, 2026-10-15

User-supplied Meshy FBX archives and matching references replace the old tier-four Brownie placeholder. Original FBX/PNG and hashes are preserved in assets/desserts/manifest.json. Import FBX strips embedded texture references; one script-free MeshPart per template preserves source UVs. Textures uploaded to the existing group as RGB-identical BMPs after PNG preload failures; no permission changes. Live client texture loading verified.

| Template | Triangles | Mesh | Texture | Base height |
|---|---:|---:|---:|---:|
| MiniShortcake | 314 | 133382875474692 | 136176615288172 | 18/28 studs |
| NormalShortcake | 2717 | 134037438711345 | 85574957138753 | 2.5 studs |
| GalaxyShortcake | 2961 | 121135970370674 | 138497601929830 | 2.5 studs |
| UnicornShortcake | 2848 | 81256150384408 | 106272870540753 | 2.5 studs |

Producer display height remains 5 studs, with the existing companion scale. Shiny mini desserts reuse the face-free mini with the existing gold tint/sparkles because no separate shiny mini geometry was supplied. Three built-in image_gen transparent cutouts share a 1024px atlas (image 96411714992673, decal 126559086519407); index and roulette use 512px cells. Prompts recorded in assets/desserts/icons/prompts.json. Proof: docs/previews/shortcake-world.png and shortcake-index.png.

## Tier 5 Macaron — user assets, 2026-10-15

User confirmed all four Macaron assets belong to tier five. Original Meshy FBX geometry, UVs, color maps and archive hashes are retained under assets/desserts and manifest.json. Imported geometry uses one script-free MeshPart per template; RGB-identical BMP uploads preserve the supplied texture colors.

| Template | Triangles | Mesh | Texture |
|---|---:|---:|---:|
| MiniMacaron | 313 | 84857173827168 | 130844940077854 |
| NormalMacaron | 3146 | 115042704381446 | 109423306857960 |
| CrystalMacaron | 2904 | 138413585714104 | 117080664575433 |
| DarkMacaron | 3110 | 137825462406032 | 71830617311568 |

Base heights remain 18/28 studs for mini and 2.5 studs for full models; producers display at 5 studs. Bottom-center pivots, automatic render fidelity, disabled shadows and existing companion scaling retained. Shiny minis use the supplied face-free mini with existing gold tint/sparkles. Three transparent cutouts from user references use built-in image_gen; exact prompts recorded in icons/prompts.json. Shared 1024px atlas image 81932094548604, decal 111801012745786. Proof: docs/previews/macaron-world.png and macaron-index.png.
## Tier 6 Croissant — user assets, 2026-10-15

Four user-supplied Meshy archives replace the tier-six Donut placeholder. Source archives were found in the user's dessert asset folder; original geometry, UVs, textures and hashes are retained under assets/desserts and manifest.json. One script-free MeshPart per template, bottom-center pivots and automatic render fidelity; existing 2.5-stud base / 5-stud producer height and companion scale remain. Mini base height is 18/28 studs.

| Template | Triangles | Mesh |
|---|---:|---:|
| MiniCroissant | 312 | 136495500428417 |
| NormalCroissant | 3050 | 99062875409151 |
| GalaxyCroissant | 3144 | 77393796050585 |
| QuartzCroissant | 3094 | 139508983045026 |

Three user-reference cutouts were prepared with built-in image_gen, using actual transparency and aspect-preserving 512px atlas cells. Exact prompts are in icons/prompts.json. Atlas image 101676992338599, decal 87769853568747. Shiny minis reuse the supplied face-free mesh with the existing gold tint/sparkles. No external visual designs were added. Proof: docs/previews/croissant-world.png and croissant-index.png.
- Normal Croissant initially failed live texture delivery with BMP image 94249948799545. Re-uploading the unchanged original PNG resolved it: decal 90165978839336, image 139578570970895. Live preload returned Success for all three producer maps and the mini map.

## Tier 7 Waffle — user assets, 2026-10-15

Four user-supplied Meshy archives replace the tier-seven Egg Tart placeholder. Original geometry, UVs, textures and archive hashes are retained in assets/desserts and manifest.json. Decorative templates contain one MeshPart each with no scripts or packages. Bottom-center pivots, automatic render fidelity and disabled shadows retain existing 2.5-stud base / 5-stud producer height; mini base is 18/28 studs.

| Template | Triangles | Mesh | Texture |
|---|---:|---:|---:|
| MiniWaffle | 310 | 131382460999233 | 122853078437347 |
| NormalWaffle | 2951 | 126280120891352 | 127005342006041 |
| UnicornWaffle | 2879 | 96312769938454 | 140560590973789 |
| HoneybeeWaffle | 3114 | 130076525799889 | 94136436247267 |

User-provided reference images were cut out with built-in image_gen; exact prompts are in assets/desserts/icons/prompts.json. Transparent 1024px atlas image 91766508733195 ([decal](https://create.roblox.com/dashboard/creations/store/87381359525723/configure)) contains three aspect-preserving 512px cells. Shiny minis reuse the supplied face-free mini with existing gold tint/sparkles. The user's fourth name is preserved as Pink Dark Choco Honey Waffle without altering the supplied chocolate/honeybee colors. Proof: docs/previews/waffle-world.png and waffle-index.png.
