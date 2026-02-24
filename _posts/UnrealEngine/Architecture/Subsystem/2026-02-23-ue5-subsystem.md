---
title: "[UE5/Architecture] Subsystem"
description: >-
  Subsystem
author: seongcheol
date: 2026-02-23 02:40:00 +0900
categories: [Unreal Engine, Architecture, Subsystem]
tags: [Unreal Engine, Architecture, Subsystem]
pin: true
image: 
  path: /assets/img/common/title/ue_title.jpg
---

## Unreal Engine Subsystem

### 왜 Subsystem을 사용하는가?

기존 방식은 기능을 추가할 때 Engine Class를 직접 `Override`하거나 `API`를 추가해야 했다.
`Subsystem`은 이미 존재하는 클래스(`UGameInstance`, `UWorld` 등)에 기능을 **외부에서 주입**하는 방식이므로 다음과 같은 이점이 있다.

- Engine Class Override 불필요
- 기존 클래스에 API 추가 불필요
- Blueprint에 자동 노출 및 접근 기능
- 코드 재사용성 향상

### Subsystem 종류

- UEngineSubsystem
- UEditorSubsystem
- UGameInstanceSubsystem
- ULocalPlayerSubsystem
- UWorldSubsystem

| Type          | Class                    | Environment     | Lifetime                      |
| :------------ | :------------------------| :-------------- | ----------------------------- |
| Engine        | `UEngineSubsystem`       | Editor, In-Game | Engine 전체 실행 동안            |
| Editor        | `UEditorSubsystem`       | Editor Only     | Editor 실행 동안                |
| Game Instance | `UGameInstanceSubsystem` | In-Game         | In-Game 시작 ~ 종료             |
| Local Player  | `ULocalPlayerSubsystem`  | In-Game         | `ULocalPlayer` Lifetime       |
| World         | `UWorldSubsystem`        | In-Game         | `UWorld` Lifetime (Level 별)   |

## Lifecycle Detail

### Engine - `UEngineSubsystem`

**Begin**
```
Engine Subsystem의 Module 로드
-> Module::Startup() 반환
-> Initialize() 호출
```

**End**
```
Module::Shutdown() 호출
-> Deinitialize() 호출
```

### Editor - `UEditorSubsystem`

**Begin**
```
Editor Subsystem의 Module 로드
-> Module::Startup() 반환
-> Initialize() 호출
```

**End**
```
Module::Shutdown() 호출
-> Deinitialize() 호출
```

> **ex)** `UEditorActorSubsystem`
> ```cpp
> // 선택된 level actor 목록
> TArray<AActor*> SelectedActors = EditorActorSubsystem->GetSelectedLevelActors();
>
> // 전체 level actor 목록
> TArray<AActor*> AllActors = EditorActorSubsystem->GetAllLevelActors();
> ```

### Game Instance - `UGameInstanceSubsystem`

**Begin**
```
Module::Startup() 반환
-> UGameInstance 생성
-> UMyGameSubsystem 인스턴스 생성
-> UGameInstance 초기화
-> UMyGameSubsystem::Initialize() 호출
```

**End**
```
UGameInstance 종료
-> UMyGameSubsystem::Deinitialize() 호출
-> 인스턴스 참조 삭제
-> Garbage Collection 대상이 됨
```

### Local Player - `ULocalPlayerSubsystem`

> Level이 여러 개이면, 해당 Level에 존재하는 `ULocalPlayer`의 `Lifetime`을 따른다.
{: .prompt-info}

**Begin**
```
LocalPlayer Subsystem의 Module 로드
-> Module::Startup() 반환
-> Initialize() 호출
```

**End**
```
MModule::Shutdown() 호출
-> Deinitialize() 호출
```

### World - `UWorldSubsystem`

> Level이 여러 개이면, Level 별로 독립적인 인스턴스가 존재한다.
{: .prompt-info}

**Begin**
```
World Subsystem의 Module 로드
-> Module::Startup() 반환
-> Initialize() 호출
```

**End**
```
Module::Shutdown() 호출
-> Deinitialize() 호출
```

## Blueprint 접근

Subsystem은 `Blueprint`에 **자동 노출**된다. `UFUNCTION()` 마크업으로 노출할 API를 직접 제어한다.

```cpp
UCLASS()
class UMyGameSubsystem : public UGameInstanceSubsystem
{
  GENERATED_BODY()

public:
  // Blueprint에서 호출 가능
  UFUNCTION(BlueprintCallable, Category = "MyGame|Stats")
  void IncrementResourceStat();

  // Blueprint에서 읽기 전용
  UFUNCTION(BlueprintPure, Category = "MyGame|Stats")
  int32 GetResourceCount() const;

private:
  int32 _resource_count = 0;
}
```

Blueprint Graph에서 우클릭 -> "subsystems" 검색 시, 타입 별 카테고리를 자동 분류되어 나타난다.
별도의 Cast 없이 typed node로 바로 접근할 수 있다.

> `UFUNCTION()` 마크업이 없는 함수는 `Blueprint`에 **노출되지 않는다.**   
> `C++` 전용 로직은 마크업 없이 두는 것이 **권장**된다.
{: .prompt-tip}

## Plugin 개발 시 이점

Subsystem은 **Plugin 개발**에 특히 유리하다.

기존의 Plugin 방식은 Plugin이 작동하려면, 게임 코드에 수동으로 `초기화/해제` 코드를 적성해야 했다.   
`Subsystem`을 사용하면, Plugin을 추가하는 것만으로 자동으로 `인스턴스`가 생성되고 초기화된다.

```
❌ 기존 방식
  Plugin 추가
  -> GameInstance::Init()에 수동 초기화 코드 추가 필요
  -> GameInstance::Shutdown()에 수동 해제 코드 추가 필요
  -> Plugin 제거 시, 해당 코드도 수동 삭제 필요

✅ Subsystem 방식
  Plugin 추가
  -> 자동으로 인스턴스 생성 및 Initialize() 호출
  -> 자동으로 Deinitialize() 호출
  -> Plugin 제거 시, 별도 코드수정 불필요
```

> Plugin 사용자는 `API` 사용법에만 집중할 수 있다.   
> 초기화/해제 시점은 `UE`가 보장한다.
{: .prompt-info}

---

## Access Pattern

```cpp
// ── Engine Subsystem ─────────────────────────────────────────────
class UMyEngineSubsystem : public UEngineSubsystem { ... };

UMyEngineSubsystem* Sub = GEngine->GetEngineSubsystem<UMyEngineSubsystem>();


// ── Editor Subsystem ─────────────────────────────────────────────
class UMyEditorSubsystem : public UEditorSubsystem { ... };

UMyEditorSubsystem* Sub = GEditor->GetEditorSubsystem<UMyEditorSubsystem>();


// ── GameInstance Subsystem ───────────────────────────────────────
class UMyGameSubsystem : public UGameInstanceSubsystem { ... };

UGameInstance* GI  = GetGameInstance();
UMyGameSubsystem* Sub = GI->GetSubsystem<UMyGameSubsystem>();


// ── LocalPlayer Subsystem ────────────────────────────────────────
class UMyPlayerSubsystem : public ULocalPlayerSubsystem { ... };

UGameInstance* GI     = GetGameInstance();
ULocalPlayer*  LP     = GI->GetFirstGamePlayer();
UMyPlayerSubsystem* Sub = LP->GetSubsystem<UMyPlayerSubsystem>();


// ── World Subsystem ──────────────────────────────────────────────
class UMyWorldSubsystem : public UWorldSubsystem { ... };

UMyWorldSubsystem* Sub = GetWorld()->GetSubsystem<UMyWorldSubsystem>();
```

> **주의**: 반환값은 항상 `nullptr` 체크 필요.  
> `ShouldCreateSubsystem()`이 `false`를 반환하면 `Get<>()`은 `nullptr`을 반환한다.
{: .prompt-warning}

---

## Game Instance vs Game Instance Subsystem

두 클래스 모두 게임 전체에서 데이터를 유지하는 용도로 사용할 수 있다.  
그러나 **역할과 생성 시점**이 다르며, 일반적으로 `UGameInstanceSubsystem`이 더 권장된다.

| 항목             | `UGameInstance`           | `UGameInstanceSubsystem`            |
| :-------------- | :------------------------ | :---------------------------------- |
| 생성 시점         | Game 시작 시 Spawn         | `UGameInstance` 생성 **이후** 생성     |
| 소멸 시점         | Game 종료 시 소멸           | `UGameInstance` 종료 시 소멸 → GC 처리  |
| Engine Override | 필요 (`UGameInstance` 상속) | 불필요                                |
| 코드 분리         | 단일 클래스에 집중            | 기능별로 분리 가능                      |
| Blueprint 노출   | 수동 설정 필요               | 자동 노출                             |

### 왜 `UGameInstanceSubsystem`이 더 유리한가?

게임에서는 레벨 이동(던전 입장, 마을 이동 등)이 빈번하고,  
FPS처럼 한 게임이 끝나고 다시 시작되는 경우도 많다.

이런 상황에서 `UGameInstance`에 모든 기능을 직접 추가하면 클래스가 비대해지고 유지보수가 어려워진다.  
`UGameInstanceSubsystem`을 사용하면 **기능을 독립적인 단위로 분리**할 수 있어 재사용성과 가독성이 높아진다.

```
❌ 모든 기능을 UGameInstance에 직접 추가
   UGameInstance
   └── 인벤토리 관리 코드
   └── 세이브 데이터 코드
   └── 네트워크 세션 코드
   └── ...

✅ 기능별로 Subsystem 분리
   UGameInstance
   UInventorySubsystem    (UGameInstanceSubsystem)
   USaveDataSubsystem     (UGameInstanceSubsystem)
   UNetworkSessionSubsystem (UGameInstanceSubsystem)
```

---

## `ShouldCreateSubsystem()`

Subsystem의 **조건부 생성**을 제어하는 `virtual` 함수.  
기본값은 `true`. Override하여 특정 조건에서만 Subsystem을 생성할 수 있다.

```cpp
// MyWorldSubsystem.h
UCLASS()
class UMyWorldSubsystem : public UWorldSubsystem
{
    GENERATED_BODY()

public:
    virtual bool ShouldCreateSubsystem(UObject* Outer) const override;
};

// MyWorldSubsystem.cpp
bool UMyWorldSubsystem::ShouldCreateSubsystem(UObject* Outer) const
{
    // CDO(Class Default Object)는 제외
    if (!Super::ShouldCreateSubsystem(Outer))
    {
        return false;
    }

    UWorld* World = Cast<UWorld>(Outer);
    if (!World)
    {
        return false;
    }

    // PIE, Game World에서만 생성. Editor Preview World 제외
    return World->WorldType == EWorldType::Game
        || World->WorldType == EWorldType::PIE;
}
```

> **주의**: `false` 반환 시 인스턴스 자체가 생성되지 않는다.  
> 이후 `GetSubsystem<T>()`는 `nullptr`을 반환하므로 반드시 null check 필요.
{: prompt-warning}

---

## Tick 지원 — `FTickableGameObject`

Subsystem은 기본적으로 Tick을 지원하지 않는다.  
Tick이 필요한 경우 `FTickableGameObject`를 **다중 상속**하여 구현한다.

```cpp
// MyTickableWorldSubsystem.h
UCLASS()
class UMyTickableWorldSubsystem : public UWorldSubsystem, public FTickableGameObject
{
    GENERATED_BODY()

public:
    // UWorldSubsystem
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;
    virtual void Deinitialize() override;

    // FTickableGameObject
    virtual void Tick(float DeltaTime) override;
    virtual TStatId GetStatId() const override;
    virtual bool IsTickable() const override;
};

// MyTickableWorldSubsystem.cpp
void UMyTickableWorldSubsystem::Tick(float DeltaTime)
{
    // Tick 로직
}

TStatId UMyTickableWorldSubsystem::GetStatId() const
{
    RETURN_QUICK_DECLARE_CYCLE_STAT(UMyTickableWorldSubsystem, STATGROUP_Tickables);
}

bool UMyTickableWorldSubsystem::IsTickable() const
{
    // CDO(Class Default Object)는 Tick 제외
    return !IsTemplate();
}
```

> **주의**: `IsTickable()`에서 `!IsTemplate()` 체크는 필수.  
> CDO까지 Tick되는 것을 방지한다.
{: .prompt-warning}

---

## 주요 Override 함수

### `UEngineSubsystem` / `UEditorSubsystem`

```cpp
virtual void Initialize(FSubsystemCollectionBase& Collection) override;
virtual void Deinitialize() override;
```

### `UGameInstanceSubsystem`

```cpp
virtual void Initialize(FSubsystemCollectionBase& Collection) override;
virtual void Deinitialize() override;
```

### `ULocalPlayerSubsystem`

```cpp
virtual void Initialize(FSubsystemCollectionBase& Collection) override;
virtual void Deinitialize() override;

// PlayerController가 설정/해제될 때 호출
virtual void PlayerControllerChanged(APlayerController* NewPlayerController);
```

### `UWorldSubsystem`

```cpp
virtual void Initialize(FSubsystemCollectionBase& Collection) override;
virtual void Deinitialize() override;

// World 초기화 완료 후 호출 (BeginPlay 이전)
virtual void OnWorldBeginPlay(UWorld& InWorld);

// World Component 업데이트 시 호출
virtual void UpdateStreamingState();

virtual bool ShouldCreateSubsystem(UObject* Outer) const override;
```

### Dependency 선언 — `Collection.InitializeDependency<T>()`

특정 Subsystem이 먼저 초기화되어야 할 때 사용한다.

```cpp
void UMyWorldSubsystem::Initialize(FSubsystemCollectionBase& Collection)
{
    // UOtherWorldSubsystem이 먼저 Initialize되도록 보장
    Collection.InitializeDependency<UOtherWorldSubsystem>();

    Super::Initialize(Collection);
}
```

---

## Level Transition 시 동작 차이

| Type          | Seamless Travel | Non-Seamless Travel | 비고                                        |
| :------------ | :-------------- | :------------------ | :----------------------------------------- |
| Engine        | 유지             | 유지                 | Level 전환과 무관                            |
| Editor        | 유지             | 유지                 | Editor 종료 전까지 유지                       |
| Game Instance | 유지             | 유지                 | Level 전환 데이터 보존에 적합                  |
| Local Player  | 유지             | 유지                 | `ULocalPlayer`는 Level 전환에도 유지됨        |
| World         | **재생성**        | **재생성**           | Level 전환 시 이전 World 소멸 → 새 인스턴스 생성 |

> `UWorldSubsystem`은 Level 전환마다 `Deinitialize → Initialize` 사이클이 반복된다.  
> Level 간 데이터를 유지해야 한다면 `UGameInstanceSubsystem`을 사용해야 한다.
{: .prompt-tip}

---

## Multiplayer 시 `ULocalPlayerSubsystem` 주의사항

- `ULocalPlayerSubsystem`은 **Local Client** 기준의 Subsystem이다.
- **Dedicated Server**에는 `ULocalPlayer`가 없으므로 인스턴스가 생성되지 않는다.
- **Split Screen** 환경에서는 플레이어 수만큼 인스턴스가 생성된다.

```cpp
// 특정 PlayerController에서 자신의 LocalPlayerSubsystem 접근
APlayerController* PC = GetWorld()->GetFirstPlayerController();
if (ULocalPlayer* LP = PC ? PC->GetLocalPlayer() : nullptr)
{
    if (UMyLocalPlayerSubsystem* Sub = LP->GetSubsystem<UMyLocalPlayerSubsystem>())
    {
        // 사용
    }
}
```

> **Server 전용 로직**을 `ULocalPlayerSubsystem`에 넣지 않도록 주의.  
> Server 로직은 `UGameInstanceSubsystem` 또는 `UWorldSubsystem`을 사용한다.
{: .prompt-danger}


## References

- <https://dev.epicgames.com/documentation/ko-kr/unreal-engine/programming-subsystems-in-unreal-engine?application_version=5.7>
