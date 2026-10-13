# Dessert & Jelly Island

귀여운 파스텔 디저트 방치형 타이쿤의 첫 번째 맵입니다. 서버당 목표 인원은 **6명**입니다.

## 실행

1. `DessertIsland.rbxlx`를 Roblox Studio에서 엽니다.
2. 저장된 파일에는 편집용 맵이 포함되어 있습니다. Play를 누르면 `ServerScriptService.DessertIsland`가 같은 맵을 다시 생성합니다.
3. 별도 장소에서는 `src/server/DessertIsland.server.luau` 내용을 일반 **Script**에 붙여 넣고 ServerScriptService에 넣습니다. Workspace에서도 실행 가능합니다.
4. 편집 모드에서 미리 생성하려면 Studio Command Bar에서 `loadstring(game.ServerScriptService.DessertIsland.Source)()`를 실행합니다.

Rojo를 사용하는 경우 `default.project.json`을 사용합니다. 외부 모델/플러그인 설치 없이 기본 Parts, GUI, 내장 sparkle texture로 구성됩니다.

## 맵 구성

- 민트 아이싱, 핑크/라벤더 케이크 층의 둥근 공중 섬
- 중앙 스폰, 줄무늬 차양 디저트 가게, 얼굴이 있는 대형 푸딩
- 중앙에서 60도 간격으로 배치한 동일 크기의 6개 구역과 크림색 길
- 각 구역에 디저트 패드 6개와 합성 슬롯 3개
- 솜사탕 나무 24그루, 마시멜로 덤불, 설탕 꽃, 구름
- 오후 2시 조명, 약한 블러/색 보정/블룸, 따뜻한 반짝임과 하트 장식
- 투명한 섬 가장자리 안전벽

## 게임플레이 연결 지점

`Workspace.DessertJellyIsland.PlayerPlots.Plot01`부터 `Plot06`까지 존재합니다.

| 오브젝트/속성 | 용도 |
| --- | --- |
| PlotId / OwnerUserId = 0 | 구역 번호와 향후 소유자 배정 |
| PetSpawnPads.PetPad1–6 / SlotIndex | 향후 생산 디저트 배치 |
| MergeBoard / RequiredCount = 3 | 동일 디저트 3개 합성 기능 연결 |
| CentralHub.DessertShop | 향후 랜덤 상자/상점 연결 |

현재는 **맵만 구현**했습니다. 생산, 화폐, 랜덤 상자, 실제 합성, 저장, 소유권 배정은 아직 구현하지 않았습니다. 젤리 마스코트는 장식입니다.

## 서버 최대 인원

구역 6개와 서버 인원 제한은 별도 설정입니다. 게시한 경험의 Creator Dashboard에서 해당 Place의 최대 플레이어 수를 **6**으로 설정하고 저장하세요. 맵 Script는 서버 정원을 변경하지 않습니다.

## 유지 관리

재실행하면 자신이 생성한 `DessertJellyIsland`만 교체합니다. 다른 맵 오브젝트는 삭제하지 않습니다. 조명 효과도 이름으로 재사용합니다. 기존 장소에 추가할 때 기존 Baseplate와 SpawnLocation은 직접 정리하거나 비활성화하세요.

디자인은 독자적인 디저트 테마이며 다른 게임의 모델/이미지를 복사하지 않습니다.
