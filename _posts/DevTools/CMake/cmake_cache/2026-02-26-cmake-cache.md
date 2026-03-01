---
title: "[DevTools/CMake] Cache의 역할"
description: >-
  CMake의 Cache는 설정(Configure) 단계에서 결정된 변수 값을 저장해 두는 공간이다. 한 번 탐색된 컴파일러 정보, 경로, 옵션 등을 CMakeCache.txt에 보관하여 이후 재구성 시 다시 계산하지 않도록 돕는다.
series: "CMake for Beginner"
series_part: 11
author: seongcheol
date: 2026-03-02 01:10:00 +0900
categories: [DevTools, CMake]
tags: [CMake, ]
pin: true
image:
  path: "/assets/img/common/title/cmake_title.jpg"
mermaid: true
---

CMake의 `캐시(Cache)`는 프로젝트 구성 시 사용되는 중요한 메커니즘으로, 설정된 값들을 저장하고 유지하는 기능을 한다. 

`cache`는 특히 여러 번 빌드해야 하는 큰 프로젝트에서 유용하며, 사용자가 특정 값을 설정하거나 수정할 때 반복적으로 설정하지 않아도 되도록 한다.

## Cache의 역할

- __`값 유지`__
  - CMake를 실행할 때 각종 변수와 설정들이 캐시에 저장된다. 이 값들은 `CMakeCache.txt` 파일에 기록되며, 이후 CMake를 다시 실행하더라도 계속 `유지`된다.
- __`사용자 정의 변수 설정`__
  - GUI나 `ccmake`같은 인터페이스를 통해 캐시에 저장된 변수를 변경할 수 있으며, 이 값들은 강제로 덮어쓰지 않는 한 `CMakeLists.txt` 파일에서 다시 덮어쓰이지 않는다.
- __`빌드 설정 관리`__
  - 프로젝트의 여러 빌드 옵션을 관리하기 위한 유용한 도구로, 빌드 옵션, 경로, 라이브러리 파일 등 다양한 값을 캐시에 저장한다.

## 캐시 파일 위치

`CMake`가 프로젝트 디렉토리에서 실행되면, `CMakeCache.txt` 파일이 생성된다. 이 파일은 프로젝트의 `root` 디렉토리에 위치하며, 캐시에 저장된 변수들의 값이 여기에 기록된다.

`CMake`는 이 파일을 참조하여 이전에 설정된 값을 유지하거나 필요시 사용자가 지정한 값을 덮어쓴다.

### CMakeCache.txt

소스 트리로부터 빌드 트리를 만들면, 빌드 트리에는 `CMakeCache.txt` 라는 파일이 생성된다. 이런 파일이 존재하는 이유는 `CMakeLists.txt` 파일을 수정할 때마다 다시 `CMake`를 통해 빌드 트리를 재구성하는 불필요한 반복 작업을 막기 위함이다.

## 캐시의 특징

- __`Persistent (지속성)`__
  - 캐시에 저장된 변수는 `CMake`를 다시 실행하더라도 유지된다.
- __`Override (덮어쓰기)`__
  - 캐시 변수는 일반적으로 한 번 설정되면 다시 설정되지 않지만, `FORCE` 옵션을 사용하면 이미 캐시에 존재하는 값을 덮어쓸 수 있다.
- __`변수 관리`__
  - 캐시 변수를 명시적으로 설정하거나 사용하지 않으면, `CMake`는 기본값을 사용하거나 값을 자동으로 설정한다.

---

## CMake 캐시 변수 설정

```cmake
set(<variable> <value>... CACHE <type> <docstring> [FORCE])
```

`<type>`은 CMake GUI에 알려 줄 타입 힌트이다. `<type>`으로 들어갈 수 있는 것들을 다음과 같다.

- `BOOL`
  - Boolean ON/OFF 값이다. GUI에서는 체크박스로 제공된다.
- `FILEPATH`
  - 디스크상의 파일 경로이다. GUI에서는 파일 다이얼로그로 제공된다.
- `PATH`
  - 디스크상의 디렉토리 경로이다. GUI에서는 파일 다이얼로그로 제공된다.
- `STRING`
  - 텍스트이다. GUI에서는 텍스트 필드나 드롭다운 선택메뉴로 나온다.
- `INTERNAL`
  - 텍스트이다. GUI에는 보이지 않고 내부 용도로 사용된다. `[FORCE]` 인자와 관련이 있다.
  
`<docstring>`은 캐시 변수에 대한 설명이다.

`[FORCE]` 선택적 인자는 `CMakeLists.txt`를 실행하면서 강제로 캐시 값을 변경하기 위해서 사용한다.

또 다른 하나의 캐시 변수 생성 명령은 `option()` 이다. 이것은 `Boolean` 종류의 캐시 변수를 쉽게 만들기 위한 명령이다. 이것의 시그니처는 다음과 같다.

```cmake
option(<variable> "<help_text>" [value])
```

`<variable>`은 변수명이고, `"<help_text>"`는 변수에 대한 설명이다. 그리고 `[value]`는 `ON`, `OFF` 중 하나의 값이다.

캐시 변수는 일반적으로 `CMakeLists.txt`를 실행하면서 변경하기 위해서 존재하는 것이 아니라, `CMakeCache.txt`에 기록하기 위해서 존재한다. 따라서 ***한 번 등록되면 변경되지 않는다.*** 즉 동일 변수에 대해 여러 번 `set()`을 하거나 `option()`을 해도 **첫 번째 값으로만 설정된다.**

### -D 옵션으로 변경

빌드 트리를 만들 때, `-D` 옵션을 부여함으로써 값을 변경하는 것은 가능하다.

```bash
cmake -S . -B ./build -DVAR="VAR is changed"
cmake --build ./build
```

다음은 `CMake` 캐시에 변수를 설정하는 예이다.

### 기본적인 캐시 변수 설정

```cmake
set(my_option "default_value" CACHE STRING "A custom string option")
```

- 이 코드는 `my_option` 변수를 캐시에 저장하고, 타입을 `STRING`으로 지정하며, 기본값으로 `"default value"`를 설정한다.
- 캐시에 이미 `my_option`이 존재한다면, 기존 값이 `유지`된다.
- 사용자가 `CMakeCache.txt` 파일을 편집하거나 `CMake GUI` 도구에서 값을 수정할 수 있다.

### 캐시 변수에 대한 경로 설정

```cmake
set(library_path "/usr/local/lib" CACHE PATH "path to the library")
```

- `library_path`는 경로 값을 가지고 있으며, `PATH` 타입으로 캐시에 저장된다.
- 이 경로는 이후 다른 경로 설정에 재사용할 수 있으며, 사용자가 환경에 맞게 경로를 수정할 수 있다.

### Boolean 캐시 변수 설정

```cmake
set(enable_feature ON CACHE BOOL "Enable the special feature")
```

- `enable_feature`는 `ON` 또는 `OFF`로 설정 가능한 `BOOL` 타입의 변수이다.
- 이를 통해 사용자가 특정 기능을 활성화(`ON`)하거나 비활성화(`OFF`) 할 수 있다.

### 캐시 변수 덮어쓰기 (FORCE 사용)

```cmake
set(my_option "new_value" CACHE STRING "Override the custom string option FORCE")
```

- `FORCE`를 사용하면, 이미 캐시에 존재하는 값을 강제로 덮어쓸 수 있다.
- 이 방법은 캐시 값을 `변경`하고 싶을 때 유용하다.

### 캐시에서 변수 삭제

캐시에서 변수를 `삭제`하려면 `CMake`의 캐시 파일을 직접 삭제하거나, 다음 명령어를 사용하여 빌드 디렉토리에서 캐시를 초기화할 수 있다.

```bash
rm -rf CMakeCache.txt CMakeFiles/
```

이 명령을 실행하면, `CMakeCache.txt` 파일이 삭제되어 다음 번 `CMake` 실행 시 캐시가 재생성된다.

--- 

## CMake 캐시의 사용

다음은 실제 프로젝트에서 `CMake` 캐시가 어떻게 사용되는지 보여주는 예이다.

```cmake
project(MyProject)

// 설정을 캐시에 저장
set(MY_PROJECT_ROOT_DIR "${CMAKE_SOURCE_DIR}" CACHE PATH "Root directory of the project")

// 옵션을 캐시에 저장
set(BUILD_TESTS ON CACHE BOOL "Build unit tests")

// 특정 라이브러리 경로 캐시에 저장
find_library(MY_LIBRARY libmy_library.so PATHS ${MY_PROJECT_ROOT_DIR}/lib CACHE)

// 테스트 빌드를 활성화한 경우에만 테스트 코드 빌드
if(BUILD_TESTS)
	enable_testing()
    add_subdirectory(tests)
endif()
```

- `MY_PROJECT_ROOT_DIR`에 프로젝트의 루트 경로가 저장된다.
- `BUILD_TESTS`라는 옵션이 `ON`으로 설정되어 있으면, 테스트 코드를 빌드한다.
- `find_library` 함수로 `libmy_library.so` 라이브러리를 찾아서 캐시에 저장한 후 빌드 과정에서 참조할 수 있다.

## 캐시의 유용성

- __`빠른 빌드 설정`__
  - 프로젝트를 여러 환경에서 빌드할 때, `CMake 캐시`를 이용하면 변수 값을 일일이 입력하지 않아도 된다. 
  - 예를 들어, 라이브러리 경로나 빌드 옵션이 자주 바뀌는 프로젝트의 경우 유용하다.
- __`GUI 지원`__
  - `ccmake`나 `CMake GUI`를 사용해 캐시 변수의 값을 손쉽게 수정할 수 있다. 캐시 변수를 통해 빌드 옵션을 관리할 수 있어 사용자 친화적인 설정 환경을 제공한다.

## 캐시 초기화

캐시에 저장된 값이 잘못되거나 다시 설정할 필요가 있을 때는 `CMakeCache.txt` 파일을 직접 삭제하거나, 빌드 디렉토리를 통째로 지운 후 `CMake`를 다시 실행해 초기화할 수 있다.

```bash
rm -rf CMakeCache.txt CMakeFiles/
```

이 방법을 사용하면 캐시에 저장된 설정값들이 모두 `초기화`되고, 다시 처음부터 설정할 수 있다.

---

## 📒 정리

`CMake` 캐시는 프로젝트 구성 및 빌드 환경을 효율적으로 관리하는 데 중요한 역할을 한다. 
설정된 `변수`와 `경로`, `빌드 옵션` 등을 캐시에 저장하여 반복적인 설정 과정을 줄이고, 필요에 따라 값을 쉽게 변경할 수 있다.

`CMakeLists.txt` 파일을 통해 캐시의 상태를 확인하거나 편집할 수 있으며, `GUI` 도구를 통해 쉽게 관리할 수 있는 장점도 있다.
