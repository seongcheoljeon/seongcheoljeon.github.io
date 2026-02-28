---
title: "[DevTools/CMake] CMake의 target"
description: >-
  CMake에서 target은 실행 파일과 라이브러리를 구성하는 핵심 단위다. add_executable, add_library로 생성된 타겟을 중심으로 include 경로, 컴파일 옵션, 링크 라이브러리를 연결하며 의존성을 명확하게 관리한다.
series: "CMake for Beginner"
series_part: 3
author: seongcheol
date: 2026-03-01 00:20:00 +0900
categories: [DevTools, CMake]
tags: [CMake, target]
pin: true
image:
  path: "/assets/img/common/title/cmake_title.jpg"
mermaid: true
---

`target_`으로 시작하는 명령어들을 사용하다보면, `PRIVATE`, `PUBLIC`, `INTERFACE` 키워드를 자주 볼 것이다. 우선 이 키워드들부터 개념정리를 하고 넘어가자.

## PUBLIC, PRIVATE, INTERFACE
CMake의 `PUBLIC`, `PRIVATE`, `INTERFACE` 개념은 컴파일 옵션뿐만 아니라 **대부분의 타겟 속성**에 일관되게 적용된다.
이는 `컴파일 옵션`, `include 디렉토리`, `링크 라이브러리`, `정의(Definitions)` 등 다양한 속성에 동일한 방식으로 작동한다.

다음은 그 대표적인 예이다.

### 사용 예

#### target_include_directories

이 명령을 사용할 때 `PUBLIC`, `PRIVATE`, `INTERFACE`는 **헤더 파일의 가시성**을 제어한다.

- `PRIVATE`
  - 해당 타겟에서만 헤더 파일 경로를 사용하며, 의존하는 타겟에는 전파되지 않는다.
- `PUBLIC`
  - 해당 타겟과 의존하는 모든 타겟에 헤더 파일 경로가 전파된다.
- `INTERFACE`
  - 해당 타겟에서는 사용하지 않지만, 의존하는 타겟에서는 헤더 파일 경오를 사용한다.
  
```cmake
target_include_directories(MyTarget
	PUBLIC 	${CMAKE_SOURCE_DIR}/include
    PRIVATE	${CMAKE_SOURCE_DIR}/src
)
```

여기서 `MyTarget`은 `src` 디렉토리에서 헤더를 찾고, `MyTarget`에 의존하는 타겟들은 `include` 디렉토리에서 헤더를 찾는다.

#### target_link_libraries

이 명령에서는 `PUBLIC`, `PRIVATE`, `INTERFACE`가 **링크 라이브러리**의 가시성을 제어한다.

- `PRIVATE`
  - 타겟 내부에서만 해당 라이브러이를 링크한다.
- `PUBLIC`
  - 타겟과 의존하는 타겟 모두 해당 라이브러리를 링크한다.
- `INTERFACE`
  - 해당 타겟 자체에서는 링크하지 않지만, 의존하는 타겟에서는 해당 라이브러리를 링크한다.

```cmake
target_link_libraries(MyTarget
	PUBLIC 	SomeLibrary
    PRIVATE	AnotherLibrary
)
```

여기서 `MyTarget`은 `SomeLibrary`와 `AnotherLibrary`를 링크하지만, `MyTarget`에 의존하는 타겟은 `SomeLibrary`만 링크하게 된다.

#### target_compile_definitions

이 명령을 통해 **전처리기 정의**를 추가할 때도 동일한 원칙이 적용된다.

- `PRIVATE`
  - 해당 타겟에서만 전처리기 정의가 적용된다.
- `PUBLIC`
  - 해당 타겟과 의존하는 모든 타겟에 전처리기 정의가 적용된다.
- `INTERFACE`
  - 해당 타겟에서는 적용되지 않지만, 의존하는 타겟에서 전처리기 정의가 적용된다.

```cmake
target_compile_definitions(MyTarget
	PUBLIC 	MY_DEFINE=1
    PRIVATE	MY_INTERNAL_DEFINE=1
)
```

#### 정리

- `PRIVATE`
  - 타겟 자체에서만 적용. 외부로 전파되지 않는다.
- `PUBLIC`
  - 타겟 자체와 의존하는 타겟 모두에 적용된다.
- `INTERFACE`
  - 타겟 자체에는 적용되지 않고, 의존하는 타겟에만 적용된다.

이러한 패턴은 대부분의 `CMake` 명령에서 동일하게 동작하므로, 타겟 간 의존성을 설계할 때 이를 일관되게 적용할 수 있다.

---

## target

`CMake`에서 `target_*`로 시작하는 명령어들은 **타겟(target)** 에 대한 설정을 관리하고, 각 타겟이 어떻게 `빌드`되고, `컴파일`되고, `링크`되는지를 제어한다.

이는 특히 `라이브러리`, `실행 파일` 등의 빌드에 중요한 역할을 한다.

### 자주 사용하는 명령어들

#### target_link_libraries

타겟에 라이브러리를 링크한다.

```cmake
add_library(MyLib mylib.cpp)
add_executable(MyApp main.cpp)
target_link_libraries(MyApp PRIVATE MyLib)
```

#### target_include_directories

타겟에 헤더 파일 디렉토리를 추가한다.

```cmake
target_include_directories(MyApp PRIVATE ${CMAKE_SOURCE_DIR}/include)
```

#### target_compile_options

컴파일러 옵션을 설정한다.

```cmake
target_compile_options(MyApp PRIVATE -Wall -O2)
```

#### target_compile_definitions

타겟에 전처리기 정의를 추가한다.

```cmake
target_compile_definitions(MyApp PRIVATE DEBUG_MODE=1)
```

#### target_sources

타겟에 소스 파일을 추가한다.

```cmake
target_sources(MyLib PRIVATE src/file1.cpp src/file2.cpp)
```

#### target_compile_features

타겟에서 사용할 `C++ 표준` 또는 `컴파일러 기능`을 지정한다.

```cmake
target_compile_features(MyApp PRIVATE cxx_std_17)
```

#### target_precompile_headers

미리 컴파일된 헤더(PCH)를 설정하여 컴파일 성능을 최적화한다.

```cmake
target_precompile_headers(MyApp PRIVATE "pch.h")
```

#### target_link_options

타겟에 대한 링크 옵션을 설정한다.

```cmake
target_link_options(MyApp PRIVATE -Wl, --no-undefined)
```

#### target_property

타겟 속성을 설정하거나 조회한다.

```cmake
set_target_properties(MyApp PROPERTIES CXX_STANDARD 17)
get_target_properties(CXX_STANDARD MyApp CXX_STANDARD)
```

### 자주 사용하지 않는 명령어들

#### target_link_directories

타겟이 링크할 라이브러리 디렉토리를 지정한다. 현태 `CMake`에서는 잘 사용되지 않는다. 이 명령어 대신 `target_link_libraries`를 사용한다.

```cmake
target_link_directories(MyApp PRIVATE ${CMAKE_SOURCE_DIR}/lib)
```

#### target_system_include_directories

타겟에 대해 시스템 헤더 경로를 설정한다.

```cmake
target_system_include_directories(MyApp PRIVATE /usr/loca/include)
```

#### target_generate_exports_header

타겟에 대해 내보낼 헤더 파일을 자동 생성한다. 주로 `동적 라이브러리(Shared Library)`를 빌드할 때 사용된다.

```cmake
include(GenerateExportHeader)
target_generate_exports_header(MyLib)
```

#### target_link_whole_archive

`정적 라이브러리(Static Library)`의 모든 `심볼`을 포함하여 링크할 때 사용된다.

```cmake
target_link_whole_archive(MyLib MyStaticLib)
```

#### target_link_objects

특정 타겟의 객체 파일을 다른 타겟에 링크한다.

```cmake
target_link_objects(MyTarget AnotherObjectTarget)
```

#### target_create_custom_target

사용자 정의 타겟을 생성한다. 주로 사용자 정의 빌드 단계를 추가할 때 사용된다.

```cmake
add_custom_target(MyCustomTarget ALL DEPENDS MyTarget)
```

#### target_compile_time_properties

타겟의 컴파일 시간 속성을 설정한다. 이 명령어는 일반적으로 잘 사용되지 않는다.

```cmake
set_target_properties(MyTarget PROPERTIES CXX_STANDARD 17)
```

#### target_runtime_properties

타겟의 런타임 속성을 설정한다.

```cmake
set_target_properties(MyTarget PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
```

#### target_autogen

타겟에서 자동으로 생성된 파일을 설정한다. 주로 `Qt` 프로젝트에서 사용된다.

```cmake
set_target_properties(MyTarget PROPERTIES AUTOMOC ON)
```

#### target_sources_properties

타겟에 추가된 소스 파일의 속성을 설정한다.

```cmake
set_source_files_properties(src/file.cpp PROPERTIES HEADER_FILE_ONLY ON)
```

#### target_get_sources

특정 타겟에 할당된 소스 파일 목록을 가져온다.

```cmake
get_target_properties(SOURCES MyTarget SOURCES)
```

#### target_export

타겟을 `export` 가능하게 만든다. 설치 과정에서 사용된다.

```cmake
install(TARGETS MyTarget EXPORT MyExport)
```
