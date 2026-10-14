# Dessert & Jelly Island

Roblox 파스텔 디저트 방치형 타이쿤의 실행 가능한 v11 프로토타입입니다. 모든 게임 문구는 영어입니다.

## Studio 실행

1. `DessertIsland.rbxlx`를 Roblox Studio에서 열고 Play를 누르세요.
2. PlotAllocator가 CentralShop 위치를 기준으로 6개 구역을 배정합니다. 중앙의 CentralDisplay는 나중에 제공할 모델용으로 비워 두었습니다.
3. 각 구역에는 개인 카페, 상점, 상자, R 수집 발판과 60개 원형 접시가 있습니다. 왼쪽/오른쪽 각각 5줄 × 6칸입니다. 바닥 96×120 studs, 섬 지름 460 studs입니다.
4. Buy 1/10/100/1000은 푸딩을 구매하고 자동 병합합니다. 같은 일반/이로치 디저트 3개가 다음 단계 하나가 됩니다. M은 가능한 병합을 모두 실행합니다.
5. 디저트는 3초마다 자신과 같은 미니 디저트를 만듭니다. 경사로 → 중앙 통로 → 앞쪽 접시에 모이며, 가까이 가면 가방에 수집됩니다. 카페에서 팔고 R에서 돈을 받으세요.

무료 상자는 5시간마다 일반 상자 1개, Premium은 같은 시점에 일반 1개와 특혜 1개를 받습니다. AFK 일반 상자는 별도로 누적 잠수 5시간마다 지급합니다. 첫 선물은 첫 접속 5시간 후이며 오프라인 중 지난 여러 주기를 무제한 누적하지 않습니다.

도감에는 일반/이로치 발견이 기록되고 펫을 장착할 수 있습니다. 새 디저트 발견 시 3D 모델과 하트/별 효과가 나타납니다. 설정에서 배경음, 효과음, 다른 플레이어 펫 표시를 바꿀 수 있습니다.

## 현재 결제·저장 상태

아직 상품 ID가 없으므로 `TycoonConfig`의 모든 ID는 0이며 실제 Robux 구매는 UI와 서버 모두 잠겨 있습니다. 요청한 가격과 구매 처리는 준비되어 있습니다. ID 등록 후 UI는 실제 지역별 가격을 조회합니다.

Studio에서는 임시 세션 데이터로 테스트합니다. 게시된 서버에는 DataStore 세션 잠금/자동 저장/종료 저장과 영수증 중복 방지가 구현되어 있지만, 실제 게시 환경 및 결제 검증은 ID 등록 이후 필요합니다. 게시 경험의 최대 인원은 Creator Dashboard에서 6명으로 설정하세요. 추가 Studio 인원은 빈 구역이 생길 때까지 대기합니다.

## 코드

- `src/server/DessertGame.server.luau`: 권한 검증, 생산·수집·판매·돈, 상자, 결제 처리
- `src/server/PlayerProfiles.luau`: 저장과 세션 잠금, 영수증 기록
- `src/client/DessertClient.client.luau`: 영어 HUD, 도감, 설정, 상점, 상자, 발견 연출
- `src/shared/TycoonConfig.luau`: 5시간 지급 주기, 3초 생산 주기, 가격, 상품 ID, 음원
- `src/shared/DessertRules.luau`: 병합, 확률, 지급과 AFK 누적 규칙
- `src/shared/DessertVisuals.luau`: 교체 가능한 30단계 기본 디저트 모델과 이로치
- `src/shared/ProductionPlot.luau`: 원형 접시, 생산 경사로, 카페 앞 발판 배치

저장된 장소의 기본 생성기 `DessertIsland`와 이전 `DessertProduction`은 비활성화되어 있습니다. Rojo 프로젝트는 새 장소에서 네이티브 맵을 생성합니다. 무료 Creator Store 소품/원본 템플릿까지 포함된 완성 배치는 `.rbxlx`에 있습니다.

세부 지급·확률·저장 규칙과 한계는 [GAMEPLAY](docs/GAMEPLAY.md), 무료 에셋과 음원 출처는 [ASSETS](docs/ASSETS.md), 변경 이력은 [WORKLOG](docs/WORKLOG.md)를 참고하세요.

## 검증

Edit mode에서 `tests/DessertRules.studio.luau`, `tests/ProductionPlot.studio.luau`, `tests/IslandLandscape.studio.luau`를 실행합니다. Play의 서버 Command Bar에서 `tests/DessertGame.studio.luau`를 실행하면 발판 구매, 병합, 생산, 수집, 판매, R 지급, 펫, 설정, 결제 잠금을 검증합니다. 이전 버전의 테스트들은 해당 버전의 기록용입니다.
