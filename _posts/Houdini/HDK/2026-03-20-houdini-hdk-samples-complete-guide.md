---
title: "[Houdini/HDK] Houdini 21.0 HDK 샘플 분석"
description: >-
  Houdini 21.0 HDK 샘플 35개 카테고리, 200+ 파일을 전수 분석한다. 뷰포트 렌더 훅(DM), 커스텀 프리미티브 파이프라인(tetprim), Mantra 프로시저럴(RAY), 시뮬레이션 솔버(SIM) 등 우선순위와 핵심 패턴을 정리한다.
author: seongcheol
date: 2026-03-20 00:00:00 +0900
categories: [Houdini, HDK]
tags: [Houdini, HDK, Graphics Programming, OpenGL, Viewport Rendering, Simulation, Mantra]
pin: false
math: true
image:
  path: /assets/img/common/title/houdini_title.jpg
---

> 📁 경로: `C:\Program Files\Side Effects Software\Houdini 21.0.559\toolkit\samples`
>
> Houdini 21.0 HDK에는 **35개 카테고리, 200개 이상의 소스 파일**이 포함되어 있다.
> 이 글에서는 모든 샘플을 분석하고, 그래픽스 프로그래머 관점에서 무엇을 어떤 순서로 봐야 하는지 정리한다.

---

## 🏗️ 1. 아키텍처 핵심 패턴

HDK 플러그인은 모두 **DSO (Dynamic Shared Object)** 패턴을 따른다.
진입점 함수 이름이 카테고리마다 다르다:

| 카테고리 | 진입점 함수 | 등록 대상 |
|---------|-----------|----------|
| SOP | `newSopOperator(OP_OperatorTable*)` | 노드 |
| DM/GUI | `newRenderHook(DM_RenderTable*)` | 뷰포트 렌더 훅 |
| SIM | `initializeSIM(void*)` + `IMPLEMENT_DATAFACTORY` | 시뮬레이션 데이터/솔버 |
| RAY | `registerProcedural(RAY_ProceduralFactory*)` | Mantra 프로시저럴 |
| RAY (PixelFilter) | `allocPixelFilter(const char*)` | Mantra 픽셀 필터 |
| VEX | `newVEXOp(void*)` | VEX 커스텀 함수 |
| COP2 | `newCop2Operator(OP_OperatorTable*)` | 컴포짓 노드 |
| CHOP | `newChopOperator(OP_OperatorTable*)` | 채널 노드 |
| OBJ | `newSopOperator(OP_OperatorTable*)` | 오브젝트 노드 |
| ROP | `newDriverOperator(OP_OperatorTable*)` | 렌더 출력 노드 |
| Custom Prim | `newGeometryPrim(GA_PrimitiveFactory*)` | 커스텀 프리미티브 (tetprim, packedsphere) |
| DM (Mouse) | `DMnewEventHook(DM_EventTable*)` | 마우스 이벤트 훅 |
| LOP | CMakeLists + `newLopOperator` | USD/Solaris 노드 |
| BRAY (Karma) | `BRAY_HdProcedural` 팩토리 | Karma 프로시저럴 |

공통 필수 헤더: **`#include <UT/UT_DSOVersion.h>`** (버전 호환성 보장)

---


### 📂 전체 카테고리 한눈에 보기

```
samples/
├── 🎨 DM/          ← 뷰포트 렌더 훅 (GL 셰이더, FBO, 포스트프로세스)
├── 🖼️ GUI/         ← 프리미티브 렌더 훅 (커스텀 GR_Primitive)
├── 🔺 tetprim/     ← 커스텀 프리미티브 전체 파이프라인 (GEO→GT→GR)
├── 💡 RAY/         ← Mantra 프로시저럴 & 픽셀 필터
├── 🌊 SIM/         ← 시뮬레이션 솔버 & 데이터
├── 📐 SOP/         ← 지오메트리 오퍼레이터 (가장 방대)
├── 📦 packedsphere/ ← 간소화된 커스텀 프리미티브 (Packed)
├── 🎬 karma_procedurals/  ← Karma 렌더러 프로시저럴
├── 🖥️ COP2/        ← 이미지 컴포지팅 노드
├── 📦 LOP/         ← Solaris/USD 노드
├── 🎭 OBJ/         ← 오브젝트 레벨 노드
├── 🔧 standalone/  ← Houdini 없이 돌아가는 독립 프로그램
└── ... (CHOP, VEX, VOP, DOP, ROP, SHOP 등)
```

---

## 📂 2. 카테고리별 상세 분석

### 📐 2.1 SOP — Surface Operators (가장 방대, .C ~30개 .h ~20개 서브디렉토리 12개, 총 ~70 파일)

**핵심 교훈**: 모든 지오메트리 조작의 기초. 두 가지 패턴이 공존한다.

#### 레거시 패턴 (SOP_Node 직접 상속)

| 샘플 | 핵심 교훈 |
|------|----------|
| `SOP_Star` | 🔰 가장 기본적인 Generator SOP. `PRM_TemplateBuilder` + `.proto.h` 자동생성 |
| `SOP_DualStar` | Star 변형. 파라미터 → `cookMySop()` 기본 흐름 |
| `SOP_Flatten` | 입력 지오메트리 플래튼 |
| `SOP_PointWave` | 포인트 웨이브 디포머 |
| `SOP_CPPWave` | C++ 웨이브 디포머. VEX 버전(`SOP_VEXWave.vfl`)과 **성능/구현 비교용** |
| `SOP_BlindData` | **HIP 파일에 private 데이터 저장.** `save()`/`load()` 오버라이드로 커스텀 직렬화 |
| `SOP_ArrayAttrib` | **배열 어트리뷰트** 생성 및 조작 (`GA_Attribute` array type) |
| `SOP_DetailAttrib` | **디테일 어트리뷰트** 생성. 가장 간단한 어트리뷰트 조작 예제 |
| `SOP_GroupRename` | **그룹 이름 변경**. `GA_Group` 조작 패턴 |
| `SOP_NURBS` | **NURBS 서피스 생성**. rows, cols, order 파라미터 |
| `SOP_Surface` | 서피스 프리미티브 생성 |
| `SOP_SParticle` | **파티클 시스템**. `GEO_PrimParticle`, birth/death, 충돌(`GU_RayIntersect`), velocity/life |
| `SOP_TimeCompare` | **다른 시간의 어트리뷰트 비교**. `cookInputGroups()` 오버라이드, 시간축 데이터 |
| `SOP_HDKObject` | **Object Merge SOP 재구현**. `DYNAMIC_PATH`, `MULTIPARM`, 다른 SOP 쿠킹 |

**SOP_HDKObject의 MULTIPARM 패턴:**

```cpp
int NUMOBJ() { return evalInt("numobj", 0, 0.0f); }
void SOPPATH(UT_String &str, int i, fpreal t) {
    evalStringInst("objpath#", &i, str, 0, t);  // #은 인스턴스 인덱스
}
```

**SOP_HDKObject의 지오메트리 복사 전략:**

```cpp
// PRM_MULTITYPE_LIST + PRM_TYPE_DYNAMIC_PATH + PRM_SpareData::sopPath 조합

// GEO_COPY 전략: 여러 소스를 하나의 디테일에 합칠 때
GEO_CopyMethod copymethod;
if (!copiedfirst)      copymethod = GEO_COPY_START;  // 첫 소스: 초기화
else if (last)         copymethod = GEO_COPY_END;    // 마지막: 마무리
else                   copymethod = GEO_COPY_ADD;    // 중간: 추가
// 소스가 1개뿐이면: GEO_COPY_ONCE (가장 효율적)

// 새로 생성된 요소 추적
GA_IndexMap::Marker pointmarker(gdp->getPointMap());
GA_IndexMap::Marker primmarker(gdp->getPrimitiveMap());
gdp->copy(*cookedgdp, copymethod, true, false, GA_DATA_ID_CLONE);

// 추적된 범위에만 트랜스폼 적용
gdp->transform(xform, primmarker.getRange(), pointmarker.getRange(), false);
```

**SOP_SParticle의 파티클 시스템 패턴:**

```cpp
GEO_PrimParticle *mySystem;   // 파티클 프리미티브
GA_RWHandleV3    myVelocity;  // velocity 어트리뷰트
GA_RWHandleF     myLife;      // life 어트리뷰트
GU_RayIntersect  *myCollision; // 충돌 검출

void birthParticle();
int  moveParticle(GA_Offset, const UT_Vector3&);
void timeStep(fpreal now);

// 시간 의존 SOP 선언
OP_Node::flags().setTimeDep(true);

// 입력 잠금 패턴 (RAII)
OP_AutoLockInputs inputs(this);
if (inputs.lock(context) >= UT_ERROR_ABORT) return error();
```

#### 최신 패턴 (SOP_NodeVerb 기반, CMakeLists.txt 포함)

**SOP_NodeVerb 아키텍처 (`SOP_CopyToPointsHDK` 기준):**

```cpp
// .proto.h 자동생성 → SOP_CopyToPointsHDKParms 타입 안전 파라미터 접근
#include "SOP_CopyToPointsHDK.proto.h"

class SOP_CopyToPointsHDKCache : public SOP_NodeCache, public GU_CopyToPointsCache {};

class SOP_CopyToPointsHDKVerb : public SOP_NodeVerb {
    SOP_NodeParms *allocParms() const override { return new SOP_CopyToPointsHDKParms(); }
    SOP_NodeCache *allocCache() const override { return new SOP_CopyToPointsHDKCache(); }
    UT_StringHolder name() const override { return theSOPTypeName; }
    CookMode cookMode(const SOP_NodeParms*) const override { return COOK_GENERIC; }
    void cook(const CookParms &cookparms) const override;

    static const SOP_NodeVerb::Register<SOP_CopyToPointsHDKVerb> theVerb; // 자동 등록
};

// 파라미터 인터페이스: raw string literal DSFile
const char *const theDsFile = R"THEDSFILE(
{
    name parameters
    parm { name "sourcegroup" ... }
}
)THEDSFILE";
```

| 샘플 | 핵심 교훈 |
|------|----------|
| `SOP_CopyToPoints/` | `GU_Copy2` 유틸리티 클래스 분리, `SOP_NodeVerb::cook()` 패턴 |
| `SOP_Sweep/` | `GU_Grid` 템플릿 구현, 메시 생성 최적화 |
| `SOP_WindingNumber/` | BVH + SolidAngle 알고리즘 (수학적으로 가장 복잡) |
| `SOP_SplitPoints/` | `GEO_SplitPoints` 알고리즘 분리, vertex/point 토폴로지 변환 |
| `SOP_OrientAlongCurve/` | `GU_CurveFrame` 프레임 계산 유틸리티 |
| `SOP_CentroidDivide/` | Centroid 기반 폴리곤 분할 |
| `SOP_MaxPromote/` | 어트리뷰트 프로모션 (포인트→프리미티브 등) |
| `SOP_MinRay/` | 레이캐스팅 기반 최소 거리 계산 |
| `SOP_MergePrimitives/` | 프리미티브 병합 |
| `SOP_Expand/` | 프리미티브/포인트 확장 |
| `SOP_CopyPacked/` | Packed 프리미티브 복사 |

#### 특수 SOP들

- `SOP_VolumeProject/`: 볼륨 데이터 프로젝션
- `SOP_CopRaster`: COP → SOP 데이터 전달
- `SOP_PrimVOP`: VOP 네트워크 평가를 SOP에서 수행
- `SOP_BouncyAgent`: Agent 프리미티브 (군중 시뮬) 생성
- `SOP_IKSample`: IK 솔버 구현

#### Brush/Selector 인터랙션

- `SOP_BrushHairLen` + `MSS_BrushHairLen` + `MSS_BrushHairLenSelector`: 커스텀 브러시 + 셀렉터 상태
- `SOP_CustomBrush` + `MSS_CustomBrushState`: 커스텀 브러시 UI 상태 머신
- `.ui` 파일로 뷰포트 인터랙션 정의

---

### 🎨 2.2 DM — Display Manager / 뷰포트 렌더 훅 ⭐ (그래픽스 핵심)

**아키텍처**: `DM_SceneHook` (팩토리) → `DM_SceneRenderHook` (렌더러)

**Hook 타입과 타이밍**:

```
DM_HOOK_BACKGROUND → 배경 (체커보드 등)
DM_HOOK_BEAUTY     → 메인 렌더 패스 (Before/After Native)
DM_HOOK_FOREGROUND → 전경 오버레이 (텍스트, HUD)
DM_HOOK_POST_RENDER → 후처리
DM_HOOK_UNLIT      → 비조명 패스
```

**Policy**:
- `DM_HOOK_REPLACE_NATIVE`: Houdini 기본 렌더링 교체
- `DM_HOOK_BEFORE_NATIVE`: 기본 렌더링 전에 실행
- `DM_HOOK_AFTER_NATIVE`: 기본 렌더링 후에 실행

#### DM_BackgroundHook ⭐
- **체커보드 배경 교체**. GL 전체 파이프라인 데모
- `RE_Shader` 생성 (inline GLSL #version 150)
- `RE_Texture` 2x2 반복 텍스처
- `RE_Geometry` 풀스크린 쿼드
- `DM_HOOK_BACKGROUND` + `DM_HOOK_REPLACE_NATIVE`
- 씬 옵션 `installSceneOption()` + `isSceneOptionEnabled()` 토글

#### DM_LightBloomHook ⭐⭐
- **포스트프로세스 블룸 이펙트**. FBO + 다운샘플 + 가산 블렌딩
- `RE_OGLFramebuffer`로 1/4 해상도 FBO 생성
- `viewport().getBeautyPassTexture()` 로 뷰티패스 접근
- 2패스: Copy → Additive Blur (3x3 커널)
- `RE_SBLEND_SRC_ALPHA, RE_DBLEND_ONE` 가산 블렌딩
- `DM_HOOK_FOREGROUND` + `DM_HOOK_BEFORE_NATIVE`

#### DM_OverdrawHook ⭐⭐
- **Occlusion Query 기반 오버드로 측정**
- 3단계 멀티패스: PreBeauty → PostBeauty → RenderInfo
- `RE_OcclusionQuery`로 실제 렌더된 샘플 수 측정
- 같은 훅을 여러 패스에 등록 (`DM_HOOK_BEAUTY` Before/After + `DM_HOOK_FOREGROUND`)
- 레퍼런스 카운팅으로 뷰포트당 단일 인스턴스 관리

#### DM_ObjectPathHook
- 오브젝트 애니메이션 경로 시각화
- `OBJ_Node::getLocalToWorldTransform()` 프레임별 추출
- 속도 기반 컬러링, `RE_CacheVersion` 캐싱 패턴

#### DM_SceneBoundsHook
- 씬 전체 바운딩박스 와이어프레임
- `DM_GeoDetail::getBoundingBox3D()` 순회

#### DM_InfoHook
- 현재 SOP 이름을 뷰포트에 텍스트로 표시
- `RE_Font` + `r->putString()` 사용법

#### DM_GreedyMouseHook
- **마우스 이벤트 훅** (별도 진입점 `DMnewEventHook`)
- `DM_MouseHook` → `DM_MouseEventHook` 팩토리 패턴
- `handleMouseEvent`, `handleMouseWheelEvent`, `handleDoubleClickEvent`

---

### 🖼️ 2.3 GUI — Viewport Primitive Hooks ⭐ (그래픽스 핵심)

**아키텍처**: `GUI_PrimitiveHook` → `GR_Primitive`

두 가지 모드:
1. **GEO Hook** (`registerGEOHook`): `GEO_Primitive` 기반
2. **GT Hook** (`registerGTHook`): `GT_Primitive` 기반 (리파인먼트 후)

추가로 **Filter 모드** (`GUI_HOOK_FLAG_PRIM_FILTER`)와 **Augment 모드** (`GUI_HOOK_FLAG_AUGMENT_PRIM`) 구분.

#### GUI_PolygonNormalShade ⭐
- **GT Filter Hook** 예제. Polygon Mesh에서 N → Cd 변환
- `GT_PrimPolygonMesh`의 어트리뷰트 리스트 조작
- `filterPrimitive()` 오버라이드로 리파인먼트 체인에 개입
- 포인트/버텍스 노멀 분기 처리

#### GUI_PolySoupBox
- **GEO Augment Hook** 예제. PolySoup에 바운딩박스 + 무게중심 장식 추가
- `GR_Primitive` 완전 구현: `update()` → `renderDecoration()` → `render()`
- `GR_Utils::buildInstanceObjectMatrix()` 인스턴싱 지원
- 커스텀 디스플레이 옵션 2개 등록

#### GUI_PrimFramework ⭐⭐ (프레임워크/보일러플레이트)
- **완전한 GR_Primitive 구현 템플릿**
- 모든 `GR_RenderMode` 열거 (Beauty, Material, Wireframe, HiddenLine, Depth, XRay, Matte, Pick 등)
- 모든 `GR_RenderFlags` 열거 (Unlit, WireOver, FlatShaded, Faded, PointsOnly)
- 모든 `GR_UpdateParms::reason` 비트 열거
- 컴포넌트 피킹 구조체 레이아웃 (Single/Multi 모드)
- **새로운 프리미티브 렌더링을 만들 때 이 파일에서 시작하면 된다**

---

### 💡 2.4 RAY — Mantra Rendering (8 파일)

**아키텍처**: `RAY_Procedural` + `RAY_ProceduralFactory`
- `initialize()` → `getBoundingBox()` → `render()` 순서
- `createGeometry()` + `createChild()` + `addGeometry()` 패턴

#### RAY_DemoBox
- 가장 기본적인 프로시저럴. 파라미터 `import()` → GU_Detail::cube()
- `obj->changeSetting("surface", ...)` 로 머티리얼 변경

#### RAY_DemoMountain ⭐
- **재귀적 프로시저럴 분할 (LOD)**
- `getLevelOfDetail()` 기반 적응적 서브디비전
- `fractalSplit()` → 4개 자식 프로시저럴 생성
- `fractalRender()` → 삼각형 지오메트리 직접 생성
- Fractal terrain 생성 알고리즘

#### RAY_DemoVolumeSphere ⭐
- **커스텀 볼륨 프리미티브** (`VGEO_Volume` 상속)
- `getNativeStepSize()`, `getBoxes()`, `evaluate()`, `gradient()` 오버라이드
- 밀도/거리 어트리뷰트 바인딩 (`getAttributeBinding`)
- `addVolume()` 으로 볼륨 렌더링 추가

#### RAY_DemoEdgeDetectFilter ⭐
- **Mantra 픽셀 필터** (포스트프로세스)
- Color gradient, Z gradient, OpID 3가지 에지 검출
- `prepFilter()` 에서 계수 프리컴퓨트
- `filter()` 에서 소스 버퍼 → 목적지 버퍼 변환
- `RAY_SpecialChannel` (PZ, OPID) 접근

#### RAY_DemoSprite
- **포인트 → 빌보드 스프라이트 변환**. 가장 복잡한 RAY 샘플
- 재귀적 공간 분할 (옥트리 유사)
- 어트리뷰트 매핑 (`ray_SpriteAttribMap`)
- 모션 블러 (velocity attribute)

#### RAY_DemoFile, RAY_DemoGT, RAY_DemoStamp
- File: 외부 파일 로드 + **벨로시티/멀티세그먼트 모션 블러**
- GT: Mantra에서 **GT 프리미티브를 직접 렌더링**. GU_Detail 기반이 아닌 GT 레벨 프로시저럴
- Stamp: 스탬핑/인스턴싱

**RAY_DemoFile의 모션 블러 패턴:**

```cpp
void RAY_DemoFile::render() {
    RAY_ProceduralGeo g0 = createGeometry();
    g0->load(myFile, 0);

    if (myVelocityBlur) {
        // 벨로시티 블러: v 어트리뷰트 기반
        g0.addVelocityBlur(myPreBlur, myPostBlur);
    } else if (myBlurFile.isstring()) {
        // 멀티세그먼트: 별도 파일에서 두 번째 지오메트리 로드
        auto g1 = g0.appendSegmentGeometry(myShutter);
        wlock.getGdp()->load(myBlurFile, 0);
    }
    // camera:shutter import → preBlur/postBlur 계산
    // import("camera:shutter", shutter, 2);
    // myPreBlur = -(myShutter * shutter[0]) / fps;
}
```

**RAY_DemoGT의 GT 레벨 렌더링:**

```cpp
void RAY_DemoGT::render() {
    // GT_PrimCurveMesh를 프로시저럴하게 생성
    GT_PrimitiveHandle prim = makeCurveMesh(myBox, myCurveCount, myMaxRadius, mySegments);

    // GT_Real16Array: FP16 컬러/width 데이터
    // GT_AttributeMap + GT_AttributeList: 모션 세그먼트별 어트리뷰트
    // GT_PrimCurveMesh(GT_BASIS_LINEAR, counts, vertex, uniform, detail, false)

    RAY_ProceduralChildPtr obj = createChild();
    obj->addProcedural(new RAY_ProcGT(prim));  // GT → Mantra 렌더링 브릿지
}
```

---

### 🌊 2.5 SIM — Simulation (7 파일)

**아키텍처**: `SIM_Data` + `SIM_Solver` + `SIM_DopDescription`
- `DECLARE_DATAFACTORY` / `IMPLEMENT_DATAFACTORY` 매크로 패턴
- `SIM_OptionsUser` 로 파라미터 접근

#### SIM_GasAdd ⭐
- **GAS SubSolver** 패턴의 교과서적 구현
- `SIM_ScalarField` / `SIM_VectorField` / `SIM_MatrixField` 처리
- `UT_VoxelArrayIteratorF` 타일 기반 순회
- `SIM_ScalarFieldSampler` 로 필드 간 샘플링
- 타일 상수 최적화 (`isTileConstant`)
- `THREADED_METHOD2` 멀티스레드 패턴

#### SIM_ForceOrbit
- **커스텀 포스** (중력 유사)
- `SIM_Force::getForceSubclass()` 오버라이드
- 가이드 지오메트리 (`buildGuideGeometrySubclass`)
- 구체/원 Force 변형 구현

#### SNOW_Solver ⭐⭐
- **완전한 커스텀 솔버 + 커스텀 데이터 + 시각화**
- `SNOW_VoxelArray`: `UT_VoxelArray<u8>` 기반 커스텀 SIM_Data
- `SNOW_Solver`: 눈 시뮬레이션 (birth, gravity, collision)
- `SNOW_Visualize`: `SIM_GuideShared` 기반 시각화
- 보셀 기반 시뮬: 6방향 탐색, 브라운 운동, `GU_RayIntersect` 충돌
- `saveIOSubclass` / `loadIOSubclass` 직렬화
- Affector 관계 (`SIM_RelationshipSource`, `getColliderInfo`)

#### SIM_RadialEmit
- **GAS SubSolver + 지오메트리 이미션** 패턴. 필드가 아닌 **점 지오메트리 생성**
- `GET_DATA_FUNC_*` 매크로로 파라미터 접근자 자동 생성

```cpp
class SIM_RadialEmit : public GAS_SubSolver {
    GET_DATA_FUNC_S(GAS_NAME_GEOMETRY, Geometry);
    GET_DATA_FUNC_V3("center", Center);
    GET_DATA_FUNC_V2("distance", Distance);
    GET_DATA_FUNC_I("birthrate", BirthRate);
};
```

#### SIM_SolverHair
- **`SIM_SingleSolver`** 상속 (vs `GAS_SubSolver`). 오브젝트 단위 솔빙
- RBD Object 지오메트리를 소스로 헤어 생성
- `solveSingleObjectSubclass()` 오버라이드
- `createHairFromSource()` / `solveHair()` 가상 함수로 확장 가능

#### SIM_ElectricalProperties
- **솔버가 아닌 순수 데이터만 정의**하는 패턴. `SIM_Data` 직접 상속
- `GETSET_DATA_FUNCS_F`: getter/setter 모두 자동 생성 (vs `GET_DATA_FUNC_F`는 getter만)

#### GAS_NetVDBSliceExchange
- **분산 VDB 시뮬레이션** 슬라이스 교환 (네트워크 통신)

---

### 🔺 2.6 tetprim — 커스텀 프리미티브 전체 파이프라인 ⭐⭐⭐

**가장 중요한 샘플 중 하나**. 사면체(Tetrahedron) 프리미티브를 처음부터 끝까지 구현.

| 파일 | 역할 |
|------|------|
| `GEO_PrimTetra` | GA 레벨 프리미티브 정의 (토폴로지, I/O, 변환) |
| `GT_PrimTetra` | GT 레벨 리파인먼트 (뷰포트 전달용 데이터) |
| `GR_PrimTetra` | GL 렌더링 (`RE_Geometry`, 셰이더 바인딩, 머티리얼) |
| `SOP_Tetra` | 사면체 생성 SOP 노드 |
| `tetra.C` | DSO 등록 (모든 클래스 한번에 등록, GT/GR 스위칭) |

**두 가지 렌더링 경로 (`tetra.C`):**

```cpp
// #define TETRA_GR_PRIMITIVE  ← 주석 해제하면 GR 방식

#ifndef TETRA_GR_PRIMITIVE
#include "GT_PrimTetra.C"    // GT: Collector → PolygonMesh (Houdini가 렌더)
#else
#include "GR_PrimTetra.C"    // GR: 직접 GL 렌더링 (완전 제어)
#endif
```

- **GT 방식**: `GT_PrimPolygonMesh`로 변환 → Houdini가 자동 렌더링. 간단하지만 제어 제한
- **GR 방식**: `RE_Geometry` + 셰이더 직접 제어. 복잡하지만 장식, 피킹 등 완전 제어

추가로 `#define TETRA_GR_PRIM_COLLECTION`을 주석 해제하면 **여러 GEO 프리미티브를 하나의 GR_Primitive로 수집**하는 패턴도 확인 가능.

#### GEO_PrimTetra — GA/GEO 레벨 프리미티브 정의

`GEO_Primitive` 상속. 커스텀 프리미티브의 기반 레이어.

**필수 오버라이드:**

```cpp
bool  isDegenerate() const override;
bool  getBBox(UT_BoundingBox*) const override;
void  reverse() override;
UT_Vector3 computeNormal() const override;
void  copyPrimitive(const GEO_Primitive*) override;
GA_DereferenceStatus dereferencePoint(GA_Offset, bool) override;
int   detachPoints(GA_PointGroup&) override;
const GA_PrimitiveJSON* getJSON() const override;
```

**선택적 오버라이드 (권장):**

```cpp
UT_Vector3 baryCenter() const override;
fpreal     calcVolume(const UT_Vector3&) const override;
fpreal     calcArea() const override;
fpreal     calcPerimeter() const override;
int        intersectRay(...) const override;
```

**타입 등록 패턴:**

```cpp
static GA_PrimitiveDefinition *theDefinition;
static void registerMyself(GA_PrimitiveFactory *factory);
static const GA_PrimitiveTypeId &theTypeId() { return theDefinition->getId(); }
```

`registerMyself()`에서 `GA_PrimitiveFactory`에 프리미티브를 등록하고, GT Collector와 GR Hook도 함께 등록한다.

**등록 + GT/GR 분기 (`registerMyself`):**

```cpp
void GEO_PrimTetra::registerMyself(GA_PrimitiveFactory *factory) {
    theDefinition = factory->registerDefinition(
        "HDK_Tetrahedron", geoNewPrimTetraBlock, GA_FAMILY_NONE, "hdk_tetrahedron");
    theDefinition->setHasLocalTransform(false);
    registerIntrinsics(*theDefinition);

#ifndef TETRA_GR_PRIMITIVE
    GT_PrimTetraCollect::registerPrimitive(theDefinition->getId()); // GT 경로
#else
    DM_RenderTable::getTable()->registerGEOHook(                    // GR 경로
        new GR_PrimTetraHook, theDefinition->getId(), 0, GUI_HOOK_FLAG_NONE);
#endif
}

// DSO 진입점
extern "C" { void newGeometryPrim(GA_PrimitiveFactory *factory) {
    GEO_PrimTetra::registerMyself(factory);
}}
```

**JSON 직렬화 (`GA_PrimitiveJSON`):**

```cpp
class geo_PrimTetraJSON : public GA_PrimitiveJSON {
    enum { geo_TBJ_VERTEX, geo_TBJ_ENTRIES };
    int getEntries() const override { return geo_TBJ_ENTRIES; }
    const UT_StringHolder &getKeyword(int i) const override;
    bool saveField(const GA_Primitive*, int, UT_JSONWriter&, const GA_SaveMap&) const override;
    bool loadField(GA_Primitive*, int, UT_JSONParser&, const GA_LoadMap&) const override;
};
```

**Intrinsic 어트리뷰트:**

```cpp
GA_START_INTRINSIC_DEF(GEO_PrimTetra, geo_NUM_INTRINSICS)
    GA_INTRINSIC_I(GEO_PrimTetra, geo_INTRINSIC_ADDRESS, "address", intrinsicAddress)
    GA_INTRINSIC_S(GEO_PrimTetra, geo_INTRINSIC_AUTHOR,  "author",  intrinsicAuthor)
GA_END_INTRINSIC_DEF(GEO_PrimTetra, GEO_Primitive)
```

**볼륨 계산 공식:**

```cpp
fpreal GEO_PrimTetra::calcVolume(const UT_Vector3 &) const {
    return -(v3-v0).dot(cross(v1-v0, v2-v0)) / 6;  // signed volume
}
```

**병렬 프리미티브 할당 콜백 (C++11 lambda):**

```cpp
static void geoNewPrimTetraBlock(GA_Primitive **new_prims, GA_Size n,
                                  GA_Detail &gdp, GA_Offset start, ...) {
    if (n >= 4*GA_PAGE_SIZE) {
        UTparallelForLightItems(range, [&](const UT_BlockedRange<GA_Offset> &r){
            for (auto off = r.begin(); off != r.end(); ++off)
                *pprims++ = new GEO_PrimTetra(gdp, off);
        });
    } else { /* serial */ }
}
```

**생성자 스레드 안전성 규칙:** 생성자에서 디테일에 vertex를 추가하면 안 된다. 여러 스레드에서 동시에 호출될 수 있기 때문. vertex 추가는 `build()` 또는 `buildBlock()`에서 수행.

**폴리곤 변환 (`convert`):**

```cpp
GEO_Primitive* GEO_PrimTetra::convertNew(GEO_ConvertParms &parms) {
    if (parms.toType() == GEO_PrimTypeCompat::GEOPRIMPOLY) {
        geo_buildPoly(this, gdp, 0, 1, 2, parms);  // 4개 삼각형 생성
        geo_buildPoly(this, gdp, 1, 3, 2, parms);
        geo_buildPoly(this, gdp, 1, 0, 3, parms);
        return geo_buildPoly(this, gdp, 0, 2, 3, parms);
    }
}
// GA_VertexWrangler로 vertex 어트리뷰트 복사
```

**병렬 빌드 (`buildBlock`):**

```cpp
static GA_Offset buildBlock(GA_Detail *detail, const GA_Offset startpt,
                             const GA_Size npoints, const GA_Size ntets,
                             const int *tetpointnumbers);
```

`UTparallelForLightItems` + `geo_SetVertexListsParallel` 펑터로 대량 프리미티브 병렬 생성.
4개 vertex를 `myVertexList`로 관리. `setTrivial(vtxoff, 4)`로 연속 offset일 때 최적화.

#### GT_PrimTetra — GT Collector 패턴

**`GT_GEOPrimCollect`** 패턴:

```
GT_PrimTetraCollect : GT_GEOPrimCollect
  ├─ beginCollecting()  → 수집 컨테이너 생성
  ├─ collect()          → 프리미티브 오프셋 누적 (호출마다 1개씩)
  └─ endCollecting()    → 누적된 프리미티브를 GT_PrimPolygonMesh로 변환
```

```cpp
// 등록: bind()로 프리미티브 타입에 Collector 연결
GT_PrimTetraCollect::GT_PrimTetraCollect(const GA_PrimitiveTypeId &id) : myId(id) {
    bind(myId);
}
```

**사면체 → 폴리곤 메시 변환:**

```cpp
static const int vertex_order[] = {
    0, 1, 2,   // face 0
    1, 3, 2,   // face 1
    1, 0, 3,   // face 2
    0, 2, 3    // face 3
};
```

**어트리뷰트 전달:**

```cpp
shared  = geometry->getPointAttributes(filter);                 // 포인트 → shared
vertex  = geometry->getVertexAttributes(filter, &ga_vertices);  // 버텍스
uniform = geometry->getPrimitiveAttributes(filter, &ga_faces);  // 프리미티브 → uniform
detail  = geometry->getDetailAttributes(filter);                // 디테일

pmesh = new GT_PrimPolygonMesh(counts, ptnums, shared, vertex, uniform, detail);
```

#### GR_PrimTetra — GL 렌더링

- 12 vertex로 4 면 구성 (face당 3 vertex)
- `RE_ShaderHandle`로 Houdini 빌트인 `.prog` 셰이더 참조
- `beauty_lit.prog`, `beauty_flat_lit.prog`, `beauty_material.prog`, `wire_color.prog`, `constant.prog`, `depth_cube.prog`, `depth_linear.prog`, `matte.prog`
- `RE_LightList::bindForShader()` 조명 바인딩
- `RE_MaterialPtr::updateShaderForMaterial()` 머티리얼 바인딩
- 인스턴싱 지원 (`drawInstanceGroup`)

#### SOP_Tetra — Data ID 관리

```cpp
SOP_Tetra::SOP_Tetra(...) {
    mySopFlags.setManagesDataIDs(true); // 수동 Data ID 관리
}

OP_ERROR SOP_Tetra::cookMySop(...) {
    gdp->getP()->bumpDataId();  // P 수정 후 반드시 bump
    // gdp->getPrimitiveList().bumpDataId();  // 프리미티브 내부 미변경시 생략 → 뷰포트 최적화
}
```

---

### 📦 2.7 packedsphere — Packed 프리미티브 (간소화된 커스텀 프리미티브)

`tetprim`보다 **훨씬 간단한** 커스텀 프리미티브 추가 방법. `GU_PackedImpl` 상속.

**핵심 오버라이드:**

```cpp
class GU_PackedSphere : public GU_PackedImpl {
    GU_PackedFactory *getFactory() const override;
    GU_PackedImpl    *copy() const override;
    bool  isValid() const override;
    bool  getBounds(UT_BoundingBox &box) const override;
    bool  save(UT_Options&, const GA_SaveMap&) const override;
    bool  load(GU_PrimPacked*, const UT_Options&, ...) override;
    GU_ConstDetailHandle getPackedDetail(GU_PackedContext*) const override;
    bool  unpack(GU_Detail&, const UT_Matrix4D*) const override;
};
```

- **LOD 기반 공유 지오메트리**: 같은 LOD의 구체는 같은 `GU_Detail`을 공유 → 메모리 절약
- **JSON 로드 지원**: `supportsJSONLoad()` + `loadFromJSON()`
- **GT 리파인먼트** (`GT_GEOPackedSphere`): 기본 Packed 프리미티브 렌더링과 동일. 제거해도 변화 없음

**GU_PackedFactory 서브클래스 + Intrinsic 등록:**

```cpp
class SphereFactory : public GU_PackedFactory {
    SphereFactory() : GU_PackedFactory("PackedSphere", "Packed Sphere") {
        registerIntrinsic(theLodStr,
            IntGetterCast(&GU_PackedSphere::intrinsicLod),
            IntSetterCast(&GU_PackedSphere::setLOD));
    }
    GU_PackedImpl *create() const override { return new GU_PackedSphere(); }
};
```

**LOD별 공유 지오메트리 캐싱:**

```cpp
class CacheEntry {
    CacheEntry(int lod) {
        GU_Detail *gdp = new GU_Detail();
        GU_PrimSphereParms parms(gdp);
        parms.freq = lod;
        GU_PrimSphere::build(parms, GEO_PRIMPOLYSOUP);
        myGdp.allocateAndSet(gdp);
    }
};
static CacheEntry *theCache[MAX_LOD+1]; // 1~32 LOD 캐시
static UT_Lock theLock;                  // 스레드 안전

static GU_ConstDetailHandle getSphere(int lod) {
    UT_AutoLock lock(theLock);
    if (!theCache[lod]) theCache[lod] = new CacheEntry(lod);
    return theCache[lod]->detail();
}
```

**DSO 진입점 + 등록:**

```cpp
void GU_PackedSphere::install(GA_PrimitiveFactory *gafactory) {
    theFactory = new SphereFactory();
    GU_PrimPacked::registerPacked(gafactory, theFactory);
    theTypeId = theFactory->typeDef().getId();
    GT_GEOPackedSphere::registerPrimitive(theTypeId);
}

void newGeometryPrim(GA_PrimitiveFactory *f) { GU_PackedSphere::install(f); }
```

**LOD 변경 시 노티피케이션:**

```cpp
void GU_PackedSphere::setLOD(GU_PrimPacked *prim, exint l) {
    clearSphere();
    myLOD = l;
    clearBoxCache();
    if (prim) prim->topologyDirty(); // 뷰포트에 변경 알림
}
```

| 관련 파일 | 역할 |
|----------|------|
| `GU_PackedSphere` | `GU_PackedImpl` 구현 (LOD, 공유 지오메트리) |
| `GT_GEOPackedSphere` | GT 리파인먼트 (기본 동작과 동일, 데모용) |
| `packedsphere.C` | standalone: Packed 프리미티브를 디스크에 저장 |

---

### 🖥️ 2.8 COP2 — Compositing (5 파일)

이미지 프로세싱 노드. 타일 기반 처리.

- `COP2_FullImageFilter`: 전체 이미지 필터 (블러 유사). `TIL_Region` 전체 접근
- `COP2_SampleFilter`: 타일 기반 필터. `cookMyTile()` 패턴
- `COP2_PixelAdd`: 픽셀 단위 연산. 가장 간단
- `COP2_SampleGenerator`: 이미지 생성기 (노이즈)
- `COP2_MultiInputWipe`: 멀티 인풋 와이프 전환

**COP2_PixelAdd — 픽셀 연산 패턴:**

```cpp
// RU_PixelFunction 서브클래스
class cop2_AddFunc : public RU_PixelFunction {
    bool eachComponentDifferent() const override { return true; }
    bool needAllComponents() const override { return false; }

    // 스칼라 함수: 컴포넌트별 호출
    static float add(RU_PixelFunction *pf, float val, int comp) {
        return val + ((cop2_AddFunc*)pf)->myAddend[comp];
    }
    RUPixelFunc getPixelFunction() const override { return add; }

    // 벡터 함수: 모든 컴포넌트 한번에
    static void addvec(RU_PixelFunction *f, float **vals, const bool *scope);
    RUVectorFunc getVectorFunction() const override { return addvec; }
};

// COP2_PixelOp 서브클래스에서 함수 생성
RU_PixelFunction* addPixelFunction(const TIL_Plane*, int, float t, ...) {
    return new cop2_AddFunc(ADD(0,t), ADD(1,t), ADD(2,t), ADD(3,t));
}

// 진입점
void newCop2Operator(OP_OperatorTable *table) {
    table->addOperator(new OP_Operator("hdk_samplepixadd", ...));
}
```

**COP2_SampleGenerator — 타일 생성 패턴:**

```cpp
class COP2_SampleGenerator : public COP2_Generator {
    TIL_Sequence* cookSequenceInfo(OP_ERROR &error) override;     // 해상도, 프레임, 플레인 설정
    COP2_ContextData* newContextData(const TIL_Plane*, ...) override; // 파라미터 스태시
    OP_ERROR generateTile(COP2_Context &context, TIL_TileList *tiles) override;
};

// 타일 생성 (멀티스레드 호출 — 스레드 안전 필수!)
OP_ERROR generateTile(COP2_Context &context, TIL_TileList *tiles) {
    TIL_Tile *itr;
    int ti;
    FOR_EACH_UNCOOKED_TILE(tiles, itr, ti) {  // 아직 안 쿡된 타일만
        for(int i = 0; i < tiles->mySize; i++)
            dest[i] = SYSrandom(seed) * amp[ti];
        writeFPtoTile(tiles, dest, ti);
    }
}
```

---

### 🎬 2.9 karma_procedurals — Karma 렌더러 프로시저럴

- `BRAY_HdSphere`: Karma용 구체 프로시저럴. `BRAY_Procedural` 상속, `BRAY_AttribList` 어트리뷰트 바인딩
- `BRAY_HdBox`: Karma용 박스 프로시저럴
- VFL 파일들: `grasspatch.vfl`, `mandelbulb_*.vfl`, `sphere_*.vfl` — Karma VEX 인터섹션/바운딩 셰이더

---

### 🔧 2.10 standalone — 독립 실행 프로그램

Houdini 없이 HDK 라이브러리만으로 동작하는 프로그램들.

| 파일 | 핵심 |
|------|------|
| `standalone.C` | **Houdini 코어 초기화** (`MOT_Director`, `OPsetDirector`, `PIcreateResourceManager`). 커스텀 Houdini 앱 제작 |
| `geoisosurface.C` | ⭐ `polyIsoSurface()` 로 밀도 함수 → 메시 (Marching Cubes 유사) |
| `gengeovolume.C` | `GU_PrimVolume` 프로그래밍 방식 볼륨 생성 |
| `geo2voxel.C` | 지오메트리 → 복셀 그리드 변환 |
| `traverse.C` | OP 노드 그래프 순회 (`OP_Node::getChild()` 등) |
| `i3dsphere.C` | 3D 텍스처 파일(`.i3d`) 생성 |
| `i3ddsmgen.C` | DSM(Deep Shadow Map) 생성 |
| `dsmprint.C` | DSM 파일 내용 출력 |
| `tiledevice.C` | 타일 기반 이미지 디바이스 구현 |
| `msgpipe.C` | 프로세스 간 메시지 파이프 |

**geoisosurface.C 핵심:**

```cpp
static float densityFunction(const UT_Vector3 &P, void *data) {
    return 1 - P.length();  // 단위 구체의 signed distance
}

GU_Detail gdp;
UT_BoundingBox bounds(-1, -1, -1, 1, 1, 1);
gdp.polyIsoSurface(densityFunction, NULL, bounds, 20, 20, 20);
gdp.save("sphere.bgeo", NULL);
```

**standalone.C 초기화 패턴:**

```cpp
MOT_Director *boss = new MOT_Director("standalone");
OPsetDirector(boss);
PIcreateResourceManager();
CMD_Manager *cmd = boss->getCommandManager();
cmd->sendInput("source -q 123.cmd");
```

---

### 📋 2.11 기타 주요 카테고리

#### LOP — Solaris/USD
- `LOP_Sphere/`: 기본 LOP 노드. USD 프리미티브 생성
- `XUSD_TrueAutoCollection`: 커스텀 USD 컬렉션 로직

#### OBJ — Object Level (3 노드)
- `OBJ_Lamp`: 커스텀 오브젝트 (램프 지오메트리 내장)
- `OBJ_Shake`: 카메라 흔들림 효과
- `OBJ_WorldAlign`: 월드축 정렬 오브젝트

#### CHOP — Channel Operators (3 노드)
- `CHOP_Blend`: 채널 블렌딩
- `CHOP_Spring`: 스프링 다이나믹스 채널 (**가장 복잡한 CHOP 샘플**)
- `CHOP_Stair`: 계단 함수 채널

**CHOP_Spring 핵심 패턴:**

```cpp
// 이중 쿡: 일반 + 타임슬라이스
class CHOP_Spring : public CHOP_Realtime {
    OP_ERROR cookMyChop(OP_Context &context) override;    // 전체 범위 쿡
    OP_ERROR cookMySlice(OP_Context &context, int start, int end) override; // 실시간 슬라이스
    int      isSteady() const override;                    // 정상상태 검출
    ut_RealtimeData *newRealtimeDataBlock(...) override;   // 중간값 스태싱
};

// 타임슬라이스용 중간값 저장
class ut_SpringData : public ut_RealtimeData {
    fpreal myDn1, myDn2;  // 이전 2 프레임 변위
    bool loadStates(UT_IStream &is, int version) override;
    bool saveStates(UT_OStream &os) override;
};

// 로컬 변수: C(현재 트랙), NC(전체 트랙 수)
CH_LocalVariable myVariableList[] = {
    { "C",  VAR_C,  0 },
    { "NC", VAR_NC, 0 },
};

// 진입점
void newChopOperator(OP_OperatorTable *table) {
    table->addOperator(new OP_Operator("hdk_spring", "HDK Spring", ...));
}
```

#### VEX — VEX 커스텀 함수 (3 파일)
- `VEX_Example`: 기본 VEX 함수 등록 (drand, time, gamma, myprint)
- `VEX_Sort`: 정렬 함수
- `VEX_Ops`: VEX 연산자

**VEX_Example의 핵심 패턴:**

```cpp
// DSO 진입점
void newVEXOp(void *) {
    // 시그니처 문법: "함수명@리턴타입인자타입들"
    // &: output, F: float, I: int, +: 가변인자
    new VEX_VexOp("drand@&FI"_sh,         // float drand(int seed)
        drand_Evaluate<VEX_32>,             // 32bit evaluator
        drand_Evaluate<VEX_64>,             // 64bit evaluator
        VEX_ALL_CONTEXT,                    // 모든 VEX 컨텍스트
        nullptr, nullptr,                   // init (32, 64)
        nullptr, nullptr);                  // cleanup (32, 64)

    // 비결정적 함수: 최적화 레벨 낮춤
    new VEX_VexOp("time@&I"_sh, ..., VEX_OPTIMIZE_1);

    // 공유 데이터 (gamma table): init/cleanup 제공
    new VEX_VexOp("gamma@&FF"_sh, ...,
        gamma_Init<VEX_32>, gamma_Init<VEX_64>,       // 공유 테이블 초기화
        gamma_Cleanup<VEX_32>, gamma_Cleanup<VEX_64>); // 정리

    // 가변인자 함수
    new VEX_VexOp("myprint@+"_sh, myprint_Evaluate<VEX_32>, ...);
}

// Evaluator: VEXfloat<PREC>/VEXint<PREC> 정밀도 템플릿
template <VEX_Precision PREC>
static void drand_Evaluate(int, void *argv[], void *) {
    VEXfloat<PREC> *result = (VEXfloat<PREC>*)argv[0];
    const VEXint<PREC> *seed = (const VEXint<PREC>*)argv[1];
    *result = SYSdrand48();
}
```

#### VOP — VOP 노드 (2 파일)
- `VOP_Switch`, `VOP_CustomContext`

#### CVEX — C VEX 호출
- `cvexsample.C`, `simple.C`: C++에서 VEX 프로그램을 호출하는 standalone 예제

---

### 📋 2.12 전체 기타 카테고리 요약

| 카테고리 | 파일 | 설명 |
|---------|------|------|
| **packedprim** | `packedprim.C` | Packed 프리미티브 기초 |
| **packedshareddata** | `GU_PackedSharedData` | 공유 데이터 Packed 프리미티브 |
| **euclid** | `EUC_*` + `SOP_Euclid` | 유클리드 기하학 시스템 (점, 직선, 표현식 엔진) |
| **field3d** | `f3d_io` + `ROP_Field3D` + `GEO_Field3DTranslator` | Field3D 포맷 I/O |
| **GEO** | `GEO_VoxelTranslator` | 커스텀 지오메트리 파일 포맷 변환기 |
| **FS** | `FS_HomeHelper` + `FS_Background` | 커스텀 파일 시스템 핸들러 |
| **IMG** | `IMG_Sample` + `TIL_NullFilter` | 커스텀 이미지 포맷 + 널 필터 |
| **HOM** | `SOP_HOMWave` + Python 파일 | HOM/Python ↔ HDK 연동 |
| **OPUI** | `OPUI_HighlightBadge`, `OPUI_MemUsageTextBadge` | 노드 UI 뱃지 커스터마이즈 |
| **APEX** | `apex_external_test.C` | APEX 외부 테스트 |
| **PDG** | `PDG_ProcessorRandom` + `PDG_PartitionByParity` | TOPs 커스텀 프로세서/파티셔너 |
| **ROP** | `ROP_Dumper` | 커스텀 렌더 출력 노드 |
| **SHOP** | `SHOP_Multi`, `SHOP_POVMaterial` | 커스텀 셰이더 오퍼레이터 |
| **DOP** | `DOP_GroupAndApply` | DOP 네트워크 그룹/적용 |
| **TS** | `TS_cosKernel` | 트라이서프 커널 |
| **USD** | `USD_HoudiniPathMapArResolver`, `USD_TmpArResolver` | 커스텀 USD Asset Resolver |
| **mocapstream** | `MocapStreamRokokoHDK` | Rokoko 모캡 스트리밍 |
| **SOHO** | `Hello*.py` | SOHO 스크립팅 (Python 렌더 출력) |
| **expr** | `channel.C`, `functions.C` 등 | 커스텀 표현식 함수/변수 |
| **ui** | `cmd_ui.C` | 커스텀 UI 다이얼로그 |
| **alligator** | `alligator.C` | 노이즈 함수 구현 |

---

## 🔑 3. 핵심 HDK 코드 패턴/이디엄

### 📖 GA_Handle 패턴 (어트리뷰트 접근)

```cpp
// 읽기 전용
GA_ROHandleV3 Phandle(gdp->findFloatTuple(GA_ATTRIB_POINT, "P", 3));
if (Phandle.isValid()) {
    UT_Vector3 pos = Phandle.get(ptoff);
}

// 읽기/쓰기
GA_RWHandleF life(gdp->addFloatTuple(GA_ATTRIB_POINT, "life", 1));
life.set(ptoff, 1.0f);

// 문자열
GA_ROHandleS name(gdp->findStringTuple(GA_ATTRIB_PRIMITIVE, "name", 1));
const char *str = name.get(primoff);
```

| Handle | GA Type | 예시 |
|--------|---------|------|
| `GA_ROHandleF` / `GA_RWHandleF` | float | life, pscale |
| `GA_ROHandleV3` / `GA_RWHandleV3` | UT_Vector3 | P, N, Cd, v |
| `GA_ROHandleV2` / `GA_RWHandleV2` | UT_Vector2 | uv |
| `GA_ROHandleI` / `GA_RWHandleI` | int | id |
| `GA_ROHandleS` / `GA_RWHandleS` | string | name, shop_materialpath |

### 📖 PRM_Template 파라미터 정의 패턴

```cpp
static PRM_Name names[] = {
    PRM_Name("radius", "Radius"),
    PRM_Name("center", "Center"),
};
static PRM_Default radiusDefault(1.0);

PRM_Template myTemplateList[] = {
    PRM_Template(PRM_FLT_J, 1, &names[0], &radiusDefault),  // float
    PRM_Template(PRM_XYZ_J, 3, &names[1], PRMzeroDefaults), // vector3
    PRM_Template(PRM_STRING, 1, &theName),                    // string
    PRM_Template(PRM_TOGGLE, 1, &theName, PRMoneDefaults),   // toggle
    PRM_Template()  // 종료자 (필수!)
};
```

### 📖 Data ID 관리 패턴

```cpp
// SOP 생성자에서 선언
mySopFlags.setManagesDataIDs(true);

// cookMySop에서 변경한 어트리뷰트만 bump
gdp->getP()->bumpDataId();                    // P 변경시
gdp->getPrimitiveList().bumpDataId();         // 프리미티브 변경시
gdp->findAttribute(GA_ATTRIB_POINT, "Cd")->bumpDataId();  // 특정 어트리뷰트

// 전체 bump (비효율적, 피해야 함)
// → setManagesDataIDs(false)가 기본이며, 이 경우 cook 후 전체 bump
```

### 📖 SOP 쿠킹 필수 패턴

```cpp
// 입력 잠금 (RAII 패턴, 필수!)
OP_AutoLockInputs inputs(this);
if (inputs.lock(context) >= UT_ERROR_ABORT)
    return error();

// 시간 의존 SOP 선언 (파티클 등 매 프레임 쿡 필요시)
OP_Node::flags().setTimeDep(true);

// 시간 변환
CH_Manager *chman = OPgetDirector()->getChannelManager();
fpreal currframe = chman->getSample(context.getTime());
fpreal time = chman->getTime(frame);

// 지오메트리 복사 전략 (여러 소스 합칠 때)
GEO_CopyMethod method;
// GEO_COPY_ONCE  — 소스 1개일 때 (가장 효율적)
// GEO_COPY_START — 첫 소스 (초기화)
// GEO_COPY_ADD   — 중간 소스 (추가)
// GEO_COPY_END   — 마지막 소스 (마무리)
gdp->copy(*src, method, true, false, GA_DATA_ID_CLONE);

// 새 요소 추적 (트랜스폼 등에 사용)
GA_IndexMap::Marker pointmarker(gdp->getPointMap());
GA_IndexMap::Marker primmarker(gdp->getPrimitiveMap());
gdp->copy(*src, GEO_COPY_ADD, ...);
gdp->transform(xform, primmarker.getRange(), pointmarker.getRange(), false);

// 다른 SOP 쿠킹 (Object Merge 패턴)
SOP_Node *sopptr = getSOPNode(sopname, 1);  // 1 = extra input 등록
const GU_Detail *cookedgdp = sopptr->getCookedGeo(context);
addExtraInput(objptr, OP_INTEREST_DATA);
```

### 📖 SIM_Data 매크로 패턴

```cpp
// 데이터 팩토리 선언 (.h)
DECLARE_STANDARD_GETCASTTOTYPE();
DECLARE_DATAFACTORY(MyClass, BaseClass, "My Label", getDopDescription());

// 데이터 팩토리 구현 (.C)
IMPLEMENT_DATAFACTORY(MyClass);

// 데이터 접근
SIM_ScalarField *field = SIM_DATA_GET(*obj, "density", SIM_ScalarField);
SIM_ScalarField *field = SIM_DATA_CREATE(*obj, "density", SIM_ScalarField, 0);
const MyData *data = SIM_DATA_CASTCONST(source, MyData);
```

### 📖 DM Hook 등록 + Scene Option 패턴

```cpp
void newRenderHook(DM_RenderTable *table) {
    table->registerSceneHook(new MyHook,
                              DM_HOOK_BEAUTY,
                              DM_HOOK_BEFORE_NATIVE);
    table->installSceneOption("my_option_id", "My Option Label");
}

bool MyRenderHook::render(RE_RenderContext r, const DM_SceneHookData &hook_data) {
    if (!hook_data.disp_options->isSceneOptionEnabled("my_option_id"))
        return false;
    // ... GL 코드 ...
}
```

### 📖 GUI Hook 등록 패턴

```cpp
void newRenderHook(DM_RenderTable *dm_table) {
    // GEO 기반
    dm_table->registerGEOHook(new MyHook(), GA_PrimitiveTypeId(type), priority,
                               GUI_HOOK_FLAG_NONE);         // 완전 대체
                            // GUI_HOOK_FLAG_AUGMENT_PRIM   // 장식 추가

    // GT 기반
    dm_table->registerGTHook(new MyHook(), GT_PRIM_POLYGON_MESH, priority,
                              GUI_HOOK_FLAG_PRIM_FILTER);   // 리파인 필터

    // 지오메트리 옵션 (선택적)
    dm_table->installGeometryOption("opt_id", "Option Label",
        GUI_GeometryOptionFlags(GUI_GEO_OPT_REFINE_ON_ACTIVATION |
                                GUI_GEO_OPT_REFINE_ON_DEACTIVATION));
}
```

### 📖 RE_Geometry VBO 업로드 패턴

```cpp
RE_Geometry *geo = new RE_Geometry;
geo->cacheBuffers(getCacheName());

RE_VertexArray *pos = geo->findCachedAttrib(r, "P", RE_GPU_FLOAT32, 3,
                                             RE_ARRAY_POINT, true);

if (pos->getCacheVersion() != dp.geo_version) {
    UT_Vector3F *pdata = static_cast<UT_Vector3F*>(pos->map(r));
    // ... 데이터 기록 ...
    pos->unmap(r);
    pos->setCacheVersion(dp.geo_version);
}

geo->connectAllPrims(r, RE_GEO_WIRE_IDX, RE_PRIM_LINES, NULL, true);
geo->connectAllPrims(r, RE_GEO_SHADED_IDX, RE_PRIM_TRIANGLES, NULL, true);
```

### 📖 UT_VoxelArray 타일 기반 순회 패턴

```cpp
UT_VoxelArrayIteratorF vit;
vit.setArray(field->fieldNC());
vit.setCompressOnExit(true);
vit.setPartialRange(info.job(), info.numJobs());

for (vit.rewind(); !vit.atEnd(); vit.advance()) {
    if (vit.isStartOfTile()) {
        if (boss->opInterrupt()) break;
        if (vit.isTileConstant() && srcsampler.isTileConstant(vit, srcval)) {
            vit.getTile()->makeConstant(vit.getValue() + srcval);
            vit.skipToEndOfTile();
            continue;
        }
    }
    vit.setValue(vit.getValue() + srcsampler.getValue(vit));
}
```

---

## 📚 4. 핵심 클래스/API 요약

### 🖥️ 렌더링 (RE 라이브러리)

| 클래스 | 역할 |
|--------|------|
| `RE_Render` | OpenGL 상태 머신 래퍼 |
| `RE_Shader` | GLSL 셰이더 컴파일/링크/바인드 |
| `RE_ShaderHandle` | Houdini 빌트인 `.prog` 셰이더 참조 |
| `RE_Texture` | GL 텍스처 생성/관리 |
| `RE_Geometry` | VBO/VAO 래퍼 (어트리뷰트 + 연결) |
| `RE_VertexArray` | 버텍스 버퍼 + 캐시 버전 |
| `RE_OGLFramebuffer` | FBO (오프스크린 렌더 타겟) |
| `RE_OcclusionQuery` | GL Occlusion Query |
| `RE_Font` | 뷰포트 텍스트 렌더링 |

### 🎨 뷰포트 훅 (DM/GUI)

| 클래스 | 역할 |
|--------|------|
| `DM_SceneHook` | 렌더훅 팩토리 (뷰포트당 인스턴스 관리) |
| `DM_SceneRenderHook` | 실제 GL 드로잉 수행 |
| `DM_VPortAgent` | 뷰포트 접근자 (Beauty Texture, 오브젝트 리스트) |
| `GUI_PrimitiveHook` | 프리미티브 훅 팩토리 |
| `GR_Primitive` | 커스텀 프리미티브 GL 렌더링 |
| `GR_Utils` | 인스턴싱, 와이어 셰이더 유틸리티 |

### 📐 지오메트리 (GA/GEO/GU/GT)

| 레이어 | 역할 |
|--------|------|
| `GA_*` | Geometry Attribute 레이어 (저레벨 데이터) |
| `GEO_*` | Geometry 프리미티브 정의 |
| `GU_*` | Geometry Utility (알고리즘) |
| `GT_*` | Geometry Transport (뷰포트 전달) |

### 🔗 GT (Geometry Transport)

| 클래스 | 역할 |
|--------|------|
| `GT_GEOPrimCollect` | GEO → GT 수집기 기본 클래스 |
| `GT_PrimPolygonMesh` | 폴리곤 메시 GT 프리미티브 |
| `GT_GEODetailList` | 다중 디테일 접근 |
| `GT_GEOAttributeFilter` | 어트리뷰트 필터링 |
| `GT_DataArrayHandle` | GT 데이터 배열 핸들 |

### 🌊 시뮬레이션 (SIM)

| 클래스 | 역할 |
|--------|------|
| `SIM_Data` | 시뮬레이션 데이터 기본 클래스 |
| `SIM_Solver` / `SIM_SingleSolver` | 오브젝트 단위 솔버 |
| `GAS_SubSolver` | 필드/지오메트리 단위 서브솔버 |
| `SIM_Force` | 포스 데이터 |
| `SIM_OptionsUser` | 파라미터 접근 믹스인 |
| `SIM_DopDescription` | DOP 노드 UI 정의 |
| `SIM_ScalarField` / `SIM_VectorField` | 필드 데이터 |
| `SIM_GuideShared` | 공유 가이드 지오메트리 |

### 📦 Packed 프리미티브

| 클래스 | 역할 |
|--------|------|
| `GU_PackedImpl` | Packed 프리미티브 구현 인터페이스 |
| `GU_PrimPacked` | Packed 프리미티브 컨테이너 |
| `GU_PackedFactory` | Packed 프리미티브 팩토리 |

---

## 🗺️ 5. 그래픽스 프로그래머를 위한 학습 로드맵

### 🥇 Tier 1 — 즉시 숙지 (뷰포트 렌더링 + 기본)

1. **`SOP/SOP_Star/`** — 가장 기본적인 SOP. `.proto.h` 자동생성, `PRM_TemplateBuilder`
2. **`tetprim/`** — 커스텀 프리미티브 전체 파이프라인 (GEO→GT→GR)
3. **`DM/DM_LightBloomHook.C`** — FBO 포스트프로세스
4. **`DM/DM_BackgroundHook.C`** — GL 셰이더 + 텍스처 + 풀스크린 쿼드
5. **`DM/DM_OverdrawHook.C`** — 멀티패스 + Occlusion Query
6. **`GUI/GUI_PrimFramework.C`** — GR_Primitive 전체 인터페이스 레퍼런스
7. **`SOP/SOP_SParticle`** — 파티클 시스템 기초 (birth, move, collide, attributes)

### 🥈 Tier 2 — 렌더링/시뮬레이션

8. **`RAY/RAY_DemoVolumeSphere.C`** — 커스텀 볼륨 렌더링
9. **`RAY/RAY_DemoMountain.C`** — LOD 기반 재귀 프로시저럴
10. **`RAY/RAY_DemoEdgeDetectFilter.C`** — 픽셀 필터 (포스트프로세스)
11. **`SIM/SIM_GasAdd.C`** — 보셀 필드 조작 패턴
12. **`SIM/SNOW_Solver.C`** — 완전한 솔버 + 데이터 + 시각화

### 🥉 Tier 3 — 지오메트리 / 프로덕션

13. **`SOP/SOP_WindingNumber/`** — BVH + SolidAngle (수학 알고리즘)
14. **`SOP/SOP_CopyToPoints/`** — 최신 SOP_NodeVerb 패턴
15. **`packedsphere/`** — Packed 프리미티브 + GT 리파인먼트
16. **`SOP/SOP_HDKObject`** — MULTIPARM + DYNAMIC_PATH (실무 필수)
17. **`SOP/SOP_BlindData`** — HIP 파일 커스텀 저장 (프로덕션 필수)

### 🏅 Tier 4 — Karma / USD / Standalone

18. **`karma_procedurals/BRAY_HdSphere.C`** — Karma 프로시저럴
19. **`LOP/LOP_Sphere/`** — LOP 노드 기본
20. **`USD/`** — 커스텀 Asset Resolver
21. **`standalone/geoisosurface.C`** — Houdini 없이 `polyIsoSurface()`. 오프라인 도구 제작
22. **`standalone/standalone.C`** — `MOT_Director` 초기화. 커스텀 Houdini 앱

---

## 🛠️ 6. 빌드 방법

### CMakeLists.txt 패턴 (최신)
```cmake
cmake_minimum_required(VERSION 3.12)
project(SOP_Star)
find_package(Houdini REQUIRED)
houdini_generate_proto_headers(FILES SOP_Star.C)
houdini_add_library(SOP_Star SHARED SOP_Star.C)
target_link_libraries(SOP_Star Houdini)
houdini_configure_target(SOP_Star)
```

### hcustom (레거시)
```bash
hcustom SOP_Star.C
# → dso/SOP_Star.so (Linux) 또는 SOP_Star.dll (Windows)
```


---

## 📌 마무리

HDK 샘플은 **공식 문서보다 더 실질적인 레퍼런스**다.
그래픽스 관련 작업을 할 때는 `tetprim`과 `DM` 카테고리를 먼저 정복하고,
필요한 시점에 `RAY`, `SIM`, `GUI`를 참조하면 된다.

모든 소스 경로:

```
C:\Program Files\Side Effects Software\Houdini 21.0.559\toolkit\samples\
```
