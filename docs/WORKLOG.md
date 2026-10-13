# 작업 기록

## 2026-10-14 — 맵 기반 v1

- 요청한 저장소가 비어 있음을 확인하고 새 프로젝트를 구성했습니다.
- Instance.new 기반 서버 자동 생성 Script와 Studio 장소 파일을 추가했습니다.
- 중앙 디저트 가게 및 푸딩, 원형 6개 구역, 패드 36개, 합성 보드 6개를 구현했습니다.
- 맵 구조 검증 assert를 포함했습니다. 실행 시 Output에 성공 메시지가 표시됩니다.
- Windows 원격제어로 Roblox Studio를 열고 생성 명령을 실행했습니다.
- 처음 조명이 과하게 밝아 보여 Ambient/OutdoorAmbient 및 노출을 조정했습니다.
- 편집 모드에서 완성된 맵을 시각 확인하고 `DessertIsland.rbxlx`에 저장했습니다.
- Play 모드에서 중앙 스폰에 캐릭터가 정상 등장하고 가게/푸딩/주변 구역이 보임을 확인했습니다.
- 서버 실행 로그에서 `[DessertIsland] Built 6 plots, 36 pet pads, central shop and pudding. Map v1.0.0` 성공 메시지를 확인했습니다. 맵 Script 실행 오류는 발견되지 않았습니다.
- Studio 자체의 채팅/소셜 API 네트워크 경고는 맵 기능과 별개입니다.
- 플레이 테스트 종료 후 편집 모드 전체 섬 미리보기를 열어 두었습니다.
- 최대 인원 6명은 게시한 Place 설정에서 적용해야 합니다. Roblox 경험은 아직 게시하지 않았습니다.

다음 단계: 구역 배정 → 생산/화폐 → 랜덤 상자 → 동일 디저트 3개 합성 → 데이터 저장.

## 2026-10-14 — 구역 할당과 무료 소품 꾸미기

- 열린 Studio 맵에서 기존 이름 `DessertShop`, `Plot01`~`Plot06`을 확인했습니다. 동일 모델을 `CentralShop`, `Plot1`~`Plot6`으로 변경했습니다.
- `PlotAllocator.server.luau` 하나로 상점 중심 원형 배치, 입장 배정, 소유자 표시, 퇴장 반환, 초과 인원 대기, 리스폰 이동을 구현했습니다.
- 기본 생성기는 비활성화하여 편집된 맵이 시작할 때 초기화되지 않게 했습니다.
- Toolbox의 무료 벤치와 꽃 모델을 검사하고 중앙 벤치 6개, 꽃 60개, 구역 입구와 표지판으로 꾸몄습니다. 출처는 ASSETS.md에 기록했습니다.
- 초기 모의 테스트는 BindableEvent가 table을 복사해 객체 식별이 달라져 실패했습니다. 모의 신호를 수정한 뒤 모든 항목 PASS를 확인했습니다.
- 테스트 통과: 이동한 상점 기준 반경/높이 유지, 6명 중복 없는 배정, 7번째 대기, 퇴장 반환 및 재배정, 중복 입장, 연결 해제, 캐릭터 이동/리스폰.
- 실제 Play 모드에서 플레이어에게 Plot1이 배정되고 이름이 입구 표지판에 표시되는 것을 확인했습니다. Roblox 메뉴의 리스폰 후에도 같은 Plot1 입구로 복귀했습니다.
- 6~8명 처리 검증은 모의 플레이어 테스트이며, 실제 6클라이언트 동시 접속 테스트는 수행하지 않았습니다.
- 저장된 장소 파일의 두 Script 소스가 저장소 Luau 원본과 정확히 일치함을 확인했습니다.

## 2026-10-14 — 30종 수용을 위한 구역 확장

- 개인 구역을 70×70 studs(바닥 66×66)로 확대했습니다. 이전 대비 구역 면적 약 3배입니다.
- 구역 중심 반경을 70 → 108, 섬 지름을 232 → 348로 조정하고 길과 외곽 장식을 이동했습니다.
- 각 구역의 생산 패드를 6 → 30칸(5×6)으로 늘렸습니다. 전체 180칸입니다.
- 합성 보드는 뒤쪽, 입구와 리스폰은 앞쪽, 꽃 화단은 양옆에 배치했습니다.
- 무료 Sakura Tree(plentune)를 가져와 내장 Script가 없음을 확인하고 외곽에 12그루 배치했습니다.
- 주신 30단계 목록을 DessertCatalog에 그대로 저장했습니다. 마지막 명칭은 요청한 `페르페 용`으로 보존했습니다.
- 확장 검사 PASS: 6개 구역 × 30칸, 모든 패드가 섬 바닥 안에 위치. 갱신된 반경에서 기존 할당/반환/리스폰 모의 테스트도 PASS.
- 무료 Heart Cake(Taiyon)를 가져와 장식 8개를 추가했습니다. 내장 Script가 없음을 확인했습니다.
- 카탈로그 30개/환산량, 구역 간 분리 검사 PASS. 실제 Play 모드에서 넓어진 Plot1에 스폰하고 소유자 표지판이 유지되는 것을 확인했습니다.
- 저장된 장소의 생성기/할당기/카탈로그 세 소스가 원본 파일과 일치했습니다. 생성기는 계속 비활성화되어 편집한 맵을 보존합니다.

## 2026-10-14 — 참고 이미지 형태의 생산 구역

- 원형 패드 배열을 중앙 통로 + 양쪽 5줄의 긴 직사각형 생산 트레이로 교체했습니다. 각 트레이 3칸, 각 구역 30칸, 전체 180칸입니다.
- 70×70 크기, CentralShop 기준 6구역 배치, 자동 할당 시스템과 무료 장식을 유지했습니다.
- 합성 보드를 입구 중앙으로 옮기고 좌우에 1/5/25/100개 구매 버튼 자리를 배치했습니다. 실제 구매/합성 기능은 아직 연결하지 않았습니다.
- 꽃 화단을 바깥쪽 가장자리로 옮겨 생산 트레이와 중앙 통로를 확보했습니다.
- 배치 도구의 좌표 검사에서 부동소수점 오차가 발생해 허용 오차를 보정했습니다. 재실행 중 부분 적용을 정리하도록 도구도 수정했습니다.
- Studio 배치 검증 PASS: 구역당 트레이 10개, 디저트 자리 30개, 구매 버튼 4개, 통로 내부에 디저트 자리가 없음. 시각적으로 6개 구역의 대칭 배치를 확인했습니다.
- 실제 Play에서 Plot1 입구 스폰과 소유자 표지판 갱신을 확인했습니다. 저장된 XML에서도 6구역 각각 트레이 10개/패드 30개/구매 버튼 4개를 확인했습니다. 종료 후 편집 모드로 복귀했습니다.

## 2026-10-14 — 개인 디저트 가게 배치

- 두 번째 참고 이미지에 맞춰 각 구역 안쪽 끝에 개인 디저트 가게를 추가했습니다. 기존 중앙 가게 모델을 70% 크기로 복제하고 입구 방향으로 돌렸으며, 구역별 지붕 색과 번호 간판을 적용했습니다.
- 개인 가게 이름은 DessertShop으로 지정해 CentralShop 기준 자동 할당기의 고유 이름 검색과 충돌하지 않게 했습니다. 중앙 가게와 6개 구역의 원형 배치는 유지했습니다.
- 양쪽 생산 트레이 간격을 8 → 7 studs로 조정해 후면 가게 마당을 확보했습니다. 10개 트레이와 디저트 자리 30개는 유지했습니다.
- 가게 옆에 수익 받기·디저트 상자 연결용 발판을 배치했습니다. 실제 화폐/상자 기능은 구현하지 않았습니다.
- Studio 검사 PASS: 개인 가게 6개, 모든 가게 모서리가 70×70 구역 안에 있음, 생산 트레이와 가게가 겹치지 않음, 구역당 디저트 자리 30개 유지.
- 저장된 장소 XML에서도 구역별 가게 1개/디저트 자리 30개와 고유한 CentralShop 1개를 확인했습니다. 실제 Play에서 할당기 Ready 및 Plot1 배정 로그, 입구 스폰과 소유자 표시를 확인했습니다.

## 2026-10-14 — 원래 중앙 카페를 개인 구역 입구로 이전

- 중앙 카페와 대형 푸딩을 합친 전체 모델을 구역 입구 6곳에 배치했습니다. 축소한 후면 가게를 교체했으며 카페 정면은 중앙 반대쪽인 생산 구역 방향입니다.
- 중앙 광장의 카페와 벤치/화분/케이크 배치를 해제하고, 향후 사용자 모델을 넣을 빈 CentralDisplay를 마련했습니다. CentralShop은 투명한 중심 기준점 하나로 유지해 자동 할당기와 호환됩니다.
- 구매 4개, 합성, 수익 수집, 디저트 상자 발판을 카페 근처 전면 공간에 모았습니다. 사이드 스폰과 장식 케이크도 발판과 겹치지 않게 조정했습니다. 생산 트레이 10개/디저트 30칸은 구역 안쪽으로 이동했습니다.
- 카페 경계 검사 실패 뒤 Studio의 오류 상태에서 새 인스턴스와 기존 이동 상태가 달라지는 것을 확인했습니다. 원래 생성기의 카페 부분만 복구해 수정 배치를 완료했습니다. 섬 전체는 재생성하지 않았습니다.
- 검증 PASS: 빈 중앙 공간, 고유한 중심 모델, 입구에서 안쪽을 바라보는 푸딩 카페 6개, 디저트 자리 180개, 서비스 발판의 구역 내 배치 및 상호 분리.
- 저장된 XML에서도 전체 카페/푸딩 6개와 디저트 자리 180개를 확인했습니다. 실제 Play에서 투명 중심 기준점으로 할당기가 시작되고 Plot1 옆쪽 입구에 정상 스폰하는 것을 확인했습니다. 기존 할당기 소스는 변경하지 않았습니다.

## 2026-10-14 — English game text and dessert conveyor production

- Converted all game-facing labels and the thirty-tier catalog to English. Cafe ownership uses the Roblox username rather than the localized display name. Updated older editing utilities to emit English labels as well.
- Kept the 70x70 plots and built ten lower feed channels plus one main conveyor per plot. Raised the production shelves, added footbridges, and moved decorative mascots out of the active lanes. Island expansion was unnecessary for this layout.
- Added DessertProduction: one starter pudding and $25, $5 pudding purchases, five-second production, rolling miniature pudding products, arrival-only pending income, collection prompts, and three-to-one tier merges.
- Server checks cover owner identity, living character/distance, rate limits, cash and thirty-slot capacity. Returning a plot clears pets and in-flight products. Data is session-only; crates and persistence are not implemented. Higher tiers currently reuse tinted pudding models.
- Layout/English and existing allocator tests passed. Actual Play displayed the starter pudding and accumulating income (one sample: 34 pending, 25 cash). A numeric concatenation syntax error was caught before map mutation and fixed. The economy test's CFrame expression was corrected before it passed purchase, merge, transport, collection, ownership and cleanup cases.
- Final miniature pudding Model transport also passed the full production integration test. Prompts were tested through mock Triggered callbacks; the actual client Play check covered startup, pet display and income arrival, not a six-client load test. Saved production/allocator/catalog sources were checked against repository files.
