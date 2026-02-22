---
title: "[Programming/C++] Rvalue Reference, Perfect Forwarding"
description: >-
  C++ rvalue 참조가 어떻게 이동 시맨틱스와 완벽한 포워딩을 구현하는지 살펴보자. lvalue와 rvalue의 범주 차이, std::move와 std::forward를 언제 사용해야 하는지, 그리고 유니버설 참조가 템플릿 코드에서 불필요한 복사를 어떻게 제거하는지 이해해 보자.
author: seongcheol
date: 2026-02-20 12:05:00 +0900
categories: [Programming, C++]
tags: [C++, Rvalue Reference, Perfect Forwarding, Performance Optimization]
pin: true
media_subpath: "/_post/Programming/Cpp"
image:
  path: /assets/img/common/title/cpp_title.jpg
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

> C++11 이후 공식 분류는 `lvalue`/`pvalue`/`xvalue`로 세분화 된다.  
> `std::move(x)`가 만들어내는 것은 엄밀히 `xvalue`(eXpiring value)이며, `rvalue`의 하위 분류다.
> 이 글에서는 이해를 위해 `lvalue`/`rvalue`로 단순화해서 다룬다.
{: .prompt-info }

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

```ue_cpp
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

// 실제로는 복사 됨! const T&&는 move ctor에 안 맞음
```

### return 값에 std::move 쓰지 말 것 (NRVO 방해)

```cpp
// ❌ NRVO(Named Return Value Optimization)를 억제
std::vector<int> Foo()
{
  std::vector<int> v;
  return std::move(v);
}

// ✅ 컴파일러가 직접 최적화
std::vector<int> Foo()
{
  std::vector<int> v;
  return v; // NRVO 적용
}
```

---

## std::forward

### template에서 std::move를 쓰면 안 되는 이유

`std::move`는 항상 `rvalue`로 명시적인 `캐스팅`을 한다. 
`template` 함수에서는 들어온 값이 `lvalue`인지 `rvalue`인지 모르므로, 무조건 `std::move`를 쓰면, 의도치 않게 `lvalue`를 훔쳐가는 **버그**가 생긴다.

```cpp
// ❌ 잘못된 예: lvalue가 들어와도 명시적으로 이동됨
template<typename T>
void Wrap(T&& value)
{
  Foo(std::move(val));
}

// ✅ 올바른 예: std::forward로 원래 vlaue category를 그대로 전달
template<typename T>
void Wrap(T&& val)
{
  Foo(std::forward<T>(val));
}
```

- **lvalue** -> `std::forward`가 `lvalue reference`로 전달.
- **rvalue** -> `std::forward`가 `rvalue reference`로 전달.

> 이 패턴을 **`Perfect Forwarding`**이라 한다.
{: .prompt-tip }


## Perferct Forwarding

### `&&`의 두 가지 얼굴

```cpp
// (A) rvalue reference - rvalue만 받는다.
void Foo(int&& val);

// (B) Forwarding Reference - lvalue도 rvalue도 받는다.
template<typename T>
void Bar(T&& val);
```

```cpp
int x = 5;

Foo(x); // ❌ 컴파일 에러: x는 lvalue
Foo(5); // ✅ ok

Bar(x); // ✅ ok
Bar(5); // ✅ ok
```

`&&`를 쓰는데, `Bar`만 lvalue를 받을 수 있는 이유 -> **타입 추론이 일어나기 때문이다.**

### `T`는 어떻게 추론되는가?

```cpp
template<typename T>
void Bar(T&& val);

int x = 5;
Bar(x);            // lvalue 전달 -> T = int&
Bar(5);            // rvalue 전달 -> T = int
Bar(std::move(x)); // rvalue 전달 -> T = int
```

> 규칙 : `lvalue`를 넘기면 `T`가 `int&`로, `rvalue`를 넘기면 `T`가 `int`로 **추론**된다.   
> 즉, __`T`안에 원래 value category 정보가 담긴다.__
{: .prompt-tip }

### Reference Collapsing

`T = int&` 일 때, 매개변수 타입 `T&&`를 전개하면 `int& &&`가 된다.
C++는 reference가 중첩될 때, 다음과 같은 규칙으로 정리한다.

| 조합      | 결과    |
| :-----   | :----- |
| `T& &`   | `T&`   |
| `T& &&`  | `T&`   |
| `T&& &`  | `T&`   |
| `T&& &&` | `T&&`  |

> **`&& (rvalue)`끼리 만날 때만 `&& (rvalue)`, 나머지는 전부 `& (lvalue)`
{: prompt-tip }

전개해보면:
```cpp
Bar(x);    // T = int& -> T&& = int& && = int&      <- lvalue reference
Bar(5);    // T = int  -> T&& = int&&               <- rvalue reference
```

### 이름이 생기면 lvalue가 된다.

다음의 코드가 핵심적인 문제다.
```cpp
template<typename T>
void Bar(T&& val)
{
  // rvalue로 넘겼어도, val은 이름이 생겼으니 lvalue이다.
  Foo(val); // 항상 lvalue로 전달됨.
}
```

```cpp
Bar(5);

// val의 타입은 int&& (rvalue reference)
// 하지만 val 자체는 이름이 있으므로 lvalue expression
// Foo(val)은 lvalue를 전달
```

원래 `rvalue`였다는 정보가 소실된다.
이것을 복원하는 것이 **`std::forward`**의 역할이다.

### std::forward의 실제 구현

`std::forward`
: `<utility>` 헤더에 정의되어 있다.

```cpp
// (1)
template<typename T>
constexpr T&& forward(std::remove_reference_t<T>& t) noexcept;

// (2)
template<typename T>
constexpr T&& forward(std::remove_reference_t<T>&& t) noexcept;
```

> `(1)` 오버로딩의 경우, `lvalue`를 `T`에 따라 `lvalue` 혹은 `rvalue`로 전달한다.
{: .prompt-tip}


```cpp
template<typename T>
constexpr T&& forward(std::remove_reference_t<T>& val) noexcept
{
  return static_cast<T&&>(val);
}
```

`static_cast<T&&>`에 **Reference Collapsing**을 적용하면:
```cpp
// Bar(x) 호출 -> T = int&
std::forward<int&>(val)
-> static_cast<int& &&>(val)
-> static_cast<int&>(val)     // lvalue reference - 원래대로 lvalue

// Bar(5) 호출 -> T = int
std::forward<int>(val)
-> static_cast<int&&>(val)    // rvalue reference - 원래대로 rvalue 복원
```

**`T`에 담긴 category 정보를 `static_cast`로 꺼내는 구조다.**

### Perfect Forwarding 완성

```cpp
template<typename T>
void Bar(T&& val)             // 1. Forwarding Reference
{
  Foo(std::forward<T>(val));  // 2. T로 원래 category 복원
}
```

```cpp
int x = 5;

Bar(x);            // T = int&  -> forward<int&>  -> Foo에 lvalue로 전달
Bar(5);            // T = int   -> forward<int>   -> Foo에 rvalue로 전달
Bar(std::move(x)); // T = int   -> forward<int>   -> Foo에 rvalue로 전달
```

### __`std::move`__ vs __`std::forward`__ 비교

```cpp
// std::move - 무조건 rvalue로 캐스팅
// 용도: "이 값 이제 안 씀"을 명시할 때
template<typename T>
constexpr std::remove_reference_t<T>&& move(T&& t) noexcept
{
  return static_cast<std::remove_reference_t<T>&&>(t); // 항상 T&&
}

// std::forward - T에 따라 lvalue 또는 rvalue로 캐스팅
// 용도: template에서 원래 category를 보존할 때
template<typename T>
constexpr T&& forward(std::remove_reference_t<T>& val) noexcept
{
  return static_cast<T&&>(val); // T가 int&면 int&, int면 int&&
}
```

```cpp
// ❌ template에서 std::move - lvalue가 들어와도 강제로 rvalue
template<typename T>
void Wrong(T&& val)
{
  Foo(std::move(val)); // x(lvalue)를 넘겨도 훔쳐감(이동됨) - 버그
}

// ✅ template에서 std::forward - 원래 category 그대로
template<typename T>
void Correct(T&& val)
{
  Foo(std::forward<T>(val)); // x면 lvalue로, 5면 rvalue로
}
```


## 👏🏻 요약

- `std::move`는 `캐스팅`이고, 실제 이동 비용은 `0`이다. 이동의 실질적 작업은 **`move constructor / assignment`**가 담당하며, 그 효율은 타입이 어떻게 구현되어 있는지에 달려 있다.
- `T&&` -> Forwarding Reference: lvalue/rvalue 모두 수용, `T`에 `category` 보존.
- `Reference Collapsing`: `&&`끼리 만날 때만 `&&`, 나머지는 `&`
- `std::forward<T>`: `T`에 담긴 `category` 정보를 `static_cast`로 복원.


## Reference Link

- [UE5.7 - Forward](https://dev.epicgames.com/documentation/en-us/unreal-engine/API/Runtime/Core/Forward?application_version=5.7)
- [Cpp Reference - std::forward](https://en.cppreference.com/w/cpp/utility/forward.html)
