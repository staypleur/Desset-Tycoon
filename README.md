# Dessert & Jelly Island

귀여운 파스텔 디저트 방치형 타이쿤의 첫 번째 맵입니다. 서버당 목표 인원은 **6명**입니다.

## 실행

1. `DessertIsland.rbxlx`를 Roblox Studio에서 엽니다.
2. 저장된 파일에는 꾸민 맵과 `ServerScriptService.PlotAllocator`가 포함되어 있습니다. Play를 누르면 자동 구역 배정이 실행됩니다. 기존 `DessertIsland` 생성기는 편집된 맵을 보호하기 위해 비활성화했습니다.
3. 별도 장소에서는 `src/server/DessertIsland.server.luau` 내용을 일반 **Script**에 붙여 넣고 ServerScriptService에 넣습니다. Workspace에서도 실행 가능합니다.
4. 원래 기본 맵을 다시 생성하려면 Studio Command Bar에서 `loadstring(game.ServerScriptService.DessertIsland.Source)()`를 실행합니다. 이 작업은 편집된 섬을 기본 맵으로 교체하므로 별도 복사본에서 사용하세요.

Rojo의 `default.project.json`은 기본 자동 생성 맵과 구역 할당기를 구성합니다. Creator Store 소품까지 포함된 버전은 `DessertIsland.rbxlx`를 사용하세요.

## 맵 구성

- 민트 아이싱, 핑크/라벤더 케이크 층의 둥근 공중 섬
- 중앙 스폰과 비어 있는 중앙 전시 공간, 개인 카페의 줄무늬 차양과 얼굴이 있는 대형 푸딩
- 중앙에서 60도 간격으로 배치한 동일 크기의 6개 구역과 크림색 길
- 각 구역은 70×70 studs이며 중앙 통로 양쪽에 생산 트레이 5개씩 배치했습니다. 트레이마다 디저트 자리 3개로 총 30칸입니다.
- 입구에 구매 버튼과 합성 보드(슬롯 3개)가 있습니다. 가까이서 ProximityPrompt로 구매·합성·수익 수집을 실행합니다.
- 중앙 카페의 원래 모습(대형 푸딩 포함)을 각 구역 입구에 하나씩 배치했습니다. 카페는 중앙을 등지고 생산 구역을 바라보며, 구매·합성·수익·상자 발판은 카페 주변에 모았습니다. 옆쪽 입구로 카페를 돌아 들어갑니다.
- 솜사탕 나무 24그루, 마시멜로 덤불, 설탕 꽃, 구름
- 오후 2시 조명, 약한 블러/색 보정/블룸, 따뜻한 반짝임과 하트 장식
- 투명한 섬 가장자리 안전벽
- 무료 Creator Store 꽃 모델 48개, 개인 카페 소유자 표지판 (벤치 템플릿은 보관)
- 무료 벚꽃 나무 12그루와 확장된 원형 섬(지름 348 studs)
- 무료 하트 케이크 모델 전시 장식 6개
- 구역별 낮은 공급 컨베이어 10줄과 중앙 컨베이어 1줄, 생산 바닥과 이동용 다리
- 모든 게임 표시 문구 및 디저트 이름은 영어입니다.

## 자동 구역 배정 시스템

`src/server/PlotAllocator.server.luau` 하나를 일반 Script로 ServerScriptService에 넣으세요. 새 맵을 만들지 않고 **기존 모델**을 사용합니다.

- Workspace 하위 어디에나 고유한 `CentralShop` Model과 `Plot1`~`Plot6` Model이 있으면 작동합니다.
- 서버 시작 시 `CentralShop:GetPivot().Position`의 X/Z를 중심으로 반경 108 studs, 60도 간격으로 배치합니다. 각 구역의 기존 높이는 보존합니다. `PrimaryPart` 또는 모델 pivot을 바닥 중심으로 맞추세요.
- 입장 시 빈 구역 하나를 서버에서 예약하며, 중복 배정하지 않습니다.
- `PlotSpawn` BasePart, 없으면 `Entrance` BasePart로 캐릭터를 이동합니다. 리스폰 때도 같은 구역으로 이동합니다.
- 퇴장 시 소유자 속성과 연결을 해제합니다. 7명 이상 입장하면 초과 인원은 중앙에서 기다리며, 빈 구역이 생기면 입장 순서대로 배정합니다.
- `player:GetAttribute("PlotId")`와 `plot:GetAttribute("OwnerUserId")`로 다른 서버 게임 로직에 연결합니다. 실제 생산/합성 권한도 서버에서 검증해야 합니다.
- `OwnerLabel` TextLabel이 있으면 소유자 표시를 갱신합니다.
- 모델 누락은 최대 30초 기다린 뒤 오류를 표시합니다. 중복 이름은 즉시 오류로 처리합니다.

상점 이동은 **편집 모드에서 이동 후 새 서버를 시작**할 때 반영됩니다. 진행 중인 서버에서 실시간으로 구역을 계속 움직이지 않습니다. 할당은 서버 세션 동안 유지되며 재접속 시 같은 구역 번호를 보장하지 않습니다.

`tests/PlotAllocator.studio.luau`는 임시 모델과 모의 플레이어로 중심 좌표 이동, 높이 유지, 6명 배정, 초과 대기, 반환/재배정, 중복 입장, 캐릭터 이동/리스폰을 검증합니다.

## 게임플레이 연결 지점

`Workspace.DessertJellyIsland.PlayerPlots.Plot1`부터 `Plot6`까지 존재합니다.

| 오브젝트/속성 | 용도 |
| --- | --- |
| PlotId / OwnerUserId | 구역 번호와 현재 소유자 (0이면 비어 있음) |
| PetSpawnPads.PetPad1–30 / SlotIndex / DropLaneZ | 디저트 위치 및 생산 상품 공급 경로 |
| MergeBoard / RequiredCount = 3 | 동일 단계 3개를 다음 단계 1개로 합성 |
| ProductionBeds.LeftRow1–5 / RightRow1–5 | 낮은 공급 벨트 옆의 높인 생산 바닥 |
| PurchaseButtons.Buy1 / Buy5 / Buy25 / Buy100 | 구매 요청 수량; 가격/돈/남은 칸 검증 후 전체 수량 구매 |
| PersonalShopArea.DessertCafe | 각 구역 입구의 전체 카페, PlotId 속성으로 구역 식별 |
| PersonalShopArea.CollectIncome / DessertCrate | 수익 수집 / 향후 랜덤 상자 자리 (상자는 GameplayConnected=false) |
| Conveyors.Collector / PendingCash | 벨트 도착 상품의 수익이 쌓이는 수집함 |
| ActiveDesserts / MovingDesserts | 플레이 모드의 생산 디저트와 이동 중인 상품 |
| CentralHub.CentralShop.CenterAnchor | 원형 배치 기준점을 유지하는 투명 Part; 이동 시 다음 서버에서 반영 |
| CentralHub.CentralDisplay | 나중에 제공할 중앙 모델을 넣을 빈 Model; 기준점과 독립적 |

현재는 **맵·구역 배정·세션 생산 루프**를 구현했습니다. 입장 시 푸딩 1개와 $25를 지급합니다. 디저트는 5초마다 미니 상품을 생산하고, 상품은 낮은 공급 벨트 → 중앙 벨트 → 카페 앞 수집함으로 이동합니다. 도착 때만 수익을 추가하며 수집 시 Cash로 옮깁니다. 수집함과 카페 옆 Collect Earnings 발판 모두 이용할 수 있습니다.

푸딩 가격은 개당 $5이며 구역 최대 수용량은 30개입니다. 1/5/25/100개 버튼은 돈과 빈칸이 충분할 때만 전체 구매를 처리합니다. 100개 구매는 현재 30칸 수용량에서 실행되지 않습니다. 합성은 가장 낮은 단계부터 같은 단계 3개를 찾아 1개로 올립니다. 단계별 상품 가치는 `2^(Tier-1)`이며 임시 밸런스입니다.

소유자·캐릭터 거리·재실행 간격은 서버에서 검사합니다. 퇴장/구역 반환 시 디저트와 이동 상품을 정리해 다음 소유자에게 이전 수익이 넘어가지 않습니다. 돈·디저트는 서버 세션에서만 유지되며 재접속 시 초기화합니다. 랜덤 상자, 영구 저장, 오프라인 수익은 아직 구현하지 않았습니다.

## 디저트 30단계

`ReplicatedStorage.DessertCatalog` (`src/shared/DessertCatalog.luau`)에 요청한 순서를 저장했습니다. 푸딩을 1단계로 계산하므로 30단계 페르페 용의 푸딩 환산량은 `3^29 = 68,630,377,364,883`입니다. 세 마리를 하나로 합성하면 보관 개수가 줄어들므로 이 환산량만큼 물리적인 칸을 만들 필요는 없습니다. 실제 획득/생산 속도는 별도 밸런싱이 필요합니다.

게임 표시 이름은 Pudding부터 Parfait Dragon까지 영어입니다. 현재 디저트 외형은 귀여운 푸딩 모양을 공통 사용하고 단계마다 색과 이름을 변경합니다. 30종 각각의 고유 외형은 아직 만들지 않았습니다. 기본 생성기(Rojo)에는 구형 6칸 구역이 있으므로 최신 컨베이어 플레이는 저장된 장소 파일을 사용하세요. 기본 장소에서는 생산 스크립트가 컨베이어 누락을 안내하고 종료합니다.

## 서버 최대 인원

구역 6개와 서버 인원 제한은 별도 설정입니다. 게시한 경험의 Creator Dashboard에서 해당 Place의 최대 플레이어 수를 **6**으로 설정하고 저장하세요. 맵 Script는 서버 정원을 변경하지 않습니다.

## 유지 관리

비활성화된 기본 생성기는 `DessertJellyIsland`를 교체합니다. 구역 할당기는 모델을 삭제하거나 맵을 재생성하지 않습니다. `tools/DecorateInStudio.luau`는 무료 모델을 먼저 가져온 다음 편집 모드에서 한 번 실행하는 꾸미기 도구입니다. 런타임 Script로 넣지 마세요.

무료 모델 출처 및 적용 내역: `docs/ASSETS.md`.

`tools/RestyleProductionPlotsInStudio.luau`는 저장된 확장 맵을 이미지 참고 배치로 바꾼 편집용 도구입니다. Play를 정지한 뒤 Command Bar에서 실행하며, 저장된 장소에는 이미 적용되어 있습니다. 기본 생성기와 별개입니다.

`tools/AddPersonalShopsInStudio.luau`는 생산 줄 간격을 조정하고 개인 가게 6개를 추가한 후 구역 경계 및 생산 구역과의 분리를 검증합니다. 저장된 장소에는 이미 적용되어 있습니다.

최신 배치는 입구 카페에 `tools/BuildConveyorsInStudio.luau`를 추가 적용한 버전입니다. 원래 카페 소스는 `ServerStorage.CentralCafeTemplate`에 보관합니다. 벨트를 가리던 장식 마스코트는 `ServerStorage.DecorativeMascots`로 옮겼습니다.

`tests/EntranceCafeLayout.studio.luau`, `tests/ConveyorLayout.studio.luau`는 중앙 예약 공간·카페 방향·180개 위치·벨트 높이·영어 문구를 검사합니다. `tests/DessertProduction.studio.luau`는 임시 구역과 모의 플레이어로 구매, 소유권/거리/돈/칸 제한, 합성, 상품 도착, 수집, 중복 수집 방지, 소유자 변경 정리를 검사합니다. 테스트는 편집 모드 Command Bar에서 실행하며 런타임 Script로 넣지 마세요.

디자인은 독자적인 디저트 테마이며 다른 게임의 모델/이미지를 복사하지 않습니다.
