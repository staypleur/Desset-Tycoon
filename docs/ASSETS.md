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

## Tier 8 Patbingsu — user assets, 2026-10-15

Four user-supplied Meshy archives replace the tier-eight Cream Puff placeholder. The first mango archive contained 843,964 triangles and was never imported; the user supplied replacement 1015103648 with 3,073 triangles, which is the final source. Original geometry/UVs and PNG textures retained, hashes and upload IDs recorded in manifest.json. Normal/mango 4096px maps are downsampled to 2048px for game use; others are native 2048px. One script-free MeshPart per template, automatic render fidelity, disabled shadows and bottom-center pivots; mini height 18/28 studs, full base 2.5 / producer 5 studs.

| Template | Triangles | Mesh | Texture |
|---|---:|---:|---:|
| MiniBingsu | 314 | 120796736973866 | 75050430216843 |
| NormalBingsu | 3126 | 106720525032637 | 122156990895461 |
| RedBeanBingsu | 3126 | 128120281024779 | 134906036349280 |
| MangoBingsu | 3073 | 96524354777183 | 138029057603227 |

Transparent user-reference cutouts created with built-in image_gen; exact prompts in assets/desserts/icons/prompts.json. Three 512px cells in 1024px atlas image 91644959397587 ([decal](https://create.roblox.com/dashboard/creations/store/126346920723969/configure)). Shiny minis reuse MiniBingsu with the existing gold tint/sparkles. Proof: docs/previews/bingsu-world.png and bingsu-index.png.

## Tier 9 Tiramisu Cake — user assets, 2026-10-15

Four user-supplied Meshy archives replace the tier-nine Macaron placeholder. Original geometry, UVs and 2048px textures retained, with archive/file hashes and upload IDs in manifest.json. One script-free MeshPart per template, automatic render fidelity, disabled shadows and bottom-center pivots. Mini height 18/28 studs, full base 2.5 / producer 5 studs.

| Template | Triangles | Mesh | Texture |
|---|---:|---:|---:|
| MiniTiramisu | 312 | 129130838775985 | 114068885584080 |
| NormalTiramisu | 3050 | 110949717610709 | 126710686451658 |
| PrismTiramisu | 2960 | 117290725160266 | 86354568951883 |
| QuartzTiramisu | 3138 | 113858916080254 | 132179357477332 |

Transparent user-reference cutouts created with built-in image_gen; exact prompts in assets/desserts/icons/prompts.json. Three aspect-preserving 512px cells in 1024px atlas image 110416862812071 ([decal](https://create.roblox.com/dashboard/creations/store/86695871378793/configure)). Shiny minis reuse MiniTiramisu with existing gold tint/sparkles. Proof: docs/previews/tiramisu-world.png and tiramisu-index.png.

## Tier 10 — Madeleine family (2026-10-15)
User-supplied Meshy FBX archives: `Meshy_AI_madeleine_no_face_no__1015111142_texture_fbx.zip`, `Meshy_AI_madeleine_character_3_1015111157_texture_fbx.zip`, `Meshy_AI_pearl_prism_madeleine_1015111211_texture_fbx.zip`, `Meshy_AI_mint_ocean_crystal_ma_1015111218_texture_fbx.zip`. User supplied the designs and authorized import. Original geometry/UVs and 2048px RGB texture content retained; embedded texture links removed from import copies. Source hashes in `assets/desserts/manifest.json`.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| MiniMadeleine | 308 | 90639149458137 | 82967791441092 | 117569468598658 |
| NormalMadeleine | 3013 | 76580555905294 | 125463912879182 | 70724065556101 |
| PearlMadeleine | 3094 | 89061165818579 | 89890262789552 | 95218896549017 |
| MintMadeleine | 3130 | 134185762020398 | 86131355175689 | 136707955275038 |

Templates use a single script-free anchored MeshPart, no collision/touch/query/shadow, white SmoothPlastic, bottom-center pivot; full base height 2.5 studs (5 in production), mini 18/28 stud. Shiny minis reuse the ordinary face-free mini with established sparkle treatment.
Transparent inventory cutouts created with built-in image_gen from user reference images; exact prompt and output files in `assets/desserts/icons/prompts.json`. Atlas: `madeleine-atlas.png`, 1024px RGBA, cells 10n=(0,0), 10s=(512,0), 10s2=(0,512), each 512px. Image ID 112960015006578, decal 134199821770770. Proof: `docs/previews/madeleine-world.png`, `madeleine-index.png`.

## Tier 11 — Eclair family (2026-10-15)
User-supplied Meshy archives: `Meshy_AI_eclair_no_face_no_lim_1015112459_texture_fbx.zip`, `Meshy_AI_eclair_character_3k_1015112514_texture_fbx.zip`, `Meshy_AI_pink_quartz_rose_gold_1015112525_texture_fbx.zip`, `Meshy_AI_galaxy_aurora_eclair__1015112533_texture_fbx.zip`. User supplied the designs and authorized import. Original geometry/UVs and 2048px texture colors retained; embedded texture links removed from import copies. Original hashes in `assets/desserts/manifest.json`.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| MiniEclair | 312 | 79227449706537 | 75341684941115 | 72702463192341 |
| NormalEclair | 2965 | 120329744531564 | 122620488530060 | 70394256985722 |
| QuartzEclair | 3052 | 134851971568011 | 138300062755975 | 112950380919238 |
| GalaxyEclair | 3071 | 100788863793826 | 116270054195281 | 125674000100307 |

Single script-free anchored MeshPart templates, collision/touch/query/shadows disabled, white SmoothPlastic and bottom-center pivots. Full base height 2.5 studs (5 in production); mini 18/28 stud. Shiny minis reuse the face-free ordinary mini with existing sparkle treatment.
Built-in image_gen transparent inventory cutouts preserve user reference characters. Exact prompt and paths in `assets/desserts/icons/prompts.json`. Atlas `icons/eclair-atlas.png`, 1024px RGBA; 512px cells: 11n=(0,0), 11s=(512,0), 11s2=(0,512). Image 91034076326961; decal 120016916731846. Proof: `docs/previews/eclair-world.png`, `eclair-index.png`.

## Tier 12 — Panna Cotta family (2026-10-15)
User-supplied Meshy archives: `Meshy_AI_panna_cotta_no_face_n_1015113945_texture_fbx.zip`, `Meshy_AI_panna_cotta_character_1015113957_texture_fbx.zip`, `Meshy_AI_ruby_strawberry_panna_1015114008_texture_fbx.zip`, `Meshy_AI_mint_ocean_crystal_pa_1015114017_texture_fbx.zip`. User provided designs and authorized import. Original geometry/UVs and 2048px RGB texture content retained; embedded texture links removed from import copies. Source hashes in `assets/desserts/manifest.json`.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| MiniPannaCotta | 292 | 106697195628179 | 83349677026041 | 78681840573855 |
| NormalPannaCotta | 3053 | 131878326688965 | 99941629957659 | 87597268620683 |
| RubyPannaCotta | 2885 | 123135227096378 | 74069374840338 | 103456926738502 |
| MintPannaCotta | 3014 | 123147196733240 | 101499084538020 | 120908687039155 |

Single script-free anchored MeshPart templates, collision/touch/query/shadows disabled, white SmoothPlastic and bottom-center pivots. Full base height 2.5 studs (5 in production); mini 18/28 stud. Shiny minis reuse the face-free ordinary mini with existing sparkle treatment.
Built-in image_gen transparent inventory cutouts from supplied character references; exact prompt and paths in `assets/desserts/icons/prompts.json`. Atlas `icons/pannacotta-atlas.png`, 1024px RGBA; 512px cells: 12n=(0,0), 12s=(512,0), 12s2=(0,512). Image 92406130456099; decal 123904122357231. Proof: `docs/previews/pannacotta-world.png`, `pannacotta-index.png`.

## Tier 13 — Souffle Pancake family (2026-10-15)
User-supplied Meshy archives: `Meshy_AI_souffle_pancake_no_fa_1015114153_texture_fbx.zip`, `Meshy_AI_souffle_pancake_3k_1015114209_texture_fbx.zip`, `Meshy_AI_sakura_pink_pancake_3_1015114226_texture_fbx.zip`, `Meshy_AI_black_hole_choco_souf_1015114252_texture_fbx.zip`. User provided designs and authorized import. Original geometry/UVs and 2048px RGB textures retained; embedded texture links removed from import copies. Source hashes in `assets/desserts/manifest.json`.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| MiniSouffle | 298 | 139416745078402 | 91858676885226 | 134252793361115 |
| NormalSouffle | 3002 | 136480140819512 | 114634783013163 | 109334654037043 |
| SakuraSouffle | 3008 | 104944316177812 | 86347752647953 | 86465616025283 |
| BlackholeSouffle | 3009 | 89638499168297 | 82232143811791 | 127502522092101 |

Single script-free anchored MeshPart templates, collision/touch/query/shadows disabled, white SmoothPlastic and bottom-center pivots. Full base height 2.5 studs (5 in production); mini 18/28 stud. Shiny minis reuse the face-free ordinary mini with existing sparkle treatment.
Built-in image_gen transparent inventory cutouts from supplied character references; exact prompt and paths in `assets/desserts/icons/prompts.json`. Atlas `icons/souffle-atlas.png`, 1024px RGBA; 512px cells: 13n=(0,0), 13s=(512,0), 13s2=(0,512). Image 84736068710282; decal 128429991110472. Proof: `docs/previews/souffle-world.png`, `souffle-index.png`.

BlackholeSouffle uses the RGB-identical PNG upload after the BMP image failed to load in Play. Both upload IDs are recorded in the manifest.

## Tier 14 — Wagashi family (2026-10-15)
User-supplied Meshy archives: `Meshy_AI_wagashi_no_face_no_li_1015115819_texture_fbx.zip`, `Meshy_AI_wagashi_character_3k_1015115837_texture_fbx.zip`, `Meshy_AI_mint_emerald_chrysant_1015115857_texture_fbx.zip`, `Meshy_AI_deep_choco_gold_wagas_1015115925_texture_fbx.zip`. User provided designs and authorized import. Original geometry/UVs and 2048px RGB textures retained; embedded texture links removed from import copies. Source hashes in `assets/desserts/manifest.json`.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| MiniWagashi | 306 | 115806006919998 | 92456304500593 | 121400562753294 |
| NormalWagashi | 3008 | 89412733864055 | 115717825036231 | 103010644527647 |
| MintWagashi | 3026 | 130088801703886 | 72213574554646 | 71124067743204 |
| DarkWagashi | 3189 | 78295578524703 | 121851885184498 | 113554622444831 |

Single script-free anchored MeshPart templates, collision/touch/query/shadows disabled, white SmoothPlastic and bottom-center pivots. Full base height 2.5 studs (5 in production); mini 18/28 stud. Shiny minis reuse the face-free ordinary mini with existing sparkle treatment.
Built-in image_gen transparent inventory cutouts from supplied character references; exact prompt and paths in `assets/desserts/icons/prompts.json`. Atlas `icons/wagashi-atlas.png`, 1024px RGBA; 512px cells: 14n=(0,0), 14s=(512,0), 14s2=(0,512). Image 117055066619950; decal 99297828955434. Proof: `docs/previews/wagashi-world.png`, `wagashi-index.png`.

MintWagashi uses the RGB-identical PNG upload after the BMP image failed to load in Play. Both upload IDs are recorded in the manifest.

## Tier 15 Cheesecake and tier 16 Financier (2026-10-15)

User-supplied Meshy FBX models and reference art. The user confirmed the almond-topped Financier is the normal dessert. Full characters retain source geometry and UVs; imports remove FBX texture/video links and decorative copies contain no executable code or package links. Full templates are 2.5 studs tall (5 studs in production); minis are 18/28 studs. Textures are RGB PNG at 2048 square; Pink Quartz uses a Lanczos reduction from 4096 square. The initial 226,452-triangle Pink Quartz file was replaced by the user with the 3,043-triangle export.

| Model | Triangles | Mesh | Texture image | Decal |
|---|---:|---:|---:|---:|
| MiniCheesecake | 280 | 135477759400182 | 133121120199517 | 102641112531647 |
| NormalCheesecake | 2952 | 140485678693052 | 115306931740821 | 88603168960213 |
| RubyCheesecake | 2975 | 123828124901898 | 82168178854585 | 77026846785129 |
| MintCheesecake | 2945 | 71022699304061 | 105716955131908 | 138584057935737 |
| MiniFinancier | 296 | 90580099912135 | 136361858225832 | 83199325264977 |
| NormalFinancier | 3053 | 108395472307284 | 130526245021656 | 115906751700084 |
| GoldFinancier | 3072 | 132068985304380 | 109464385408230 | 127217241497453 |
| PinkFinancier | 3043 | 114721539735165 | 87518907195379 | 97347906821239 |

Source archive names and SHA-256 values: assets/desserts/manifest.json. All eight source FBX files and original color textures are preserved in their model folders.

Transparent icons were edited with image_gen from the user reference images; prompts and generated files are recorded in assets/desserts/icons/prompts.json. Each atlas is 1024 square with three 512-square cells. Cheesecake atlas image: 108637796798942 (decal 94394520366782). Financier atlas image: 139647408954483 (decal 108562617158850). Mint Cheesecake texture 92532618548779 failed during Play; the same PNG was reuploaded as 105716955131908.

## Tiers 17–30 — user model batch (2026-10-15)

User supplied 56 Meshy FBX archives and matching reference images from the ahdma folder and authorized applying them to the game. Creator: user-provided Meshy exports. Original files, archive paths and SHA-256 values are recorded in assets/desserts/manifest.json. Tier 19 is 크레이프 and tier 29 is 크레페 as confirmed by the user; both display Crepe in the English UI and retain separate tier identities.

Source geometry and UVs are retained (274–3,156 triangles). Import copies remove FBX texture/video links. Textures are RGB PNG, reduced to at most 2048px when needed. Each display template contains one anchored MeshPart with collision, touch, query and shadows disabled, white SmoothPlastic, and a bottom-center pivot. Full templates are 2.5 studs high (5 in production); minis are 18/28 stud. No scripts or package links are imported into display templates.

| Template | Triangles | Mesh ID | Texture image ID | Decal ID |
|---|---:|---:|---:|---:|
| Tier17Mini | 318 | 104926881958086 | 98836567653642 | 84946599008549 |
| Tier17Normal | 3013 | 70671388480453 | 111476582221337 | 132812352278384 |
| Tier17Shiny1 | 3021 | 72708633881314 | 138726533667357 | 126125122094252 |
| Tier17Shiny2 | 2969 | 111248668279335 | 110648514113069 | 129103049547603 |
| Tier18Mini | 308 | 96409869180701 | 103699297172012 | 74741594551697 |
| Tier18Normal | 2977 | 100244985337614 | 79387809515551 | 118411641201180 |
| Tier18Shiny1 | 2919 | 93448619336779 | 128276123806039 | 140599367737950 |
| Tier18Shiny2 | 3120 | 88558666485862 | 79756973729915 | 74838708851140 |
| Tier19Mini | 312 | 75514956296567 | 88231112614101 | 74046246827330 |
| Tier19Normal | 2811 | 108654765466934 | 77235270746327 | 105275815640404 |
| Tier19Shiny1 | 3091 | 84689118202426 | 135321454922983 | 131422825941667 |
| Tier19Shiny2 | 3138 | 85046223269924 | 79671938572558 | 95520402354009 |
| Tier20Mini | 293 | 108779946488385 | 126787347752559 | 75390548488838 |
| Tier20Normal | 3092 | 93378098981477 | 110366394436599 | 126301871848032 |
| Tier20Shiny1 | 2922 | 123690999276743 | 131924175871295 | 83439382902551 |
| Tier20Shiny2 | 3156 | 74711888995552 | 95971906599262 | 120899101086121 |
| Tier21Mini | 318 | 121441504591950 | 99988071557138 | 119248674032234 |
| Tier21Normal | 2996 | 140410563591834 | 116822240893534 | 97995085935147 |
| Tier21Shiny1 | 3012 | 74049839991356 | 111082826667968 | 114615136342362 |
| Tier21Shiny2 | 2969 | 87356774507160 | 110312266254910 | 135761628380172 |
| Tier22Mini | 288 | 73697029871653 | 114815895160901 | 86522736401689 |
| Tier22Normal | 3035 | 137997132232030 | 111001059418344 | 83562723534439 |
| Tier22Shiny1 | 3016 | 77248658295187 | 119459612836770 | 115836399766346 |
| Tier22Shiny2 | 3140 | 136838971491534 | 88611909906856 | 119894486623592 |
| Tier23Mini | 312 | 75336888814906 | 79678139137220 | 71967067675115 |
| Tier23Normal | 3130 | 127868473118247 | 90764159572695 | 125872812777047 |
| Tier23Shiny1 | 3011 | 87433482590830 | 132732163008490 | 115843329725975 |
| Tier23Shiny2 | 3102 | 137034704685353 | 125334444943378 | 109878837351775 |
| Tier24Mini | 294 | 125585849608286 | 136008950093413 | 88645370340884 |
| Tier24Normal | 3062 | 123621667456860 | 87951140054721 | 122657665483029 |
| Tier24Shiny1 | 3060 | 76425499713595 | 95182097507859 | 130047073951764 |
| Tier24Shiny2 | 2697 | 107715592576804 | 115161906367732 | 72006995331750 |
| Tier25Mini | 284 | 119356067858528 | 127566527690557 | 102862766957750 |
| Tier25Normal | 3034 | 135872176043533 | 81225635139237 | 114544319832892 |
| Tier25Shiny1 | 2968 | 105247689939765 | 106184823756112 | 91018881774483 |
| Tier25Shiny2 | 3110 | 75867147817249 | 104274632519255 | 88911794794466 |
| Tier26Mini | 310 | 99489272029974 | 119869986031885 | 75476927996888 |
| Tier26Normal | 3015 | 74417296150018 | 77327312557293 | 127790748602918 |
| Tier26Shiny1 | 2886 | 121989820280607 | 116146606734706 | 139744776758986 |
| Tier26Shiny2 | 2920 | 131705375618054 | 126314000753281 | 76731085496148 |
| Tier27Mini | 312 | 125998872783914 | 115919721520976 | 82553895648567 |
| Tier27Normal | 3085 | 116880914311353 | 95348138265978 | 91383557962755 |
| Tier27Shiny1 | 2932 | 103473537686518 | 94640918623657 | 72980202315068 |
| Tier27Shiny2 | 3110 | 70611214912148 | 82871330969341 | 122611708275101 |
| Tier28Mini | 274 | 135628776011544 | 123536602752986 | 70508354083135 |
| Tier28Normal | 2880 | 84904754571642 | 117808311046112 | 80065194124546 |
| Tier28Shiny1 | 2875 | 118195625333813 | 72904074656253 | 79296880584090 |
| Tier28Shiny2 | 3106 | 119057562010480 | 71558884773273 | 129304276721248 |
| Tier29Mini | 310 | 106889000562322 | 93978088925047 | 133696527955476 |
| Tier29Normal | 2942 | 119957294222147 | 135292353403740 | 78880962734510 |
| Tier29Shiny1 | 2960 | 75724374143317 | 95092092132067 | 139105232794555 |
| Tier29Shiny2 | 2962 | 121659396469701 | 76777846129798 | 91077279878030 |
| Tier30Mini | 292 | 118126865541640 | 86592871605794 | 91942787551273 |
| Tier30Normal | 3133 | 133507261298020 | 106772955477484 | 109824436337995 |
| Tier30Shiny1 | 3062 | 89934940961257 | 111219524848129 | 113850649831050 |
| Tier30Shiny2 | 3010 | 134395282247813 | 84737817423491 | 70596269610186 |

Fourteen 1024px transparent PNG atlases contain normal, shiny 1 and shiny 2 in the upper-left, upper-right and lower-left 512px cells. User reference art was edited with built-in image_gen to remove backgrounds; exact prompt and generated filenames are in assets/desserts/icons/batch-17-30-generated.json. Final paths: assets/desserts/icons/t17-atlas-transparent.png through t30-atlas-transparent.png. Roblox image/decal IDs are in batch-17-30-atlases.json.

Ten initially uploaded textures failed in Play. RGB-identical PNGs were reuploaded and all 120 model templates subsequently passed ContentProvider loading with zero failures. Superseded texture IDs remain in batch-17-30.json.

## Promotional artwork — text-free launch set (2026-10-15)

User requested an icon, banner and multiple acquisition-focused promotional images, then explicitly chose character-focused artwork without text. Created six images with built-in image_gen using existing approved pudding, cheesecake and croffle artwork plus the actual mint-conveyor world screenshot as references. These are stylized promotional illustrations, not gameplay screenshots. No new in-game assets or mechanics were installed.

Files: assets/marketing/launch-v1/originals/ (six generated originals), ready-to-upload/ (two 512-square icons and four 1920x1080 banners/promos, PNG plus landscape JPEG), preview.jpg (150px icon / 480px banner comparison), dessert-tycoon-promo-pack.zip (upload files). Complete prompts and source references: assets/marketing/launch-v1/prompts.json. Landscape originals were 1672x941 and resized to 1920x1080; square originals were 1254x1254 and downscaled to 512x512.

Recommended starting combination: 01-icon-pudding and 03-banner-world. Alternative icon: 02-icon-galaxy. Supplemental promos: 04-promo-merge (three puddings to custard), 05-promo-shiny (normal and two croffle variants), 06-promo-factory (characters producing faceless minis). Recommendation is visual judgment; click-through performance has not yet been measured.

Roblox size guidance checked: https://create.roblox.com/docs/production/publishing/experience-icons and https://create.roblox.com/docs/production/publishing/thumbnails. Six outputs visually inspected at original and reduced preview sizes; no text, clear main faces, correct intended proportions. Upload copies are under 3 MB each.

## Tutorial and pickup feedback — 2026-10-16

User explicitly requested arrow-based onboarding and mini-dessert pickup audio. Local neon chevrons and a down-arrow glyph are code-native guidance, created for that request; no imported models or scripts. Pickup audio reuses Roblox's bundled `rbxasset://sounds/volume_slider.ogg` (already used for approved click feedback), playback speed 1.5, effects-volume gain .45, .12-second minimum retrigger interval. No external audio upload or new marketplace dependency.

## Code-only fish companions — 2026-10-16

User-supplied Meshy cookie, chocolate and rainbow fish FBX archives and reference images. Sources, hashes, triangle counts and Roblox asset IDs: `assets/code-pets/manifest.json`. Uploaded geometry has 3043 / 2958 / 2967 triangles; embedded FBX video textures stripped for import and RGB color textures resized to at most 2048 pixels. Geometry and UVs retained. Templates CookieFish, ChocolateFish, RainbowFish use 2.5-stud height, bottom pivot, no executable descendants, no collisions or miniature production. Reference images form the 1024-square code-fish-atlas.png. Companion-only ownership stays separate from tier progression and index entries appear only after redemption.

Tutorial chevrons and target arrow now use RGB(0,105,50), as explicitly requested.


## 2026-10-18 release asset access
- Reused the approved existing UI images from assets/ui/manifest.json for all 16 passes and five developer products; no new art was commissioned. All 21 Marketplace records return nonzero icon asset IDs.
- Existing user-supplied chef Walking animation 79831780716711 was granted usage by the Cosmon Studio universe 10771069736. No replacement animation or geometry. AnimationClipProvider successfully loaded KeyframeSequence (27 children) after the grant.


2026-10-18 patch: reused approved BryanROBLOXgamer10 StreetLamp asset 11146095708; promenade migration 3 turns each of 24 heads toward its neighboring plot area. Original creator/link/cleanup requirements unchanged. Discovery loading fallback reuses the previously approved DessertImages reference atlas. No new art imported.
