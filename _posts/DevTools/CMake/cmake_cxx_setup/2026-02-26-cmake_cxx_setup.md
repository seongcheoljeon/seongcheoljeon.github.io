---
title: "[DevTools/CMake] CMake에서 C++ 설정"
description: >-
  Modern CMake 관점에서 권장되는 C++ 버전 관리 방법과 플랫폼별 컴파일러 차이 대응 전략을 간단히 다룬다.
series: "CMake for Beginner"
series_part: 4
author: seongcheol
date: 2026-03-01 00:39:00 +0900
categories: [DevTools, CMake]
tags: [CMake, ]
pin: true
image:
  path: "/assets/img/common/title/cmake_title.jpg"
mermaid: true
---

`CMake`에서 `C++` 표준이나 컴파일 설정을 다루는 `CMake` 명령어들은 소개한다. 

## C++ 관련 설정 명령어

### set_target_properties

타겟의 속성을 설정하는 명령어로, 특정 `C++` 표준을 명시적으로 설정할 때 사용된다.

```cmake
set_target_properties(MyApp PROPERTIES CXX_STANDARD 17)
```

타겟별로 `C++` 표준을 지정하고, 다른 타겟에는 영향을 미치지 않는다. 그리고 명시적으로 `C++17`을 설정하며, 이 타겟은 반드시 해당 표준을 따르게 강제한다.

### target_compile_features

타겟이 **요구하는 C++ 기능**을 설정하는 명령어로, `CMake`가 자동으로 해당 기능을 지원하는 **최소한의 표준**을 설정한다.

```cmake
target_compile_features(MyApp PRIVATE cxx_std_17)
```

`C++` 표준 그 자체보다는, 타겟이 특정 기능을 사용할 수 있도록 `CMake`에 지시한다. 즉, `CMake`가 해당 기능을 사용하기 위한 적절한 **C++ 표준**을 자동으로 설정한다.

### CMAKE_CXX_STANDARD

`CMake` 전체에서 사용되는 **기본 C++ 표준**을 지정한다.모든 타겟에 적용되지만, 타겟별로 따로 설정된 표준이 있으면 그것이 우선된다.

```cmake
set(CMAKE_CXX_STANDARD 17)
```

이 명령어는 프로젝트 전반에 걸쳐 `C++` 표준을 설정하고, 개별 타겟에서 추가적인 설정이 없다면 이를 사용한다.

### CMAKE_CXX_STANDARD_REQUIRED

이 명령어는 특정 `C++` 표준을 강제할지 여부를 설정한다. `ON`으로 설정하면 컴파일러가 명시한 `C++` 표준보다 낮은 버전으로 후퇴할 수 없다.

```cmake
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```

기본적으로 `OFF`이며, 이 경우 컴파일러가 지원하는 낮은 표준으로 후퇴할 수 있다. 이를 `ON`으로 설정하면 후퇴가 불가능해진다.

### CMAKE_CXX_EXTENSIONS

이 명령어는 **GNU 확장 기능**을 사용할 지 여부를 결정한다. 기본적으로 `CMake`는 `g++` 컴파일러에서 확장 기능이 포함된 표준(`-std=gnu++17`)을 사용하지만, 이를 `OFF`로 설정하면 **순수한 C++ 표준**(`-std=c++17`)만 사용한다.

```cmake
set(CMAKE_CXX_EXTENSIONS OFF)
```

`GNU 확장 기능`이 필요한 경우에는 `ON`으로 설정하고, 순수한 표준을 원할 때는 `OFF`로 설정한다.

### target_compile_options

타겟별로 **컴파일러 옵션**을 세부적으로 설정할 수 있다. 이는 `C++` 표준을 지정하는 데도 사용할 수 있으며, 보다 세밀한 플래그를 설정하는 데 유용하다.

```cmake
target_compile_options(MyApp PRIVATE -std=c++17)
```

`C++` 표준뿐만 아니라 최적화 옵션, 경로 제어 등도 함께 설정할 수 있다.

### add_compile_options

이 명령어는 **`전체 프로젝트`**에 대해 컴파일러 옵션을 설정한다. 타겟별 설정이 아니라 전체 프로젝트의 `모든 타겟`에 적용된다.

```cmake
add_compile_options(-Wall -Wextra -std=c++17)
```

타겟이 아니라 ***글로버하게 설정***된다.

### set_property(TARGET ...)

이 명령어는 특정 타겟에 속성(`PROPERTY`)을 설정하는 것으로 이를 통해 컴파일러나 링커의 플래그를 보다 세밀하게 제어할 수 있다.

```cmake
set_property(TARGET MyApp PROPERTY CXX_STANDARD 17)
```

`set_target_properties`와 비슷하지만 더 세부적인 속성까지 제어할 수 있다.

### check_cxx_compiler_flag

이 명령어는 컴파일러가 특정 `C++` 플래그를 지원하는지 여부를 확인한다.

```cmake
check_cxx_compiler_flag("-std=c++17" COMPILER_SUPPORTS_CXX17)
```

특정 플래그에 대한 지원 여부를 확인하고 그 결과를 기반으로 조건부로 `C++` 표준을 설정하는 데 유용하다.

### option

CMake의 `option()` 명령어는 프로젝트 내에서 ***사용자가 선택할 수 있는 설정 옵션*** 을 정의하는 데 사용된다. 이는 주로 프로젝트를 `빌드`할 때 `특정 기능`을 활성화하거나 비활성화할 수 있도록 하는 설정을 제공한다.

기본적인 문법은 다음과 같다.

```cmake
option(<option_name> "설명" <초기값>)
```

- `<option_name>`
  - 옵션의 이름 (대문자와 언더스코어로 많이 작성함)
- `"설명"`
  - 옵션에 대한 설명 (사용자에게 표시될 수 있음)
- `<초기값>`
  - 옵션의 기본 값 (`ON` 또는 `OFF`로 설정 가능)

다음은 `option` 명령어의 예시이다.

```cmake
option(USE_CUSTOM_LIB "Use a custom library instead of the default" OFF)
```

위의 예시에서 `USE_CUSTOM_LIB` 옵션은 기본값이 `OFF`로 설정된다. 사용자가 빌드할 때 이 옵션을 `ON`으로 변경하면, 프로젝트는 이를 반영한 설정을 진행하게 된다.

이 옵션은 `cmake` 명령을 호출할 때 `-D (Define)` 플래그를 사용해 설정할 수 있다.

```zsh
$ cmake -DUSE_CUSTOM_LIB=ON ..
```

이렇게 설정하면 `USE_CUSTOM_LIB` 옵션이 활성화되어, 해당 옵션에 따라 빌드 구성이 변경될 수 있다.

---

## set_target_properties와 target_compile_feature의 동작 방식 차이점

`set_target_properties`와 `target_compile_features`는 C++ 표준을 설정하는 데 사용되지만, 그 동작 방식과 적용 방식에 차이가 있다.

### set_target_properties

```cmake
set_target_properties(MyTarget PROPERTIES CXX_STANDARD 17)
```

이 명령어는 타겟의 속성으로 **C++ 표준을 명시적으로 설정**한다. 이 경우, 타겟의 컴파일러가 `C++17` 표준을 준수하도록 명령하는 것이다. 주로 ***특정 타겟의 속성을 수동으로 설정***하는데 사용된다.

- 장점
  - 단순하게 C++ 표준을 설정하는데 적합하다.
- 단점
  - 표준 준수 여부는 설정되지만, 해당 타겟이 요구하는 **특정 컴파일러 기능**이 있는지는 알 수 없다.

### target_compile_features

```cmake
target_compile_features(MyTarget PRIVATE cxx_std_17)
```

이 명령어는 **타겟이 요구하는 C++ 표준 기능**을 선언하는데 사용된다. `CMake`는 이 명령을 통해 ***타겟이 특정 표준을 준수할 수 있는 컴파일러 기능을 자동으로 설정***한다.
즉, `C++17`에서 제공하는 기능을 컴파일할 수 있도록 필요한 플래그를 컴파일러에 설정한다.

- 장점
  - 이 명령어는 `CMake`가 해당 표준의 **모든 관련 컴파일러 플래그**를 자동으로 추가해 준다. 또한, `CMake`는 타겟이 요구하는 기능에 따라 자동으로 적절한 `C++` 표준을 설정할 수 있다.
- 단점
  - 단순히 `C++` 표준을 설정하는 것보다 조금 더 복잡하지만, **기능 중심**의 설정에 유용하다.
  
### 핵심적인 차이점

- __`set_target_properties`__
  - 특정 타겟에 **C++ 표준을 명시적으로 지정**하는 것이다.
- __`target_comile_features`__
  - 타겟에서 특정 **C++ 기능을 사용하도록 요구**하고, `CMake`는 해당 기능을 활성화할 수 있는 **최소한의 C++ 표준**을 자동으로 선택해 준다.
  
두 명령어 모두 같은 C++ 표준을 설정하는 것으로 보일 수 있지만, `target_compile_features`는 기능 기반으로 설정되어 있으며 `set_target_properties`는 표준을 직접적으로 명시하는 방식이라는 점에서 차이가 있다.

### 사용 예시

- `set_target_properties`
  - 이 타겟은 **반드시 `C++17`을 사용해야 한다** 라는 요구사항이 있을 때 사용
- `target_compile_features`
  - 이 타겟은 **특정 C++17 기능(ex: `std::optional`)을 사용한다** 와 같은 요구사항이 있을 때 사용
  
### 결론

- `C++ 표준 그 자체`를 지정하고 싶다면, `set_target_properties`를 사용한다.
- 특정 기능을 중심으로 C++ 표준을 설정하고, `CMake`가 필요한 표준을 자동으로 설정하게 하려면 `target_compile_features`를 사용한다.

---

## 📒 정리

`C++` 표준과 컴파일 설정을 다루는 명령어들을 정리하면 다음과 같다.

- `set_target_properties`
  - 타겟별로 C++ 표준을 지정
- `target_compile_features`
  - 타겟이 요구하는 C++ 기능을 설정
- `CMAKE_CXX_STANDARD`
  - 기본 C++ 표준 설정
- `CMAKE_CXX_STANDARD_REQUIRED`
  - 설정된 C++ 표준 강제
- `CMAKE_CXX_EXTENSIONS`
  - GNU 확장 기능 사용 여부 설정
- `target_compile_options`
  - 타겟별 컴파일러 옵션 설정
- `add_compile_options`
  - 프로젝트 전체에 적용되는 컴파일러 옵션 설정
- `set_property(TARGET ...)`
  - 타겟 속성을 세부적으로 제어
- `check_cxx_compiler_flag`
  - 컴파일러 플래그 지원 여부 확인

이 명령어들을 활용하여 `C++` 프로젝트에서 컴파일러의 동작과 표준 준수를 더욱 세밀하게 제어할 수 있다.
