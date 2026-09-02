---
title: "[Graphics/PIX] PIX — Direct3D 12 디버깅 및 프로파일링 도구 소개"
description: >-
  "Microsoft PIX의 GPU 캡처와 타이밍 캡처를 중심으로, D3D12 기반 렌더링 디버깅 및 CPU/GPU 프로파일링 워크플로우를 소개한다."
author: seongcheol
date: 2026-04-15 01:10:00 +0900
categories: [Graphics, Debug, PIX]
tags: [PIX, Direct3D 12, GPU Debugging, Profiling, Frame Analysis]
pin: false
image:
  path: "/assets/img/common/title/ms_pix_title.png"
---

## PIX란

PIX는 Microsoft에서 제공하는 Direct3D 12 전용 디버깅 및 프로파일링 도구다. GPU 캡처로 렌더링 문제를 추적하고, 타이밍 캡처로 CPU/GPU 성능을 프로파일링할 수 있다. UE5, Unity, Godot 같은 엔진으로 만든 게임은 물론, DirectML 기반 AI/ML 워크로드까지 지원한다.

> CPU 프로파일링 기능은 모든 Windows 애플리케이션에서 동작하고, GPU 기능은 D3D12(또는 D3D11on12)를 사용하는 앱에서 동작한다.
{: .prompt-info }

## 설치

두 가지 방법이 있다.

**winget으로 설치 (권장):**

```bash
winget install microsoft.pix
```

**수동 설치:**

[PIX 다운로드 페이지](https://devblogs.microsoft.com/pix/download/)에서 직접 받을 수 있다.

새 릴리스 알림이 필요하면 [PIX 블로그 RSS 피드](https://devblogs.microsoft.com/pix/feed/)를 구독하면 된다.

## 핵심 기능: 두 가지 캡처 모드

PIX의 분석 워크플로우는 크게 **GPU 캡처**와 **타이밍 캡처** 두 가지로 나뉜다. 목적이 다르다.

| 캡처 모드 | 목적 | 분석 대상 |
|-----------|------|-----------|
| **GPU 캡처** | 렌더링 문제 디버깅 + 프레임 성능 분석 | 단일 프레임의 D3D12 API 호출 전체 |
| **타이밍 캡처** | CPU/GPU 프로파일링 | 여러 프레임에 걸친 시간별 성능 데이터 |

## GPU 캡처 (Frame Capture)

GPU 캡처는 애플리케이션이 수행하는 모든 D3D12 API 호출을 단일 프레임 단위로 기록한다. PIX가 이 API 호출을 재생하면서 파이프라인 상태, 리소스 내용, 셰이더 바인딩 등을 확인할 수 있다.

### 캡처 방법

1. PIX의 **연결(Connect)** 뷰에서 대상 프로세스를 시작하거나 연결
2. **GPU 캡처** 옵션이 선택되어 있는지 확인
3. **GPU 캡처 가져오기** 버튼 클릭 또는 `Alt + PrintScreen` (또는 `F11`)

프로그래밍 방식으로 캡처하려면 `WinPixEventRuntime`의 API를 사용하면 된다.

### 이벤트 뷰

캡처를 열면 **이벤트 뷰(Event View)**에 기록된 모든 API 호출이 표시된다. Graphics, Compute, Copy 큐별로 별도 목록이 제공되며, 정규식 필터링도 가능하다.

기본적으로 GPU에 실제 렌더링 작업을 발생시킨 이벤트만 표시된다. 상태 설정 등 non-GPU 이벤트까지 보려면 **G** 버튼을 토글하면 된다.

### 파이프라인 뷰

이벤트를 선택하면 **파이프라인 뷰**에서 해당 시점의 D3D 상태를 확인할 수 있다.

- Root Signature
- Pipeline State Object
- 바인딩된 리소스 (SRV/UAV/RTV)
- 셰이더 코드
- VS Output
- 현재 바인딩된 Render Target

### 셰이더 디버깅

파이프라인 뷰에서 셰이더를 선택하고 디버그 세션을 시작할 수 있다. 진입 방법은 세 가지다.

1. 셰이더 단계에서 **Shader** 항목 선택 → 재생 버튼 클릭
2. 리소스 뷰어(VS Output, SRV/UAV/RTV)에서 우클릭 → **Debug** 선택
3. **픽셀 세부 정보** 뷰에서 **픽셀 디버그** 버튼 클릭

> 셰이더 원본이 안 보이면 셰이더 PDB가 누락된 것이다. PDB를 생성하고 PIX가 로드하도록 설정해야 한다.
{: .prompt-warning }

### 셰이더 편집 및 계속 (Edit & Continue)

PIX 내에서 HLSL 셰이더 코드를 직접 편집하고, 변경 결과를 렌더타겟에 즉시 반영할 수 있다. 셰이더 프로토타이핑이나 최적화 실험에 유용하다.

편집 후 **적용**을 누르면 OM RTV 등 관련 뷰가 업데이트된다. 파이프라인 뷰를 두 개 열어 나란히 비교하는 것도 가능하다.

### 프레임 프로파일링

GPU 캡처에서 타이밍 데이터를 수집하면 프레임 단위 프로파일링이 가능하다.

1. 이벤트 뷰 우상단의 **타이밍 데이터 수집** 버튼 클릭
2. GPU 작업의 실행 기간(Duration)과 EOP 기간이 표시됨

타이밍 측정 방식은 두 가지다.

- **실행 기간 (Execution Duration)**: 각 작업의 Start-of-Pipe → End-of-Pipe 측정. 다른 작업과 병렬 실행 시 경합으로 인해 격리 상태보다 길게 나올 수 있다.
- **EOP 기간**: 이전 작업의 EOP → 현재 작업의 EOP 측정. 병렬 실행 시 짧게 나오며, 완전히 병렬 처리된 경우 0으로 보고될 수 있다.

### 픽셀 히스토리

특정 픽셀에 영향을 준 모든 드로우콜을 추적할 수 있다. RTV, UAV, 깊이 버퍼 등 픽셀 기반 리소스에서 우클릭 → **픽셀 기록 표시**를 선택하면 된다.

## 타이밍 캡처 (Timing Capture)

타이밍 캡처는 CPU/GPU 프로파일링 데이터를 하나의 캡처에 결합한다. 게임이 실행되는 동안 최소한의 오버헤드로 수집되기 때문에, 실제 런타임 성능에 가까운 데이터를 얻을 수 있다.

### 캡처 모드

| 모드 | 특성 |
|------|------|
| **순차 (Sequential)** | 시작~중지 사이의 모든 데이터를 저장. 긴 시간 캡처에 적합. 디스크 공간만큼 캡처 가능. |
| **순환 (Circular)** | 고정 크기 버퍼에 기록. 가득 차면 오래된 데이터 덮어씀. 테스트 랩에서 장시간 실행에 적합. |

### 수집 가능한 데이터

타이밍 캡처 시 선택할 수 있는 옵션들이다. 수집 옵션이 많을수록 런타임 오버헤드가 증가한다.

- **CPU 샘플**: 핫 경로, 느린 함수 식별. 샘플 속도 설정 가능.
- **컨텍스트 스위치 콜스택**: 스레드 컨텍스트 전환 시 콜스택 수집
- **GPU 타이밍**: GPU 작업의 시작/종료 시간
- **GPU 리소스**: 힙, 리소스 등 D3D 객체 상세 정보. 상주 상태, 강등, 마이그레이션 추적.
- **파일 액세스**: Win32 File IO 및 DirectStorage 추적
- **메모리 할당**: VirtualAlloc, HeapAlloc, 커스텀 할당자 이벤트 추적
- **메모리 액세스 샘플링**: 할당, 읽기, 쓰기 패턴 분석
- **비디오 캡처**: 타이밍 데이터와 함께 영상 프레임 기록

### UI 레이아웃

타이밍 캡처를 열면 다섯 가지 분석 레이아웃을 사용할 수 있다.

- **캡처 요약 (Summary)**: 캡처 통계 및 추가 분석 후보를 식별하는 초기 분석
- **타임라인 (Timeline)**: 캡처 기간 동안의 CPU/GPU 활동을 레인별로 시각화
- **예산 (Budgets)**: 성능 예산 프로필 생성/관리. 하드웨어별 성능 목표 설정.
- **메트릭 (Metrics)**: 이벤트 기간 및 카운터를 그래프로 표시. 변칙 탐지에 유용.
- **메모리 (Memory)**: 메모리 할당/해제 분석. 미해제 할당, 미접근 메모리 식별.
- **비교 (Comparison)**: 두 시간 범위의 통계적 비교. 성능 회귀 분석에 유용.

### GPU 메모리 및 상주 분석

**GPU 리소스** 옵션을 활성화하면 D3D 객체의 할당/해제 타이밍, VRAM 사용량, 상주 작업을 추적할 수 있다.

특히 중요한 것은 **상주(Residency)** 관련 데이터다.

- **MakeResident / Evict**: D3D12 API를 통한 명시적 상주 관리
- **PageIn / PageOut**: 시스템의 암묵적 페이징
- **강등된 할당 (Demoted Allocation)**: VRAM 압력이나 단편화로 GPU 메모리 할당 실패 시 발생
- **할당 마이그레이션**: 강등 후 DXGK가 시도하는 재배치. GPU 일시 중단이 필요해서 비용이 크다.

## UE5에서 PIX 사용하기

UE5에는 `PixWinPlugin` (PIX on Windows GPU Capture Plugin)이 내장되어 있다. 기본적으로 활성화되어 있으며, **편집 > 플러그인**에서 확인할 수 있다.

### 프로젝트 설정

셰이더 디버깅을 위해 `Config/DefaultEngine.ini`에 심볼 생성 설정을 추가한다.

```ini
[ShaderCompiler]
r.Shaders.Symbols=1
r.Shaders.ExtraData=1
r.Shaders.GenerateSymbols=1
r.Shaders.WriteSymbols=1
r.Shaders.SkipCompression=1
r.ShaderDevelopmentMode=1
```

셰이더 디버깅이 목적이면 최적화를 끈다.

```ini
r.Shaders.Optimize=0
```

프로파일링이 목적이면 최적화를 유지한다.

```ini
r.Shaders.Optimize=1
```

> 이 설정을 추가하면 에디터가 모든 셰이더를 다시 컴파일한다.
{: .prompt-warning }

### 패키지 빌드에서의 설정

PIX는 PDB 파일의 심볼을 사용한다. 기본적으로 게임 실행 파일과 같은 디렉토리에서 PDB를 찾는다.

- **프로젝트 설정 > 패키징**: `Use Io Store`를 `false`로 설정
- Shipping 빌드에서 PIX를 사용하려면: `Include Debug Files in Shipping Builds`를 `true`로 설정

### 캡처 방법

**방법 1 — PIX에서 직접 실행:**

PIX의 **Select Target Process** 창에서 패키지된 실행 파일 경로를 지정하고, **Launch for GPU Capture**를 활성화한 뒤 Launch한다.

**방법 2 — 게임 내 콘솔 명령:**

커맨드 라인에 `-attachPIX -d3ddebug` 옵션을 붙여 실행한 뒤, 게임 내 콘솔(`~`)에서 다음 명령을 실행한다.

**방법 3 - 비주얼스튜디오에서 설정:**

```-AttachPix를 Command Arguments에 추가하면 된다.
```

```
pix.GpuCaptureFrame
```

캡처 파일은 `[PackageDir]/Windows/[ProjectName]/Saved/PixCaptures`에 저장된다.

### Windows 환경 설정

- **Windows 개발자 모드**가 활성화되어 있어야 한다. (시스템 설정 > 개발자용)
- NVIDIA GPU의 경우, **NVIDIA Control Panel**에서 Developer Settings를 활성화하고 GPU 카운터 접근을 허용해야 한다.

## 주의 사항

- PIX는 D3D12 API 수준 문제(PSO 컴파일 에러 등)를 진단하는 도구가 아니다. API 유효성 검증에는 [D3D12 Debug Layer와 GPU Based Validation](https://learn.microsoft.com/ko-kr/windows/win32/direct3d12/using-d3d12-debug-layer-gpu-based-validation)을 사용해야 한다.
- GPU 캡처는 하드웨어/드라이버 버전에 종속적이다. 같은 GPU + 드라이버에서만 재생 성공을 보장하며, 다른 환경에서는 경고가 표시된다.
- 비동기 컴퓨팅 워크로드의 경우, GPU 캡처에서는 큐 간 겹침이 재현되지 않는다. 정확한 병렬 실행 타이밍은 타이밍 캡처를 사용해야 한다.

## 참고 자료

- [PIX 공식 문서 — Microsoft Learn](https://learn.microsoft.com/ko-kr/windows/win32/direct3dtools/pix/articles/general/pix-overview)
- [PIX GPU 캡처 문서](https://learn.microsoft.com/ko-kr/windows/win32/direct3dtools/pix/articles/gpu-captures/pix-gpu-captures)
- [PIX 타이밍 캡처 문서](https://learn.microsoft.com/ko-kr/windows/win32/direct3dtools/pix/articles/timing-captures/pix-timing-captures)
- [UE5 PIX 연동 — Epic Games 공식 문서](https://dev.epicgames.com/documentation/unreal-engine/using-pix-on-windows-with-unreal-engine?lang=ko)
- [Using Pix with Unreal 5.5 — unrealcode.net](https://www.unrealcode.net/PixTitan/)
- [PIX 블로그](https://devblogs.microsoft.com/pix/)
- [PIX 다운로드](https://devblogs.microsoft.com/pix/download/)
- [DirectX Discord — #pix 채널](https://discord.com/invite/directx)
