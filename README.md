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
- 중앙 스폰, 줄무늬 차양 디저트 가게, 얼굴이 있는 대형 푸딩
- 중앙에서 60도 간격으로 배치한 동일 크기의 6개 구역과 크림색 길
- 각 구역은 70×70 studs이며 중앙 통로 양쪽에 생산 트레이 5개씩 배치했습니다. 트레이마다 디저트 자리 3개로 총 30칸입니다.
- 입구에 1/5/25/100개 구매 버튼 자리와 합성 보드(슬롯 3개)를 배치했습니다. 버튼은 아직 실제 구매 기능과 연결되지 않았습니다.
- 솜사탕 나무 24그루, 마시멜로 덤불, 설탕 꽃, 구름
- 오후 2시 조명, 약한 블러/색 보정/블룸, 따뜻한 반짝임과 하트 장식
- 투명한 섬 가장자리 안전벽
- 무료 Creator Store 벤치 6개, 꽃 모델 60개, 개인 구역 입구와 소유자 표지판
- 무료 벚꽃 나무 12그루와 확장된 원형 섬(지름 348 studs)
- 무료 하트 케이크 모델 전시 장식 8개

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
| PetSpawnPads.PetPad1–30 / SlotIndex | 향후 생산 디저트 배치 |
| MergeBoard / RequiredCount = 3 | 동일 디저트 3개 합성 기능 연결 |
| ProductionBeds.LeftRow1–5 / RightRow1–5 | 중앙 통로 양쪽의 생산 트레이 |
| PurchaseButtons.Buy1 / Buy5 / Buy25 / Buy100 | PurchaseCount 속성을 가진 구매 버튼 자리 (GameplayConnected=false) |
| CentralHub.CentralShop | 원형 배치의 기준점, 향후 랜덤 상자/상점 연결 |

현재는 **맵과 구역 배정**을 구현했습니다. 생산, 화폐, 랜덤 상자, 실제 합성, 데이터 저장은 아직 구현하지 않았습니다. 젤리 마스코트는 장식입니다.

## 디저트 30단계

`ReplicatedStorage.DessertCatalog` (`src/shared/DessertCatalog.luau`)에 요청한 순서를 저장했습니다. 푸딩을 1단계로 계산하므로 30단계 페르페 용의 푸딩 환산량은 `3^29 = 68,630,377,364,883`입니다. 세 마리를 하나로 합성하면 보관 개수가 줄어들므로 이 환산량만큼 물리적인 칸을 만들 필요는 없습니다. 실제 획득/생산 속도는 별도 밸런싱이 필요합니다.

구역의 30칸은 30종을 보여 주고 생산하게 할 기본 공간입니다. 목록 데이터는 모델/생산 기능을 구현한 것이 아닙니다. 기본 자동 생성기(Rojo)에는 아직 구형 6칸 기본 구역이 있고, 확장·무료 소품 버전은 저장된 장소 파일에 포함됩니다.

## 서버 최대 인원

구역 6개와 서버 인원 제한은 별도 설정입니다. 게시한 경험의 Creator Dashboard에서 해당 Place의 최대 플레이어 수를 **6**으로 설정하고 저장하세요. 맵 Script는 서버 정원을 변경하지 않습니다.

## 유지 관리

비활성화된 기본 생성기는 `DessertJellyIsland`를 교체합니다. 구역 할당기는 모델을 삭제하거나 맵을 재생성하지 않습니다. `tools/DecorateInStudio.luau`는 무료 모델을 먼저 가져온 다음 편집 모드에서 한 번 실행하는 꾸미기 도구입니다. 런타임 Script로 넣지 마세요.

무료 모델 출처 및 적용 내역: `docs/ASSETS.md`.

`tools/RestyleProductionPlotsInStudio.luau`는 저장된 확장 맵을 이미지 참고 배치로 바꾼 편집용 도구입니다. Play를 정지한 뒤 Command Bar에서 실행하며, 저장된 장소에는 이미 적용되어 있습니다. 기본 생성기와 별개입니다.

디자인은 독자적인 디저트 테마이며 다른 게임의 모델/이미지를 복사하지 않습니다.
