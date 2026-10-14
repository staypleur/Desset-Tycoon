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
