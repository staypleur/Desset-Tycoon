# Dessert & Jelly Island

Roblox 파스텔 디저트 방치형 타이쿤의 실행 가능한 v14 프로토타입입니다. 모든 게임 문구는 영어입니다.

## Studio 실행

1. `DessertIsland.rbxlx`를 Roblox Studio에서 열고 Play를 누르세요.
2. PlotAllocator가 CentralShop 위치를 기준으로 6개 구역을 배정합니다. 중앙의 CentralDisplay는 나중에 제공할 모델용으로 비워 두었습니다.
3. 중앙에는 사진을 참고한 열린 원형 카운터, 매달린 조명, 천장을 덮는 얼굴 없는 3단 케이크, 여섯 투입 발판과 벤치가 있습니다. 각 구역에는 입체 SHOP/BANK 글자, 상점 옆 무료 상자, 은행의 R 수령/업그레이드 발판, 흰 울타리, 60개 원형 접시가 있습니다. 왼쪽/오른쪽 각각 5줄 × 6칸입니다. 바닥 128×120 studs, 섬 지름 560 studs이며 중앙부터 입구까지 길이 일직선으로 이어집니다.
4. Buy 1/10/100/1000은 푸딩을 구매하고 자동 병합합니다. 같은 일반/이로치 디저트 3개가 다음 단계 하나가 됩니다. M은 가능한 병합을 모두 실행합니다.
5. 디저트는 3초마다 자신과 같은 미니 디저트를 만듭니다. 경사로 → 중앙 통로 → 앞쪽 접시에 모이며, 가까이 가면 가방에 수집됩니다. 중앙의 자기 구역 투입 발판에서 전부 넣으면 2초마다 남은 대기량의 10%를 돈으로 바꿉니다. R 첫 발판에서 돈을 받고 두 번째에서 환전 속도를 올립니다. 첫 업그레이드는 $25, 이후 가격은 두 배, 비율은 5%p씩 올라 최대 100%입니다. 상점은 E를 0.8초 누르면 열립니다.

무료 상자는 5시간마다 일반 상자 1개, Premium은 같은 시점에 일반 1개와 특혜 1개를 받습니다. AFK 일반 상자는 별도로 누적 잠수 5시간마다 지급합니다. 첫 선물은 첫 접속 5시간 후이며 오프라인 중 지난 여러 주기를 무제한 누적하지 않습니다.

도감에는 일반/이로치 발견이 기록되고 펫을 장착할 수 있습니다. 새 디저트 발견 시 3D 모델과 하트/별 효과가 나타납니다. 설정에서 배경음, 효과음, 다른 플레이어 펫 표시를 바꿀 수 있습니다.

승인받은 무료 Hapy UI 이미지와 MIT Laurel/Tabler 아이콘, FredokaOne 글꼴을 사용합니다. 구매 발판 네 개는 수집함 앞 같은 가로줄에 있으며, 무료 Tycoon Button Pack의 둥근 윗판과 어두운 받침, 작은 제목/가격 두 줄을 사용합니다. 구매/환전 업그레이드 발판은 돈이 충분하면 초록색, 부족하면 빨간색입니다. 구매·병합·투입·은행 발판에는 E 프롬프트가 없고 밟으면 작동합니다. 상점은 보이지 않는 건물 입구 앵커에서 E를 누르며, 상점 앞 구매 발판은 없습니다.

접시 밑 초록색 땅과 접시는 뒤로 갈수록 함께 높아집니다. 양옆 경사로와 가운데 세로 경사로는 모두 노란색이며 앞 수집함으로 내려갑니다. 케이크 위 영어 UI에 카페 판매 배율과 다음 변경까지 남은 시간이 표시됩니다. 서버 전체 배율은 30초마다 0.5~1.5배(0.1 간격) 중 다른 값으로 바뀝니다. 투입 순간 가방 전체 × 배율이 환전 대기량에 들어가며, 이후 배율 변화는 이미 넣은 양에 영향을 주지 않습니다. 소수 수량과 돈도 보존됩니다.

기본 거리형 음성 채팅용 `VoiceChatService.EnableDefaultVoice=true`, `UseAudioApi=Enabled`를 장소에 설정했습니다. 현재 로컬 장소는 경험/장소 ID가 0이므로 실제 음성 통화는 아직 검증할 수 없습니다. 경험 게시 후 Studio **File → Experience Settings → Communication → Enable Voice Chat** 설정을 확인하고 게시해야 합니다. 이용 가능한 플레이어는 Roblox 기본 마이크/음소거 UI를 사용합니다. 계정의 마이크 권한·음성 이용 자격을 코드로 강제하지 않습니다. [공식 안내](https://create.roblox.com/docs/chat/voice-chat)

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
- `src/shared/CentralCafeLayout.luau`: 중앙 카페, 넓은 구역, 직선 길, 은행·상점과 벤치
- `src/shared/DessertUI.luau`: 무료 아이콘, 파스텔 UI/말풍선, 가격별 발판 색상
- `src/shared/ReferenceStyle.luau`: 열린 카페, 대형 케이크, 무료 소스 장식, 울타리, 전체 경사와 가로 발판
- `src/shared/CafeMarket.luau`: 서버 판매 배율의 30초 변경 규칙

저장된 장소의 기본 생성기 `DessertIsland`와 이전 `DessertProduction`은 비활성화되어 있습니다. Rojo 프로젝트는 새 장소에서 네이티브 맵을 생성합니다. 무료 Creator Store 소품/원본 템플릿까지 포함된 완성 배치는 `.rbxlx`에 있습니다.

세부 지급·확률·저장 규칙과 한계는 [GAMEPLAY](docs/GAMEPLAY.md), 무료 에셋과 음원 출처는 [ASSETS](docs/ASSETS.md), 변경 이력은 [WORKLOG](docs/WORKLOG.md)를 참고하세요.

## 검증

Edit mode에서 `tests/CentralCafe.studio.luau`를 실행합니다. Play의 서버 Command Bar에서 `tests/DessertGame.studio.luau`를 실행하면 발판 구매, 병합, 생산, 수집, 중앙 투입과 2초 환전, R 지급, 업그레이드, 펫, 설정, 결제 잠금을 검증합니다. 이전 버전의 배치 테스트들은 해당 버전의 기록용입니다.
