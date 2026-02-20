---
title: std::move semantics
description: >-
  std::move semantics
author: seongcheol
date: 2026-02-20 12:05:00 +0900
categories: [Programming, C++]
tags: [C++, move]
pin: true
media_subpath: '/assets/img/common'
image:
  path: /title/cpp_title.jpg
---

## std::move

함수 이름이 `move`라서 뭔가... 이동시킬 것 같은 느낌이 든다. 하지만 아니다!

> `std::move`는 실제로 아무것도 이동시키지 않는다.   
> 단지, `lvalue`를 `rvalue reference`로 `Casting`하는 함수다.
{: .prompt-danger }

```cpp
// <utility> 헤더의 실체 구현 (단순화)
template<typename T>
constexpr std::remove_reference_t<T>&& move(T&& t) noexcept
{
  return static_cast<std::remove_reference_t<T>&&>(t);
}
```

> `std::move(x)` == `static_cast<T&&>(x)`
{: .prompt-tip }


C++의 모든 `expression`은 `value category`를 가진다.

| Category| 개념                          | 예시                 |
| :-----  | :--------------------------- | :------------------ |
| lvalue  | 이름이 있는, 주소를 취할 수 있는 것 | `int x = 5;` -> `x` |
| rvalue  | 임시 객체(곧 소멸), 이름 없는 것   | `5`, `foo()` 반환값  |

- `move semantics`의 동기
  - 어차피 소멸될 `rvalue`라면, 복사 대신 자원을 훔쳐오는(steal) 것이 효율적이다.

문제는 이름이 있는 `lvalue`를 __`이제 이거 안 쓸게.`__ 라고 컴파일러에게 알릴 방법이 없었다는 것.
`std::move`는 그 신호를 보내는 수단이다.


## 실제 이동은 누가 하는가?

### Move Constructor / Move Assignment Operator 가 한다.

```cpp
std::vector<int> a {1, 2, 3};

// 복사: 내부 배열을 새로 할당하고 데이터를 복제
std::vector<int> b = a;

// 이동: 내부 포인터만 옮김 (O(1)), a는 비워짐
std::vector<int> c = std::move(a);
// a는 이후 valid하지만 unspecified state
```

`std::move(a)`로 **이동**이 끝난 뒤의 `a`는:
- __유효(valid)__
  - `a`는 "망가진 객체"가 아니라서, __소멸자 호출/대입/clear()/push_back()__ 같은 일반 연산을 __안전하게__ 할 수 있다. 
- __상태가 지정되지 않았다(unspecified state)__
  - 대신 __내용물이 뭐가 남아있는지, 크기가 0인지, capacity가 얼마인지__ 같은 건 __표준이 보장하지 않는다.__ 
  - 구현/상황에 따라 `a`가 비어 보일 수도 있고, 뭔가 남아 보일 수도 있지만 __그것을 믿고 코드를 짜면 안된다.__

그래서 실전 규칙은 한 줄로:
> 이동 된 `a`는 __다시 값을 넣어서 재사용하거나, 명시적으로 비운 뒤__ 쓰고,   
> 이동 직후엔 `a`의 값/size 같은 걸 __가정하지 말자.__
{: .prompt-warning }

```cpp
std::vector<int> c = std::move(a);

// 이동 직후: a.size()가 0일 것이라고 기대하면 안 됨.

// 안전한 사용:
a.clear()
a.push_back(55);
```

---

## Unreal Engine에서의 주요 사용처

```cpp
// TArray, TMap 등 컨테이너 소유권 이전
TArray<FMyData> source = BuildData();
TArray<FMyData> dest = MoveTemp(source); // UE의 std::move 래퍼

// RDG에서 람다 캡쳐 이전
TRefCountPtr<IPooledRenderTarget> rt = ...;
GraphBuilder.AddPass(
  RDG_EVENT_NAME("MyPass"),
  PassParameters,
  ERDGPassFlags::Compute,
  [rt = MoveTemp(rt)](FRHIComputeCommandList& RHICmdList) mutable { ... }
)
```

`UE5`에서는 **`MoveTemp()`**가 **`std::move()`**와 동일하다.

--- 

## ‼️ 핵심 주의사항

### move 후 사용 금지

```cpp
std::string s = "hello";
std::string t = std::move(s);

// s는 valid하지만, 내용은 보장 안됨!
```

### const에는 move가 작동 안 함

```cpp
const std::vector<int> v = {1, 2, 3};
auto w = std::move(v); 

// 실제로는 복사 됨! cosnt T&&는 move ctor에 안 맞음
```

### return 값에 std::move 쓰지 말 것 (NRVO 방해)

```cpp
// 나쁨: NRVO(Named Return Value Optimization)를 억제
std::vector<int> Foo()
{
  std::vector<int> v;
  return std::move(v);
}

// 좋은: 컴파일러가 직접 최적화
std::vector<int> Foo()
{
  std::vector<int> v;
  return v; // NRVO 적용
}
```

## ☝🏻 한 줄 요약

`std::move`는 `캐스팅`이고, 실제 이동 비용은 `0`이다. 이동의 실질적 작업은 **`move constructor / assignment`**가 담당하며, 그 효율은 타입이 어떻게 구현되어 있는지에 달려 있다.
