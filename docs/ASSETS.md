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
