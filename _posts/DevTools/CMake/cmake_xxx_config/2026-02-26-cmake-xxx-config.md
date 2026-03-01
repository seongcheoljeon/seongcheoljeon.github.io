---
title: "[DevTools/CMake] xxx-config.cmake"
description: >-
  xxx-config.cmake는 find_package()가 Config Mode로 패키지를 찾을 때 사용하는 설정 파일이다. 라이브러리가 자신의 include 경로와 링크 정보를 직접 제공한다.
series: "CMake for Beginner"
series_part: 14
author: seongcheol
date: 2026-03-02 01:35:00 +0900
categories: [DevTools, CMake]
tags: [CMake, ]
pin: true
image:
  path: "/assets/img/common/title/cmake_title.jpg"
mermaid: true
---

## xxx-config.cmake 파일의 목적

`xxx-config.cmake` 파일은 `라이브러리`나 `패키지`를 `CMake`에서 쉽게 찾을 수 있도록 구성 정보를 제공하는 파일이다. 

이 파일을 사용하면, 다른 프로젝트에서 `find_package(xxx)`를 호출할 때 `xxx` 라이브러리의 위치와 설정 정보를 제공하여 자동으로 링크하고 설정할 수 있다.

> `xxx`는 참고로 특정 라이브러리나 프로젝트의 이름을 의미.
> 예를 들어, 프로젝트 이름이 `foo`라면 `foo-config.cmake` 파일이 된다.

## xxx-config.cmake 파일이 필요한 이유

- **`편리한 라이브러리 사용`**
  - 다른 `CMake` 프로젝트에서 라이브러리를 쉽게 찾고 사용할 수 있도록 도와준다.
- **`설정 정보 제공`**
  - 라이브러리의 경로, 의존성, 빌드된 타겟 등과 같은 설정 정보를 제공한다.
- **`유지보수 용이`**
  - 여러 라이브러리를 사용하는 대규모 프로젝트에서는 각 라이브러리의 설정 정보를 `xxx-config.cmake` 파일로 관리하면 유지보수가 용이하다.

## xxx-config.cmake 파일 작성

다음은 `foo`라는 가상의 라이브러리의 `foo-config.cmake` 파일을 작성하는 예이다.

### 소스 트리 구조

```terminal
foo/
  include/
    foo.h
  lib/
    libfoo.a
  cmake/
    foo-config.cmake
  CMakeLists.txt
```

`foo-config.cmake` 파일은 `cmake` 디렉토리에 위치하게 된다.

### 기본 구조

`foo-config.cmake` 파일은 다음과 같은 기본 구조를 가진다.

```cmake
// foo 라이브러리가 설치된 경로 설정
set(foo_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../include")
set(foo_LIBRARY_DIR "${CMAKE_CURRENT_LIST_DIR}/../lib")

// 타겟을 찾고 설정한다.
include("${CMAKE_CURRENT_LIST_DIR}/foo-targets.cmake")

// include 경로를 사용자에게 제공한다.
include_directories("${foo_INCLUDE_DIR}")
```

### 타겟 설정 파일 작성

`foo-config.cmake` 파일에서 `foo-targets.cmake`를 포함하는데, 이 파일은 라이브러리의 타겟 정보를 정의한다.

```cmake
// foo-targets.cmake

// foo 라이브러리의 타겟을 설정
add_library(foo STATIC IMPORTED)

// foo 라이브러리의 위치 설정
set_target_properties(foo PROPERTIES
	IMPORTED_LOCATION "${foo_LIBRARY_DIR}/libfoo.a"
    INTERFACE_INCLUDE_DIRECTORIES "${foo_INCLUDE_DIR}"
)
```

### 라이브러리 사용

이제 `foo` 라이브러리를 사용하는 다른 `CMake` 프로젝트에서 다음과 같이 `find_package`를 사용하면 된다.

```cmake
// bar/CMakeLists.txt

cmake_minimum_required(VERSION 3.20)
project(my_app)

// foo 라이브러리 찾기
find_package(foo REQUIRED)

// 타겟 설정 및 링크
add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE foo)
```

`find_package(foo REQUIRED)` 명령을 사용하면, `foo-config.cmake` 파일을 찾아서 `foo` 라이브러리의 경로와 설정 정보를 자동으로 가져온다. 이를 통해 `my_app` 프로젝트가 `foo`의 헤더 파일과 라이브러리를 사용할 수 있게 된다.

## 📒 정리

- `xxx-config.cmake` 파일을 작성하여 다른 프로젝트에서 `find_package` 로 쉽게 라이브러리를 찾을 수 있도록 한다.
- `xxx-config.cmake` 파일은 라이브러리의 포함 경로와 타겟 정보를 제공한다.
- `xxx-targets.cmake` 파일을 작성하여 실제 타겟 정보와 라이브러리 위치를 설정한다.
- 다른 `CMake` 프로젝트에서 `find_package`를 사용해 라이브러리를 쉽게 가져와서 사용할 수 있다.

---

## FindXXX.cmake 파일과의 차이점

`FindXXX.cmake`와 `xxx-config.cmake`의 `차이점`은 ***라이브러리 검색 방식***과 ***누가 파일을 작성했는지***에 있다. 

두 가지 방법 모두 `CMake`에서 라이브러리를 찾고 사용하는 데 쓰이지만, `작성 주체`와 `사용 방식`에서 차이가 있다. 아래에서 각각의 개념과 차이점을 설정한다.

## FindXXX.cmake

- **`작성 주체`**
  - 일반적으로 **라이브러리를 사용하는 사람이 작성**한다.
  - 즉, 라이브러리를 제공하는 쪽에서 배포하는 것이 아니라, 라이브러리를 사용하는 프로젝트에서 작성해 포함시킨다.
- **`사용 방법`**
  - `find_pakcage(XXX REQUIRED)` 명령을 호출하면, CMake는 `CMake 모듈 경로(CMAKE_MODULE_PATH)`에서 `FindXXX.cmake` 파일을 찾는다.
- **`파일 위치`**
  - `FindXXX.cmake` 파일은 CMake의 모듈 경로에 있거나, 사용자가 별도로 제공해야 한다.
- **`구조 및 내용`**
  - `FindXXX.cmake` 파일은 라이브러리가 설치된 경로를 검색하고, 라이브러리와 관련된 변수를 수동으로 설정한다.
  - 예를 들어, `XXX_INCLUDE_DIR`과 `XXX_LIBRARY` 변수를 설정한다.

다음은 `FindFoo.cmake`의 예이다.

```cmake
// FindFoo.cmake

// include 경로 검색
find_path(foo_INCLUDE_DIR NAMES foo.h PATHS /usr/local/include /opt/foo/include)

// 라이브러리 파일 경로 검색
find_library(foo_LIBRARY NAMES foo PATHS /usr/local/lib /opt/foo/lib)

// 라이브러리가 발견되지 않으면 에러 발생
if(NOT foo_INCLUDE_DIR OR NOT foo_LIBRARY)
	message(FATAL_ERROR "Could not find foo!")
endif()

// 변수 반환
mark_as_advanced(foo_INCLUDE_DIR foo_LIBRARY)
```

`FindFoo.cmake` 파일을 작성한 후, 다른 프로젝트에서 `find_pakcage(foo REQUIRED)` 를 호출하면, `CMake`는 이 파일을 사용해 `foo`의 경로를 찾는다.

## xxx-config.cmake

- **`작성 주체`**
  - 일반적으로 ***라이브러리를 제공하는 사람이 작성***한다. 
  - 즉, 라이브러리의 개발자가 배포 시, 함께 제공하는 파일이다.
- **`사용 방법`**
  - 라이브러리 설치 시, `xxx-config.cmake` 파일이 함께 제공되며, `find_package(XXX REQUIRED)` 명령을 호출하면 `CMake`는 이 파일을 사용해 라이브러리를 찾는다.
- **`파일 위치`**
  - `xxx-config.cmake` 파일은 라이브러리 설치 경로 안에 포함된다. 
  - 예를 들어, `cmake` 폴더나 `lib/cmake` 폴더에 위치하게 된다.
- **`구조 및 내용`**
  - `xxx-config.cmake` 파일은 주로 라이브러리의 빌드 정보와 타겟 정보(`xxx-targets.cmake`)를 포함한다. 이는 라이브러리와 관련된 CMake 타겟을 가져오고 설정하는 데 사용된다.

다음은 `foo-config.cmake`의 예이다.

```cmake
// foo-config.cmake

set(foo_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/../include")
set(foo_LIBRARY_DIR "${CMAKE_CURRENT_LIST_DIR}/../lib")

include("${CMAKE_CURRENT_LIST_DIR}/foo-targets.cmake")
```

`foo-config.cmake`는 `foo` 라이브러리 설치 시 함께 제공되며, 이를 통해 라이브러리 사용자는 별도의 `FindFoo.cmake`를 작성하지 않고도 `find_pakcage(foo REQUIRED)`를 통해 쉽게 라이브러리를 가져올 수 있다.

## 📒 정리

|항목|FindXXX.cmake|xxx-config.cmake|
|:---:|:---:|:---:|
|작성 주체|라이브러리 사용자|라이브러리 제공자|
|파일 위치|CMake 모듈 경로 또는 사용자가 별도로 제공|라이브러리 설치 시 함께 제공됨|
|구성 정보 제공 방식|변수 설정(XXX_INCLUDE_DIR, XXX_LIBRARY)|타겟 정보 포함(xxx-targets.cmake 포함 가능)|
|사용 용이성|라이브러리 제공자가 파일을 제공하지 않는 경우 유용|라이브러리 제공자가 쉽게 설정 정보를 제공 가능|

### FindXXX.cmake & xxx-config.cmake 사용 시점

- **`FindXXX.cmake`**
  - 사용하려는 라이브러리가 자체적으로 `xxx-config.cmake` 파일을 제공하지 않는 경우나, 오래된 라이브러리, 혹은 직접 경로를 제어하고 싶은 경우에 사용한다.
- **`xxx-config.cmake`**
  - 현대적인 CMake 방식에서는 `xxx-config.cmake`를 선호한다. 
  - 라이브러리의 제공자가 이 파일을 제공하면, 사용자 입장에서 추가적인 `FindXXX.cmake` 파일을 작성할 필요 없이 간편하게 `find_package`를 사용할 수 있다.
  
> `FindXXX.cmake`는 **사용자 정의가 가능하지만 수동 작업이 많고**, `xxx-config.cmake`는 **더 현대적이고 자동화된 방식**이다.
>
> 가능하다면 `xxx-config.cmake`를 사용하는 것이 더 편리하며, 이는 라이브러리 제공자가 직접 라이브러리를 `CMake`와 쉽게 통합할 수 있도록 도와준다.

---

## xxx-config.cmake 자동 생성

라이브러리나 프로젝트를 `CMake`로 빌드하고 설치할 때, `install()` 명령어와 `export()` 명령어를 사용하면 CMake가 `xxx-config.cmake` 파일을 자동으로 생성해준다.

자동으로 `xxx-config.cmake` 파일을 생성하는 예는 다음과 같다.

자동 생성의 핵심은 `install(EXPORT ...)`와 `export(TARGETS ...)` 명령어를 사용하는 것이다. 이 명령어들을 통해 CMake는 라이브러리의 빌드 타겟과 관련 정보를 자동으로 `xxx-config.cmake` 파일에 포함한다.

```cmake
foo/
  include/
    foo.h
  src/
    foo.cpp
  CMakeLists.txt
  build/
```

`CMakeLists.txt` 파일에 `install()`과 `export()` 명령어를 추가하여 `foo`의 설치 및 설정 정보를 자동 생성할 수 있도록 한다.

```cmake
// CMakeLists.txt

cmake_minimum_required(VERSION 3.20)
project(foo)

// 라이브러리 생성
add_library(foo STATIC src/foo.cpp)
target_include_directories(foo PUBLIC include)

// 라이브러리 설치 경로 설정
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

// 설치할 include 디렉토리 지정
install(DIRECTORY include/ DESTINATION include)

// 라이브러리 설치
install(TARGETS foo
	EXPORT foo-targets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

// foo-targets.cmake 파일 생성
install(EXPORT foo-targets
	FILE foo-targets.cmake
    NAMESPACE foo::
    DESTINATION lib/cmake/foo
)

// foo-config.cmake와 foo-config-version.cmake 파일 생성
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
	"${CMAKE_CURRENT_BINaRY_DIR}/foo-config-version.cmake"
    VERSION 1.0
    COMPATIBILITY AnyNewerVersion
)

install(FILES
	"${CMAKE_CURRENT_BINARY_DIR}/foo-config-version.cmake"
    DESTINATION lib/cmake/foo
)

// foo-config.cmake 파일 생성
configure_package_config_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/foo-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/foo-config.cmake
    INSTALL_DESTINATION lib/cmake/foo
)

install(FILES
	"${CMAKE_CURRENT_BINARY_DIR}/foo-config.cmake"
    DESTINATION lib/cmake/foo
)
```

## foo-config.cmake.in 파일 작성

`cmake` 디렉토리 아래에 `foo-config.cmake.in` 파일을 작성한다. 이 파일은 `configure_package_config_file()`로 사용되어 설치할 때 `CMake`가 필요한 경로를 채워 넣는다.

```cmake
// foo-confg.cmake.in

@PACKAGE_INIT@

include("${CMAKE_CURRENT_LIST_DIR}/foo-targets.cmake")
```

이 파일은 `configure_package_config_file()` 명령을 사용해 `foo-config.cmake`로 변환되며, 설치된 경로에서 라이브러리의 타겟 정보를 포함한다.

## 빌드 및 설치

프로젝트를 빌드하고 설치하여 `foo-config.cmake`를 자동 생성하는 예이다.

```terminal
cd build
cmake ..
cmake --build .
cmake --install .
```

설치 후, `foo-config.cmake` 파일은 다음 경로에 위치하게 된다.

```terminal
foo/install/lib/cmake/foo/foo-config.cmake
```

## 다른 프로젝트에서 사용

`foo` 라이브러리를 사용하는 다른 프로젝트에서는 `find_pakcage()`를 다음과 같이 사용할 수 있다.

```cmake
cmake_minimum_required(VERSION 3.20)
project(my_app)

// foo 라이브러리 찾기
find_pakcage(foo 1.0 REQUIRED)

// foo를 링크하여 my_app 실행 파일 생성
add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE foo::foo)
```

## 📒 정리

- `install()`과 `export()` 명령어를 사용하면, `CMake`가 `xxx-config.cmake` 파일을 자동으로 생성할 수 있다.
- `foo-config.cmake.in` 파일을 `configure_package_config_file()`을 통해 템플릿으로 사용하여 CMake가 설치 경로에 맞게 설정 파일을 생성한다.
- 라이브러리 설치 후 다른 프로젝트에서 `find_package()`를 통해 라이브러리를 쉽게 사용할 수 있다.

---

## CMAKE_PREFIX_PATH 변수의 역할

`xxx-config.cmake` 파일을 사용하려면, `CMAKE_PREFIX_PATH`에 해당 파일이 포함된 디렉토리의 상위 경로를 등록하여 `CMake`가 이 파일을 찾을 수 있도록 하는 방식이 많이 사용된다. 이 설정은 CMake가 `find_package()` 명령어를 사용할 때 `xxx-config.cmake` 파일을 찾을 수 있는 경로를 알려주는 역할을 한다.

- **`CMAKE_PREFIX_PATH`**
  - `CMake`가 라이브러리나 패키지의 설치 경로를 검색할 때 사용하는 경로 목록이다.
  - `find_package()`를 호출 할 때, `CMAKE_PREFIX_PATH`에 지정된 경로들을 순차적으로 검색하여 `xxx-config.cmake` 파일을 찾는다.

### xxx-config.cmake 파일 위치와 CMAKE_PREFIX_PATH

라이브러리를 설치할 때, `xxx-config.cmake` 파일은 일반적으로 다음과 같은 위치에 저장된다.

```terminal
<install_prefix>/
  include/
    foo/
      foo.h
  lib/
    libfoo.a
    cmake/
      foo/
        foo-config.cmake
        foo-config-version.cmake
        foo-targets.cmake
```

여기서 `xxx-config.cmake` 파일이 위치한 경로는 `lib/cmake/foo/` 이다. CMake가 `find_package()`를 통해 이 파일을 찾기 위해서는 `CMAKE_PREFIX_PATH`에 `<install_prefix>`를 추가해야 한다.

## CMAKE_PREFIX_PATH 설정 방법

`CMAKE_PREFIX_PATH`는 여러 가지 방법으로 설정할 수 있다.

### CMake 명령어에서 직접 설정

CMake를 호출할 때, `-DCMAKE_PREFIX_PATH` 옵션을 사용하여 경로를 추가할 수 있다.

```terminal
cmake -DCMAKE_PREFIX_PATH=/path/to/foo/install ..
```

이렇게 하면 CMake가 `/path/to/foo/install` 경로 아래에서 `xxx-config.cmake` 파일을 찾는다.

### CMakeLists.txt 파일에서 설정

CMake 스크립트 내에서 `CMAKE_PREFIX_PATH` 변수를 설정할 수도 있다.

```cmake
// CMakeLists.txt

set(CMAKE_PREFIX_PATH "/path/to/foo/install" ${CMAKE_PREFIX_PATH})
// 혹은
list(APPEND CMAKE_PREFIX_PATH "/path/to/foo/install")
```

이렇게 하면, 해당 경로가 `find_package()` 명령어를 사용할 때 자동으로 검색된다.

### 환경 변수로 설정

`CMAKE_PREFIX_PATH`를 환경 변수로 설정할 수도 있다. 터미널에서 다음과 같이 설정한다.

- Linux/MacOS
```terminal
export CMAKE_PREFIX_PATH=/path/to/foo/install:${CMAKE_PREFIX_PATH}
```

- Windows (CMD)
```console
set CMAKE_PREFIX_PATH=C:\path\to\foo\install;%CMAKE_PREFIX_PATH%
```

- Windows (PowerShell)
```console
$env:CMAKE_PREFIX_PATH="C:\path\to\foo\install;$env:CMAKE_PREFIX_PATH"
```

이 방법은 시스템 전역 설정이나 사용자 환경 설정으로 라이브러리 경로를 추가하는 경우에 유용하다.

## find_package()와 CMAKE_PREFIX_PATH

`CMAKE_PREFIX_PATH`에 올바르게 경로를 설정한 후, 다른 프로젝트에서 `find_package()`를 호출하면 CMake는 다음과 같은 경로를 검색한다.

- **`<CMAKE_PREFIX_PATH>/lib/cmake/foo/foo-config.cmake`**
- **`<CMAKE_PREFIX_PATH>/share/foo/cmake/foo-config.cmake`**

따라서, `xxx-config.cmake` 파일이 위와 같은 위치에 있다면 CMake는 `find_package(foo)`를 통해 라이브러리를 자동으로 찾을 수 있다.

## 📒 정리

- `CMAKE_PREFIX_PATH`를 설정하여 CMake가 `xxx-config.cmake` 파일을 포함한 라이브러리 설치 경로를 찾을 수 있도록 한다.
- `xxx-config.cmake` 파일은 보통 `lib/cmake/` 혹은 `share/cmake/` 디렉토리에 위치하며, `CMAKE_PREFIX_PATH`에 해당 파일의 `상위 경로`를 추가해야 `CMake`가 이를 찾을 수 있다.
- 설정 방법에는 `CMake` 명령어 옵션, CMakeLists.txt에서 설정, 또는 환경 변수 설정이 있다.

이러한 방법으로, 다른 프로젝트에서 라이브러리를 사용할 때 별도의 수작업 없이 손쉽게 `find_package()`를 사용할 수 있어 편리하다.
