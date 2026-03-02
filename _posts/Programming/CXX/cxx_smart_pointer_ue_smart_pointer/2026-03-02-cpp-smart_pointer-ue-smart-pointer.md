---
title: "[Programming/C++] C++ Smart Pointer와 Unreal Smart Pointer"
description: >-
  C++ 표준 스마트 포인터와 언리얼 엔진 전용 스마트 포인터의 구조와 사용 목적 차이
author: seongcheol
date: 2026-03-02 19:00:00 +0900
categories: [Programming, C++]
tags: [C++, Smart Pointer, Unreal Engine]
pin: true
image:
  path: /assets/img/common/title/cpp_title.jpg
---

## C++ Smart Pointer

- __Smart Pointer__
  - `C++11` 부터 사용 가능한 **조금 더 안전한** 포인터
  - 메모리 할당을 받을 때, **소유권에 대한 정보**가 있다.
  - 명시적인 `delete` 구문이 필요없다.
  - `std::unique_ptr<>`
    - 해당 메모리 블록을 단독으로 소유
  - `std::shared_ptr<>`
    - 해당 메모리 블록의 소유권을 공유
  - `std::weak_ptr<>`
    - 해당 메모리 소유권은 없지만 접근은 가능

### 어떻게 더 안전한가?

`unique_ptr<>`을 사용하는 경우, 소유권을 가진 인스턴스가 스코프 밖으로 벗어났을 때 메모리를 자동으로 해제한다.

```cpp
{
  std::unique_ptr<int> = a = std::make_unique();
  int * b = a.get();
  	
  // ...
}
```

`unique_ptr<>`을 사용하는 경우, 소유권을 가진 인스턴스가 일반적인 방법으로 다른 쪽에 소유권을 이전하려는 경우 에러를 발생한다.

```cpp
std::unique_ptr<int> a = std::make_unique();
std::unique_ptr<int> b = a; // error 발생
```

그러면 다른 쪽에 소유권을 이전할 때는 어떻게 해야할까? `std::move()` 함수를 사용하면 된다.

`std::move()` 함수를 사용하면 명시적으로 소유권 이전이 가능하다. 대신 이전에 소유권을 가진 인스턴스는 `nullptr`을 갖게 된다.

```cpp
{
  std::unique_ptr<int> a = std::make_unique();
  std::unique_ptr<int> b = std::move(a);
    
  // a는 nullptr가 되어서 더 이상 사용 불가능
}
```

### Shared Pointer

`공동 소유권`의 개념을 지니고 있는 포인터이다.

다음의 예시를 보자.

```cpp
#include <memory>
#include <iostream>

int main()
{
  std::shared_ptr<int> p1 = std::make_shared<int>(55);

  {
    std::shared_ptr<int> p2 = p1;
    std::shared_ptr<int> p3 = p2;
    std::cout << "in scope: " << p1.use_count() << std::endl;
  }

  std::cout << "out scope: " << p1.use_count() << std::endl;

  return 0;
}
```

결과는 다음과 같다.

```output
in scope: 3
out scope: 1
```
{: .nolineno }

결과에서 보다시피 스코프안에서의 `Reference Count`는 `3`이다. 그러나 스코프를 빠져나가는 순간, 2개의 소유권이 사라진다. 따라서 스코프 밖에서는 `p1`만 해당 메모리 공간을 소유하고 있으므로 `1`이 나오고 있다.

---

## [Unreal Smart Pointer](https://dev.epicgames.com/documentation/ko-kr/unreal-engine/smart-pointers-in-unreal-engine?application_version=5.4)

**언리얼 스마트 포인터 라이브러리(Unreal Smart Pointer Library)** 는 메모리 할당과 추적의 부담을 해소해주도록 설계된 `C++11` 스마트 포인트들의 커스텀 구현이다.

> 언리얼 오브젝트는 게임 코드에 더 최적화된 별도의 메모리 추적 시스템을 사용하기 때문에 이러한 클래스들은 `UObject` 시스템과 사용할 수 없다.

### 스마트 포인터 타입

스마트 포인터들은 갖고 있거나 참조하는 오브젝트의 생명 주기에 영향을 줄 수 있으며, 다른 스마트 포인터마다 오브젝트에 주는 제한사항과 효과도 달라진다. 각 스마트 포인터 타입을 사용하기 적합한 경우를 알아보자.

#### [Shared Pointers (TSharedPtr)](https://dev.epicgames.com/documentation/ko-kr/unreal-engine/shared-pointers-in-unreal-engine?application_version=5.4)

`shared point`는 참조하는 오브젝트를 소유하며, 무기한으로 오브젝트의 소멸을 방지하고, 참조하는 `shared pointer`또는 `shared reference`가 없을 경우에는, 궁극적으로 오브젝트를 소멸시킨다.
`shared pointer`는 어느 오브젝트도 참조하지 않는 빈 상태일 수 있다. 한편, 모든 `null`이 불가능한 `shared pointer`를 참조하는 오브젝트에 `shared reference`를 생성할 수 있다.

#### [Shared References (TSharedRef)](https://dev.epicgames.com/documentation/ko-kr/unreal-engine/shared-references-in-unreal-engine?application_version=5.4)

`shared reference`는 참조하는 오브젝트를 소유한다는 측면에서 `shared pointer`와 같은 역할을 한다. 단, `null` 오브젝트 관련해서는 **차이점** 이 있다.

* `shared reference`는 항상 ***`null`이 불가능한 오브젝트를 참조해야 한다.*** 
* `shared pointer`는 그런 제약이 없기 때문에 `shared reference`는 언제나 `shared pointer`로 변환될 수 있으며, 변환된 `shred pointer`는 유효한 오브젝트를 참조한다는 점이 보장된다.

참조한 오브젝트가 `null`이 불가능한 오브젝트라는 것을 보장하길 원하거나 공유된 오브젝트 소유권을 보여주길 원할 경우에는 `shared reference`를 사용하자.

#### [Weak Pointers (TWeakPtr)](https://dev.epicgames.com/documentation/ko-kr/unreal-engine/weak-pointers-in-unreal-engine?application_version=5.4)

`weak pointer`는 `shared pointer`와 비슷하지만 참조하는 오브젝트를 소유하지 않기 때문에 생명 주기에 영향을 주기 않는다. 이러한 속성은 참조 주기에 영향을 주지 않기 때문에 매우 유용할 수 있다.
그러나 다시 말해 `weak pointer`는 언제든지 사전 경고 없이 `null`이 될 수 있다는 뜻이기도 하다.🫢
따라서, `weak pointer`는 참조하는 오브젝트에 `shared pointer`를 생성할 수 있고, 프로그래머들에게 일시적으로 오브젝트에 대한 안전한 접근을 보장한다.

#### Unique Pointers (TUniquePtr)

`unique pointer`는 참조하는 오브젝트를 유일하고 명시적으로 소유한다. 특정 자원에 대해서는 하나의 `unique pointer`만 있을 수 있기 때문에, `unique pointer`는 소유권을 이전할 수 있지만 공유는 할 수 없다.
`unique pointer`를 복사하려 하면 컴파일 오류가 발생한다. 또한, `unique pointer`가 스코프(Scope)를 벗어나게 되며, 참조하는 오브젝트가 자동 소멸된다.

> `unique pointer`가 참조하는 오브젝트에 `shared pointer` 또는 `shared reference`를 생성하면 위험하다.
> 
> 다른 스마트 포인터들이 오브젝트를 여전히 참조하고 있음에도 불구하고, `unique pointer`가 소멸되면 해당 오브젝트도 함께 소멸시키는 것을 막을 수 없다. 마찬가지로, `shared pointer` 또는 `shared reference`가 가리키는 오브젝트에 `unique pointer`를 생성하지 않는 것을 권장한다.
{: .prompt-danger }

### 스마트 포인터의 이점

|이점|설명|
|:---|:---|
|메모리 누수 방지|스마트 포인터들은(weak pointer 제외) 더 이상 공유된 레퍼런스가 없으면 오브젝트가 자동 소멸된다.|
|Weak Referencing|weak pointer는 참조 주기에 영향을 주지 않고, 삭제된 오브젝트를 참조하는(dangling) 포인터를 방지한다.|
|선택적인 스레드 안전|언리얼 스마트 포인터 라이브러리에는 멀티스레드에 걸쳐 참조 카운팅을 관리하는 코드인 스레드 세이프(thread-safe) 코드가 포함되어 있다. 스레드 안정성이 필요하지 않다면 그 대신에 향상된 퍼포먼스를 구현할 수 있다.|
|런타임 안전성|shared reference는 절대 null 일 수 없으며 언제든지 참조 해제될 수 있다.|
|명확한 의도|관찰자 중에서 오브젝트의 소유자를 쉽게 분별할 수 있다.|
|메모리|스마트 포인터는 64비트의 C++ 포인터 크기의 두 배이다 (공유된 16바이트의 레퍼런스 컨트롤러도 포함). 단, 예외로 unique pointer만 C++ 포인터의 크기와 같다.|

### 헬퍼 클래스와 함수

언리얼 스마트 포인터 라이브러리는 스마트 포인터를 보다 쉽고 직관적으로 사용할 수 있도록 다양한 헬퍼 클래스와 함수를 제공한다.

|헬퍼|설명|
|:---|:---|
|클래스||
|TSharedFromThis|TSharedFromThis 에서 클래스를 파생시키면 AsShared 혹은 SharedThis 함수가 추가된다. 이러한 함수들을 통해 오브젝트에 대한 TSharedRef 를 구할 수 있다.|
|함수||
|MakeShared 및 MakeShareable|일반 C++ 포인터로 shared pointer를 생성한다. MakeShared 는 새 오브젝트 인스턴스와 레퍼런스 컨트롤러를 한 메모리 블록에 할당하지만, 오브젝트가 public 생성자를 제공해야만 한다. MakeShareable 는 덜 효율적이지만 오브젝트의 생성자가 private이더라도 접근 가능하여 직접 생성하지 않은 오브젝트에 대한 소유권을 가질 수 있고, 오브젝트를 소멸시킬 경우에는 커스텀 비헤이비어가 지원된다.|
|StaticCastSharedRef 및 StaticCastSharedPtr|정적인 형변환 유틸리티 함수로, 주로 파생된 타입으로 내림변환(downcast)하는 데 사용된다.|
|ConstCastSharedRef 및 ConstCastSharedPtr|const 스마트 레퍼런스 또는 스마트 포인터를 mutable 스마트 레퍼런스 또는 스마트 포인터로 각각 변환한다.|

### 스마트 포인터 구현 세부사항

언리얼 스마트 포인터 라이브러리의 모든 스마트 포인터는 기능성 및 효율성 측면에서 일반적인 특징을 공유한다.

### 속도

스마트 포인터를 사용할 지 고려할 때는 항상 퍼포먼스에 대해서 생각해야 한다. 스마트 포인터는 특정 하이레벨 시스템이나 자원 관리 또는 툴 프로그램에 매우 적합하지만 일부 스마트 포인터 타입은 C++ 기본 포인터보다 더 느리며, 이런 오버헤드로 인해 렌더링과 같은 로우 레벨 엔진 코드에는 덜 유용하다.

**스마트 포인터의 일반적인 포퍼먼스 이점:**
- 모든 연산이 고정비(constant-time)이다.
- 빌드를 출시할 때, 대부분의 스마트 포인터들을 참조 해제하는 속도가 C++ 기본 포인터만큼 빠르다.
- 스마트 포인터들을 복사해도 절대 메모리가 할당되지 않는다.
- 스레드 세이프(Thread-safe) 스마트 포인터는 잠금 없는(lockless) 구조이다.

스마트 포인터의 퍼포먼스 문제점에는 다음이 포함되어 있다.
- 스마트 포인터의 생성 및 복사는 C++ 기본 포인터의 생성 및 복사보다 더 많은 오버헤드가 발생한다.
- 참조 카운트를 유지하면 기본 연산에 주기가 추가된다.
- 일부 스마트 포인터는 C++ 기본 포인터보다 메모리 사용량이 더 높다.
- 레퍼런스 컨트롤러에는 두 번의 힙 할당향이 있다. MakeShareable 대신에 MakeShared 를 사용하면 두 번째 할당을 피할 수 있으며, 포퍼먼스를 개선할 수 있다.

### 침범형 접근자 (Intrusive Accessors)

`shared pointer`는 비침범형(non-intrusive)으로, 오브젝트가 스마트 포인터의 소유 하에 있는지 할 수 없다는 뜻이다. 이런 속성을 일반적으로 문제가 없지만, 오브젝트를 `shared reference` 또는 `shared pointer`로서 접근하려는 경우가 있을 수도 있다. 
이러한 경우에는, 오브젝트의 클래스를 템플릿 매개변수로 사용하여 `TSharedFromThis`에서 오브젝트의 클래스를 파생시켜야 한다. `TSharedFromThis`는 두 가지 함수 `AsShared` 및 `SharedThis`를 제공하며, 두 함수로 오브젝트를 `shared reference`로 변환하고, `shared reference`를 또 `shared pointer`로 변환할 수 있다. 
이는 항상 `shared reference`를 반환하는 클래스 팩토리나 `shared reference` 또는 `shared pointer`를 요구하는 시스템에 오브젝트를 넣을 때 특히나 유용하다.
`AsShared`는 호출되는 오브젝트의 부모 타입일 수 있는 `TSharedFromThis`에 템플릿 argument로서 전달된 본래 타입의 클래스를 반환하는 동시에 `SharedThis`는 `this`에서 타입을 직접 파생시키고 해당 타입의 오브젝트를 참조하는 스마트 포인터를 반환한다. 

다음은 두 함수의 사용 방법을 보여주는 예제 코드이다.

```cpp
class FRegistryObject;
class FMyBaseClass: public TSharedFromThis<FMyBaseClass>
{
	virtual void RegisterAsBaseClass(FRegistryObject* RegistryObject)
    {
    	// 'this'의 shared reference에 접근한다.
        // <TSharedFromThis> 로부터 직접 상속되어 AsSahred()와 SharedThis(this)는 동일한 타입을 반환한다.
        TSharedRef<FMyBaseClass> ThisAsSharedRef = AsShared();
        // RegistryObject는 TSharedRef<FMyBaseClass> 또는 TSharedPtr<FMyBaseClass>를 요구한다. TSharedRef는 묵시적으로 TSharedPtr로 변환될 수 있다.
        RegistryObject->Register(ThisAsSharedRef);
    }
};

class FMyDerivedClass : public FMyBaseClass
{
	virtual void Register(FRegistryObject* RegistryObject) override
    {
    	// TSharedFromThis<>로 부터 직접 상속되지 않아서 AsShared()와 SharedThis(this)는 각기 다른 타입을 반환한다.
        // AsShared()는 해당 예제 내 TSharedFromThis<> - TSharedRef<FMyBaseClass>에서 정의된 본래 타입을 반환하게 된다.
        // SharedThis(this)는 해당 예제 내 'this' - TSharedRef(FMyDerivedClass>의 타입과 함께 TSharedRef를 반환하게 된다.
        // SharedThis() 함수는 'this' 포인터와 동일한 범위 내에서만 가능하다.
        TSharedRef<FMyDerivedClass> AsSharedRef = SharedThis(this);
        // FMyDerivedClass는 FMyBaseClass 타입의 일종이기 때문에 RegistryObject가 TSharedRef<FMyDerivedClass>를 허용한다.
        RegistryObject->Register(ThisAsSharedRef);
    }
};

class FRegistryObject
{
	// 이 함수는 FMyBaseClass나 그 자녀 클래스에 TSharedRef나 TSharedPtr를 허용한다.
    void Register(TSharedRef<FMyBaseClass>);
};
```

`AsShared`나 `SharedThis`를 생성자로 호출하지 마라. 이때 `shared reference`가 선언되지 않은 상태이기 때문에 충돌이나 assert가 발생하게 된다.

### 형 변환

`shared pointer`와 `shared reference`는 언리얼 스마트 포인터 라이브러리에 포함되어 있는 여러 가지 지원 함수를 통해 형 변환할 수 있다. 올림변환(Up-casting)는 C++ 포인터와 마찬가지로 묵시적이다. 

`ConstCastSharedPtr` 함수로 const cast 연산자를 사용할 수 있으며, `StaticCastSharedPtr`로 static cast (주로 파생된 클래스 포인터로 내림변환(downcast)하기 위해) 연산자를 사용할 수 있다. 
`런타임 타입 정보(RTTI, Run-Type Type Information)`가 없기 때문에 동적 형변환은 지원되지 않는다. 그 대신 다음 코드와 같이 정적 형변환을 사용할 것을 권장한다.

```cpp
// FDragDropOperation가 FAssetDragDropOp이라는 점을 다른 수단을 통해 유효성이 확인되었다고 가정
TSharedPtr<FDragDropOperation> Operation = DragDropEvent.GetOperation();
// StaticCastSharedPtr로 형 변환할 수 있다.
TSharedPtr<FAssetDragDropOp> DragDropOp = StaticCastSharedPtr<FAssetDragDropOp>(Operation);
```

### 스레드 안정성

기본적으로 스마트 포인터는 싱글 스레드가 접근하는 것이 안전하다. 멀티 스레드가 접근해야 한다면 스마트 포인터 클래스의 스레드 세이프 버전을 사용하자.

- `TSharedPtr<T, ESPMode::ThreadSafe>`
- `TSharedRef<T, ESPMode::ThreadSafe>`
- `TWeakPtr<T, ESPMode::ThreadSafe>`
- `TSharedFromThis<T, ESPMode::ThreadSafe>`

이러한 스레드 세이프 버전은 원자적(atomic) 참조 카운팅으로 인해 디폴트보다 다소 느리지만 그 비헤이비어는 일반 C++ 포인터와 같다.

- 읽기와 복사본은 항상 스레드 세이프이다.
- 안전성을 위해 쓰기와 초기화는 반드시 동기화되어야 한다.

> 하나 이상의 스레드가 포인터에 접근하지 않는다는 것이 확실하다면, 스레드 세이프 버전을 사용하지 않음으로써 퍼포먼스를 향상시킬 수 있다.

## 팁 및 제한사항

- 가급적이면 함수에 데이터를 `TSharedRef` 또는 `TSharedPtr` 매개변수로 넣지 않는 것을 권장한다. 이러한 데이터의 해제와 참조 카운팅으로 인해 오버헤드가 발생하게 된다. 그 대안으로, 레퍼런스된 오브젝트를 `const &`로 넣자.
- `shared pointer`를 불완전한 타입/형식으로 미리 선언할 수 있다.
- `shared pointer`는 언리얼 오브젝트 `UObject`와 이로부터 파생된 클래스와 호환되지 않는다. 언리얼 엔진은 `UObject` 관리를 위한 별도의 메모리 관리 시스템이 있으며 ([언리얼 오브젝트 처리](https://dev.epicgames.com/documentation/ko-kr/unreal-engine/unreal-object-handling-in-unreal-engine?application_version=5.4) 문서 참고) 두 시스템은 완전히 다른 시스템이다.
