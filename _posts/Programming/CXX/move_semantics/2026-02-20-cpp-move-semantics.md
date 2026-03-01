---
title: "[Programming/C++] Rvalue Reference, Perfect Forwarding"
description: >-
  C++ rvalue 참조가 어떻게 이동 시맨틱스와 완벽한 포워딩을 구현하는지 살펴보자. lvalue와 rvalue의 범주 차이, std::move와 std::forward를 언제 사용해야 하는지, 그리고 유니버설 참조가 템플릿 코드에서 불필요한 복사를 어떻게 제거하는지 이해해 보자.
author: seongcheol
date: 2026-02-20 12:05:00 +0900
categories: [Programming, C++]
tags: [C++, Rvalue Reference, Perfect Forwarding, Performance Optimization, Reference Collapsing Rule]
pin: true
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

### 왜 wrapper 안에서 rvalue가 사라질까?

```cpp
#include <iostream>
#include <utility>

using namespace std;


template<typename T>
void wrapper(T x)
{
    func(x);
}

class Foo {};

void func(Foo& val)
{
    cout << "lvalue reference" << endl;
}

void func(const Foo& val)
{
    cout << "const lvalue reference" << endl;
}

void func(Foo&& val)
{
    cout << "rvalue reference" << endl;
}


int main()
{
    Foo foo;
    const Foo const_foo;

    cout << "-------------------- original --------------------" << endl;
    func(foo);
    func(const_foo);
    func(Foo());

    cout << "-------------------- wrapper --------------------" << endl;
    wrapper(foo);
    wrapper(const_foo);
    wrapper(Foo());

    return 0;
}
```

실행결과는 다음과 같다.
: ```output
-------------------- original --------------------
lvalue reference
const lvalue reference
rvalue reference
-------------------- wrapper --------------------
lvalue reference
lvalue reference
lvalue reference
```

`original`의 경우, 예상대로 `lvalue`, `const lvalue`, `rvalue`가 각각 호출되었다.   
 그런데 `wrapper` 함수를 통해 `func`함수를 호출했을 때는 모두 `lvalue` 레펀런스를 받는 `func(Foo& val)` 함수가 호출되었다.

 이러한 일이 발생한 이유는, **C++ 컴파일러가 템플릿 타입을 추론할 때, 템프릿 인자 `T`가 `레퍼런스`가 아닌 <span class="hl-blue">일반적인 타입</span>이라면 `const`를 무시하기 때문이다.

```cpp
template<typename T>
void wrapper(T x) // x는 이름 있는 지역 변수
{
    func(x); // x는 항상 lvalue
}
```

- `wrapper(foo)` -> lvalue reference
: ```cpp
wrapper(foo); // T = Foo, x는 foo의 복사본
func(x);      // x는 이름 있는 변수 -> lvalue
```

- `wrapper(Foo())` -> lvalue reference
: ```cpp
wrapper(Foo()); // T = Foo, rvalue로 x를 초기화
func(x);        // 하지만 x라는 이름이 생긴 순간 -> lvalue
```

- `wrapper(const_foo)` -> lvalue reference (const 제거)
: ```cpp
void wrapper(T x) // by-value
```

`by-value 템플릿`은 top-level `const`를 제거한다.

| 전달 인자     | T 추론 결과 | x의 타입 |
| ----------- | --------- | ------- |
| `const Foo` | `Foo`     | `Foo`   |

`by-value`는 `복사본`을 만든다. 본사본은 원본과 **독립적**이므로, 원본의 `const`가 복사본을 구속할 이유가 없다.

```cpp
const Foo const_foo;
Foo x = const_foo;   // 복사본은 const가 아님!
x = Foo();           // 복사본은 수정 가능!
```

따라서 `func(x)` 호출 시
: 1. x의 타입 = `Foo` (const 아님)
2. 이름 있음 -> lvalue
3. `func(Foo&)` 호출

그렇다면 다음의 같은 경우는 어떻게 될까?

```cpp
template<typename T>
void wrapper(T& x)
{
    func(x);
}
```

`wrapper(Foo())` 호출로 인하여 <span class="hl-red">Error</span>가 발생할 것이다.   
그 이유는, `Foo()` 자체는 `const` 속성이 없으므로 템플릿 인자 추론에서 `T`가 `class Foo`로 추론된다. 하지만, `Foo&`는 `rvalue reference`가 될 수 없으므로 `컴파일 오류`가 발생하는 것이다.

그러면, 다음과 같이 `const A&`와 `A&` 각각을 만들어주는 방법이 있다.

```cpp
#include <iostream>
#include <utility>

using namespace std;


template<typename T>
void wrapper(T& x)
{
    cout << "[[ T&로 추론됨 ]]" << endl;
    func(x);
}

template<typename T>
void wrapper(const T& x)
{
    cout<< "[[ const T&로 추론됨 ]]" << endl;
    func(x);
}

class Foo {};

void func(Foo& val)
{
    cout << "lvalue reference" << endl;
}

void func(const Foo& val)
{
    cout << "const lvalue reference" << endl;
}

void func(Foo&& val)
{
    cout << "rvalue reference" << endl;
}


int main()
{
    Foo foo;
    const Foo const_foo;

    cout << "-------------------- original --------------------" << endl;
    func(foo);
    func(const_foo);
    func(Foo());

    cout << "-------------------- wrapper --------------------" << endl;
    wrapper(foo);
    wrapper(const_foo);
    wrapper(Foo());

    return 0;
}
```

결과는 다음과 같다.

```output
-------------------- original --------------------
lvalue reference
const lvalue reference
rvalue reference
-------------------- wrapper --------------------
[[ T&로 추론됨 ]]
lvalue reference
[[ const T&로 추론됨 ]]
const lvalue reference
[[ const T&로 추론됨 ]]
const lvalue reference
```

`foo`와 `const_foo`의 경우, 각각 `T&`와 `const T&`로 추론되어서 올바른 함수를 호출하고 있음을 알 수 있다.   
반면, `Foo()`의 경우 `const T&`로 추론되면서 `func(const Foo&)` 함수를 호출하게 된다.

`wrapper`안에 `x`가 `lvalue`라는 사실은 변하지 않고, 이에 언제나 `lvalue reference`를 받는 함수들이 <span class="hl-yellow">Overloading</span>된다.

뿐만 아니라 다음과 같은 문제가 있다. 예를 들어, `func`가 인자를 1개가 아니라 2개를 받는다고 가정해보자. 그렇면 다음과 같은 **모든 조합**의 템플릿 함수들을 **정의**해야 한다.

```cpp
template<typename T>
void wrapper(T& x, T& y)
{
    func(x, y);
}

template<typename T>
void wrapper(const T& x, T& y)
{
    func(x, y);
}

template<typename T>
void wrapper(T& x, const T& y)
{
    func(x, y);
}

template<typename T>
void wrapper(const T& x, const T& y)
{
    func(x, y);
}
```

이렇게 하는 것은 정말 불필요하고 귀찮은 일이다...🤮   
위와 같이 코딩해야 하는 이유는? 단순히 일반적인 레퍼런스가 `rvalue`를 받을 수 없기 때문이다. 그렇다고 해서 디폴트로 상수 레퍼런스만 받게 된다면, 상수가 아닌 레퍼런스도 상수 레퍼런스로 캐스팅되는 어처구니없는 상황이 일어난다.

`C++ 11`에서는 이것을 간단하게 해결할 수 있다. 그것은 `Universal Reference`를 이용하는 것이다.

### 보편적 레퍼런스 (Universal Reference)

```cpp
#include <iostream>
#include <utility>

using std::cout;
using std::endl;
using std::string;


template<typename T>
void wrapper(T&& x)
{
    func(std::forward<T>(x));
}

class Foo {};

void func(Foo& val)
{
    cout << "lvalue reference" << endl;
}

void func(const Foo& val)
{
    cout << "const lvalue reference" << endl;
}

void func(Foo&& val)
{
    cout << "rvalue reference" << endl;
}


int main()
{
    Foo foo;
    const Foo const_foo;

    cout << "-------------------- original --------------------" << endl;
    func(foo);
    func(const_foo);
    func(Foo());

    cout << "-------------------- wrapper --------------------" << endl;
    wrapper(foo);
    wrapper(const_foo);
    wrapper(Foo());

    return 0;
}
```

```output
-------------------- original --------------------
lvalue reference
const lvalue reference
rvalue reference
-------------------- wrapper --------------------
lvalue reference
const lvalue reference
rvalue reference
```

결과는 위와 같다. 잘 작동하는 것을 볼 수 있다.


```cpp
template<typename T>
void wrapper(T&& x)
{
    func(std::forward<T>(x));
}
```

`wrapper`함수는 인자로 `T&&`를 받고 있다. 이렇게, 템플릿 인자 `T`에 대해 `rvalue reference`를 받는 형태를 <span class="hl-blue">보편적 레퍼런스 (Universal Reference)</span>라고 한다.   

`보편적 레퍼런스`는 `rvalue reference`와 다르다. 다음과 같은 코드를 살펴보자.

```cpp
void PrintValue(int&& x)
{
    cout<<"rvalue reference: "<<x<<endl;
}

int main()
{
    PrintValue(5);

    int x = 5;
    PrintValue(x);

    return 0;
}
```

```output
error: cannot bind rvalue reference of type 'int&&' to lvalue of type 'int'
      PrintValue(x);
|                ^
```

이렇게 하면, <span class="hl-red">Compile Error</span>가 발생할 것이다. 위의 함수처럼 `int&&` 형태의 함수는 ***rvalue만을 인자로 받을 수 있다.***

```cpp
template <typename T>
void wrapper(T&& x) { };
```

하지만 위와 같은 **템플릿 타입의 `rvalue reference`는 다르다.** 이 `보편적 레퍼런스`는 `rvalue`뿐만이 아니라 `lvalue` 역시 받을 수 있다.    
그렇다면 `lvalue`가 왔을 때 `T`의 타입은 어떻게 해석될까?

> C++에서는 `레퍼런스 겹침 규칙 (Reference Collapsing Rule)`에 따라 `T`의 타입을 추론한다.
{: .prompt-tip}

```cpp
using T = int&
T& x1;    // int& &; x1 -> int&
T&& x2;   // int& &&; x2 -> int&

using U = int&&
U& x3;    // int&& &; x3 -> int&
U&& x4;   // int&& &&; x4 -> int&&
```

그렇다면 다음은...
```cpp
wrapper(foo);
wrapper(const_foo);
```

위의 2가지 호출의 경우 `T`가 각각 `Foo&`와 `const Foo&`로 추론될 것이다.
```cpp
wrapper(Foo());
```

위의 경우에는 `T`가 단순히 `Foo`로 추론된다.

그런데 의문이 생기는 부분이 있다. 그것은 다음과 같다.
```cpp
func(x);
```

어째서 이렇게 하지 않았을까? 그것은 위에서 설명했듯이 `x`는 `lvalue`이기 때문이다. 따라서 `int&&`를 오버로딩하는 `func`를 호출하려 하였으나 실제로는 `const int&`를 오버로딩하는 `func`가 호출되게 된다.   
그러므로 이 경우 `move`를 통해 `x`를 다시 `rvalue`로 변환해야 한다.

그러나 아무때나 아무곳이나 `move`를 사용하면 안된다!! 인자로 받은 `x`가 `rvalue reference`일 때에만 `move`를 사용해야 한다. 만약 `lvalue reference`일 때, `move`를 적용한다면 `lvalue`에 오버로딩 되는 `func`가 아닌 `rvalue`에 오버로딩 되는 `func`가 호출된다.

```cpp
func(std::forward<T>(x));
```

이러한 문제를 해결해주는 것이 `forward` 함수이다. 이 함수는 `x`가 `rvalue reference`일 때만 `move`를 적용한 것처럼 작동한다. 

`std::forward` 정의를 다시 한번 살펴보자.

```cpp
template <class T>
T&& forward(typename std::remove_reference<T>::type& a) noexcept
{
    return static_cast<T&&>(a);
}
```
`std_remove_reference`
: 타입의 `reference`를 제거하는 `템플릿 메타 함수`이다.

위와 같이 정의되어 있는데, `T`가 `Foo&`라면,
```cpp
Foo&&& forward(typename std::remove_reference<Foo&>::type& a) noexcept
{
    return static_cast<Foo&&&>(a);
}
```

이렇게 되어, `레퍼런스 겹침 규칙`에 따라 다음과 같이 된다.

```cpp
Foo& forward(Foo& a) noexcept
{
    return static_cast<Foo&>(a);
}
```

`T`가 `Foo`라면, 다음과 같이 된다.

```cpp
Foo&& forward(Foo& a) noexcept
{
    return static_cast<Foo&&>(a);
}
```

위와 같이 `rvalue`로 `casting` 해 준다. 고로 성공적으로 인자를 전달하는 것이다.

---

## 👏🏻 요약

- `std::move`는 `캐스팅`이고, 실제 이동 비용은 `0`이다. 이동의 실질적 작업은 **`move constructor / assignment`**가 담당하며, 그 효율은 타입이 어떻게 구현되어 있는지에 달려 있다.
- `T&&` -> Forwarding Reference: lvalue/rvalue 모두 수용, `T`에 `category` 보존.
- `Reference Collapsing`: `&&`끼리 만날 때만 `&&`, 나머지는 `&`
- `std::forward<T>`: `T`에 담긴 `category` 정보를 `static_cast`로 복원.


## 🔗 References

- [UE5.7 - Forward](https://dev.epicgames.com/documentation/en-us/unreal-engine/API/Runtime/Core/Forward?application_version=5.7)
- [Cpp Reference - std::forward](https://en.cppreference.com/w/cpp/utility/forward.html)
- [Stack Overflow](https://stackoverflow.com/questions/13725747/what-are-the-reference-collapsing-rules-and-how-are-they-utilized-by-the-c-st)
