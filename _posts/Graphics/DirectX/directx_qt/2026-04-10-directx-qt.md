---
title: "[Graphics/DirectX] Qt Framework + DirectX"
description: >-
  Qt UI 위에 DirectX 렌더 화면을 얹는 방법을 정리한다. `QOpenGLWidget`과 동일한 사용 패턴을 D3D에 제공하는 오픈소스 프로젝트 [QtDirect3D](https://github.com/giladreich/QtDirect3D)를 기반으로, 위젯 라이프사이클·메시지 펌프 처리·렌더 루프 통합 방식을 살펴본다.
author: seongcheol
date: 2026-04-10 00:00:00 +0900
categories: [Graphics, DirectX]
tags: [DirectX, Qt]
pin: false
image:
  path: "/assets/img/common/title/directx_title.png"
---

## 왜 Qt + DirectX인가

툴 개발(레벨 에디터, 머티리얼 뷰어, 애셋 브라우저 등)을 하다 보면 결국 다음 조합이 필요해진다.

- **Qt** : 프로덕션급 데스크톱 UI 프레임워크. 위젯, 도킹, 시그널/슬롯, 모델/뷰가 잘 정리돼 있다.
- **DirectX** : Windows 기반 렌더링/툴체인의 표준. UE 에디터, 3ds Max, Substance 류가 모두 D3D 기반이다.

Qt에는 `QOpenGLWidget`이 기본 제공되지만, **DirectX용 위젯은 없다**. 그래서 보통 두 가지 길 중 하나를 선택한다.

1. `QWidget`의 `winId()`로 `HWND`를 얻어 직접 D3D 디바이스를 붙인다.
2. 이미 검증된 래퍼 라이브러리를 쓴다 → [giladreich/QtDirect3D](https://github.com/giladreich/QtDirect3D)

이 글은 후자에 초점을 맞춘다. 라이브러리가 어떻게 동작하는지 이해하면 1번 방식으로 직접 구현할 때도 그대로 적용된다.

---

## QtDirect3D 개요

> [QDirect3DWidget implementation similar to the built-in QOpenGLWidget](https://github.com/giladreich/QtDirect3D)

핵심 아이디어는 단순하다. **`QOpenGLWidget`의 사용 패턴을 D3D에 그대로 옮긴다.** 사용자는 위젯을 상속받아 렌더 콜백만 채우면 된다.

### 지원 범위
- DirectX `9`, `10`, `11`, `12` (각 버전별 위젯 클래스가 별도로 제공된다)
- Qt `5.x` (CMake 빌드)
- `ImGui` 통합 예제 포함 (`examples/` 디렉토리)

### 디렉토리 구조
```
QtDirect3D/
├── source/      # QDirect3D9/10/11/12Widget 구현
├── examples/    # 버전별 + ImGui 예제
├── thirdparty/  # ImGui 등
└── cmake/
```

---

## 위젯이 내부적으로 하는 일

`QOpenGLWidget`이 GL 컨텍스트 생성/스왑체인 관리/리사이즈 처리를 숨겨주듯, `QDirect3DWidget`도 D3D 디바이스 생성과 메시지 펌프를 숨겨준다.

### 1. 네이티브 윈도우 핸들 확보
`QWidget`을 `setAttribute(Qt::WA_NativeWindow)`로 강제 네이티브화한 뒤 `winId()`로 `HWND`를 얻는다.
이 `HWND`가 `IDXGISwapChain`의 `OutputWindow`로 들어간다.

### 2. Qt 페인트 시스템 차단
Qt가 위젯 영역을 자기 백버퍼에 그리려고 하면 D3D 출력과 충돌한다. 그래서 다음 두 속성을 켠다.

```cpp
setAttribute(Qt::WA_PaintOnScreen);
setAttribute(Qt::WA_NoSystemBackground);
setAttribute(Qt::WA_OpaquePaintEvent);
QWidget::setUpdatesEnabled(false);
// paintEngine()은 nullptr을 반환하도록 오버라이드
```

`paintEngine()`이 `nullptr`을 돌려주면 Qt는 이 위젯에 대해 페인팅을 시도하지 않는다. **렌더 권한을 D3D에 완전히 넘기는 절차**다.

### 3. 렌더 루프
`QTimer` 또는 `QEvent::UpdateRequest`를 통해 주기적으로 `tick()` → `render()` → `Present()`를 돈다. Qt 이벤트 루프와 같은 스레드에서 돌기 때문에 시그널/슬롯과 자연스럽게 섞인다.

### 4. 리사이즈
`resizeEvent()`에서 백버퍼를 release → `ResizeBuffers()` → RTV 재생성. 여기는 어느 D3D 앱이든 동일하다.

---

## 사용 패턴

`QOpenGLWidget`을 써본 적 있다면 거의 똑같다.

```cpp
class MyD3DWidget : public QDirect3D11Widget
{
    Q_OBJECT
public:
    using QDirect3D11Widget::QDirect3D11Widget;

protected:
    // 디바이스/스왑체인 준비된 직후 1회 호출
    void onInit() override
    {
        // 셰이더 컴파일, VB/IB 생성, 상수버퍼 등
    }

    // 매 프레임 로직
    void onFrame() override
    {
        // 카메라 업데이트, 애니메이션 진행
    }

    // 매 프레임 그리기
    void onRender() override
    {
        auto* ctx = context();   // ID3D11DeviceContext*
        auto* rtv = renderTargetView();

        const float clear[4] = { 0.1f, 0.1f, 0.12f, 1.0f };
        ctx->ClearRenderTargetView(rtv, clear);
        ctx->OMSetRenderTargets(1, &rtv, depthStencilView());

        // 드로우 콜
    }

    void onResize() override { /* 추가 RT 재생성 등 */ }
    void onShutdown() override { /* 리소스 해제 */ }
};
```

> ⚠️ 메서드명은 버전(9/10/11/12)별로 약간씩 다르다. 정확한 시그니처는 [`source/`](https://github.com/giladreich/QtDirect3D/tree/master/source) 폴더의 헤더를 확인할 것.

### 메인 윈도우에 끼워넣기
일반 `QWidget`처럼 다루면 끝이다.

```cpp
auto* d3d = new MyD3DWidget(this);
ui->renderLayout->addWidget(d3d);   // QHBoxLayout, QSplitter 등 무엇이든 OK
```

도킹 위젯, 탭 위젯, 스플리터 어디에 넣어도 동작한다. 이 부분이 직접 구현 대비 가장 큰 이득이다.

---

## 시그널/슬롯 통합

라이브러리는 위젯 라이프사이클을 시그널로도 노출한다.

| 시그널 | 시점 |
|---|---|
| `deviceInitialized(bool)` | D3D 디바이스 생성 직후 |
| `eventHandled()` | 입력 이벤트 처리 후 |
| `widgetResized()` | 백버퍼 리사이즈 완료 |
| `rendered()` | `Present()` 직전/직후 |

UI 사이드의 컨트롤(예: 슬라이더로 노출 조정, 콤보박스로 렌더 모드 전환)을 D3D 상태와 묶을 때 일반 Qt 코드와 동일하게 `connect()`로 연결하면 된다.

---

## ImGui + DirectX vs Qt + DirectX

툴/뷰어를 만들 때 가장 흔히 비교되는 두 조합이다. 같은 "DirectX 위에 UI 얹기"지만 철학이 정반대다.

### 한 줄 요약
- **ImGui + DirectX** : *내가 D3D 앱을 만들고 그 위에 UI를 띄운다.*
- **Qt + DirectX** : *내가 데스크톱 앱을 만들고 그 안의 한 영역에 D3D를 띄운다.*

소유권의 방향이 다르다. 이게 둘의 모든 장단점을 결정한다.

### 비교표

| 항목 | ImGui + DirectX | Qt + DirectX |
|---|---|---|
| UI 패러다임 | Immediate Mode | Retained Mode (시그널/슬롯) |
| 메인 루프 소유 | **앱(D3D)이 소유** | **Qt 이벤트 루프가 소유** |
| 통합 난이도 | 매우 쉬움 (소스 몇 파일 추가) | 중간 (HWND/페인트 차단/리사이즈 처리) |
| 빌드 부담 | 헤더+소스만 추가 (수십 KB) | Qt SDK 설치, MOC, 수백 MB |
| 라이선스 | MIT | LGPL/Commercial (동적 링크 시 LGPL OK) |
| 위젯 풍부도 | 기본 컨트롤 위주, 도킹은 별도 브랜치 | 도킹/모델뷰/스타일/i18n 등 풀세트 |
| 접근성·OS 통합 | 거의 없음 | 풀 네이티브 (스크린리더, IME, DnD) |
| 디자이너 도구 | 없음 (코드로 작성) | Qt Designer (`.ui` XML) |
| 멀티 윈도우 | viewports 브랜치로 가능 | 기본 지원 |
| 멀티 D3D 뷰포트 | 자연스러움 (앱이 곧 D3D) | `QDirect3DWidget` 여러 개 배치 |
| 스킨/테마 | ImGui 스타일 함수 | QSS (CSS-like) |
| 적합한 도메인 | **인게임 디버그 UI, 프로파일러, 1인 툴** | **프로덕션 에디터, 외부 배포 툴** |

### ImGui + DirectX 장단점

장점
- **압도적으로 가볍다.** D3D 디바이스 위에 `ImGui_ImplDX11_Init()` 한 줄. 빌드 시간 영향 거의 없음.
- **렌더 루프와 한 몸.** 매 프레임 `ImGui::Begin/End`로 UI를 새로 기술하므로 게임 상태와 UI 상태가 분리되지 않음 → 디버그 UI에 최적.
- **MIT 라이선스.** 상용 게임/엔진 내장 부담 없음. UE, Unity 플러그인, 거의 모든 자체 엔진이 채택.
- **D3D와 직접 붙는다.** 텍스처 핸들을 그대로 `ImGui::Image`에 넘길 수 있다 — 중간 변환 없음.

단점
- **데스크톱 앱처럼 보이지 않는다.** OS 네이티브 위젯이 아니라 직접 그린 픽셀이라 폰트 렌더링·접근성·IME(한글 입력)에 약하다.
- **복잡한 폼/리스트/트리.** 수백 행 가상화 리스트, 리치 텍스트 편집기, 데이터 모델 바인딩은 직접 다 짜야 함.
- **상태 보존이 어렵다.** Immediate mode 특성상 "이 다이얼로그는 마지막 입력값을 기억해야 한다" 같은 게 모두 수동.
- **외부 사용자에게 배포하기엔 부족.** "프로그래머 UI" 느낌이 강함.

### Qt + DirectX 장단점

장점
- **프로덕션 데스크톱 앱 품질.** 도킹, 메뉴, 단축키, 파일 다이얼로그, 스크린리더, 다국어, DPI 스케일링 — 다 공짜.
- **Qt Designer.** 디자이너에게 `.ui` 작업을 분리해서 맡길 수 있다.
- **데이터 바인딩.** `QAbstractItemModel` 기반 모델/뷰로 대용량 데이터(수십만 행)를 자연스럽게 다룬다.
- **외부 배포에 강하다.** 비-개발자가 봐도 "정상적인 윈도우 앱"으로 보인다. 3ds Max, Maya, Substance 류가 채택한 이유.

단점
- **무겁다.** Qt SDK 설치, MOC 빌드 단계, 배포 시 수십 MB DLL 동반.
- **D3D와 직접 붙지 않는다.** 위에서 본 것처럼 Qt의 페인트 시스템을 꺼야 하고, 리사이즈/DPI/멀티모니터 처리가 항상 신경 쓰임.
- **라이선스 주의.** LGPL이라 동적 링크면 OK지만, 정적 링크나 모바일/임베디드 배포는 상용 라이선스 검토 필요.
- **이벤트 루프 충돌.** Qt 이벤트 루프와 D3D Present 타이밍을 맞춰야 하므로 게임처럼 빡빡한 프레임 페이싱에는 부적합.

### 그래서 언제 무엇을?

- **인게임 디버그 오버레이, 셰이더 라이브 에디터, 인엔진 콘솔, 개인 툴** → ImGui
- **회사 내부 레벨 에디터, 외부 판매용 머티리얼 브라우저, 비-개발자도 쓰는 툴** → Qt
- **둘 다 필요하면 둘 다 써도 된다.** Qt 위젯 안에 D3D를 그리고, 그 D3D 컨텍스트에 ImGui를 같이 띄우는 하이브리드도 흔하다 (QtDirect3D `examples/`에 ImGui 통합 샘플이 있다).

> 결론: **UI 컨트롤이 풍부해야 하나(Qt) vs 렌더 루프가 깔끔해야 하나(ImGui)** 의 선택이지, 어느 쪽이 우월한 게 아니다.

---

## 직접 구현할 때의 체크리스트

라이브러리를 안 쓰고 `QWidget` 위에 직접 D3D를 얹는 경우 빠뜨리기 쉬운 항목들.

- [x] `Qt::WA_NativeWindow` + `Qt::WA_PaintOnScreen` 설정
- [x] `paintEngine()` 오버라이드해서 `nullptr` 반환
- [x] `winId()` → `reinterpret_cast<HWND>` 후 `DXGI_SWAP_CHAIN_DESC::OutputWindow`에 전달
- [x] `resizeEvent()`에서 RTV/DSV 해제 후 `ResizeBuffers()` 호출
- [x] `closeEvent()` 또는 소멸자에서 디바이스/스왑체인 해제 순서 주의 (`Flush()` 후 `ClearState()`)
- [x] DPI 스케일링 → `devicePixelRatioF()` 곱해서 실제 백버퍼 크기 계산
- [x] 멀티 모니터 이동 시 `IDXGIFactory::MakeWindowAssociation` 영향 확인

---

## 정리

- `QOpenGLWidget`이 OpenGL에 해주는 일을 `QDirect3DWidget`이 D3D에 해준다 — **HWND 확보, Qt 페인팅 차단, 렌더 루프, 리사이즈 처리**.
- 라이브러리를 쓸지 직접 짤지는 취향이지만, **Qt 페인트 시스템 차단**과 **`ResizeBuffers` 타이밍** 두 가지만 정확히 처리하면 직접 구현도 어렵지 않다.
- 툴 UI는 Qt에 맡기고 뷰포트만 D3D로 그리는 구조가 가장 안정적이다. 입력은 Qt 이벤트로 받아 D3D 카메라에 전달.

## 참고
- [giladreich/QtDirect3D - GitHub](https://github.com/giladreich/QtDirect3D)
- [Qt 개발자 게시판 - Qt + DirectX 사례](https://qt-dev.com/board.php?board=qtappboard&command=body&no=27&)
- [Qt Docs - QWidget::winId()](https://doc.qt.io/qt-5/qwidget.html#winId)
- [Qt Docs - Qt::WidgetAttribute](https://doc.qt.io/qt-5/qt.html#WidgetAttribute-enum)
