---
title: "[DevTools/CMake] CMAKE_MODULE_PATH & CMAKE_PREFIX_PATH"
description: >-
  CMAKE_MODULE_PATH는 사용자 정의 FindXXX.cmake 모듈을 찾기 위한 경로다. CMAKE_PREFIX_PATH는 find_package()가 외부 라이브러리(Config 패키지)를 찾을 때 참고하는 상위 경로다.
series: "CMake for Beginner"
series_part: 10
author: seongcheol
date: 2026-03-02 00:55:00 +0900
categories: [DevTools, CMake]
tags: [CMake, ]
pin: true
image:
  path: "/assets/img/common/title/cmake_title.jpg"
mermaid: true
---

`CMAKE_MODULE_PATH`와 `CMAKE_PREFIX_PATH`는 `CMake`에서 모두 경로를 설정하는 변수들이지만, 서로 다른 목적과 동작 방식을 가지고 있다.

## CMAKE_MODULE_PATH

주로 `CMake 모듈 파일(.cmake)`을 검색한다.

이 변수는 `사용자 정의 모듈`이나 `CMake가 제공하는 모듈`을 찾는데 사용된다. 특히 `FindXXX.cmake`와 같은 `모듈 파일`을 찾는 데 사용된다. 이 파일들은 패키지를 찾거나 사용자 정의 CMake 기능을 정의하는 스크립트이다.

`CMakeLists.txt`에서 `find_package()`, `find_file()`, `find_library()` 등과 같은 명령을 사용할 때, CMake가 추가적으로 모듈 파일을 검색할 경로를 지정하는 데 사용된다.

예를 들어, `find_package(Foo REQUIRED)`를 호출했을 때, CMake는 `FindFoo.cmake` 파일을 `CMAKE_MODULE_PATH`에서 지정한 경로에서 우선적으로 찾는다.
또한 `CMAKE_MODULE_PATH`에 설정된 경로는 ***명시적으로 지정한 경로에서만*** 검색한다. 즉, 모듈 파일을 찾기 위해 이 변수에 지정된 디렉토리 내의 파일만을 검색하며, 하위 디렉토리는 자동으로 포함되지 않는다.
  
```cmake
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/moduels")
```

위의 코드는 CMake가 모듈 파일을 검색할 때 `${CMAKE_SOURCE_DIR}/cmake/moduels` 경로를 참조하게 만든다.

즉, `cmake/modules` 디렉토리 안에서 `FindXXX.cmake` 같은 모듈 파일을 찾는 것이다.

---

## CMAKE_PREFIX_PATH

**패키지 및 라이브러리** (특정한 유형의 파일이나 디렉토리 구조를 가진 설치된 소프트웨어)의 경로 설정을 한다.

주로 `find_package()`, `find_library()`, `find_file()` 명령에서 사용되며, CMake는 패키지의 구성 파일 또는 라이브러리의 헤더 및 바이너리 파일들을 찾는다.
즉,  `find_package()` 같은 명령어가 패키지를 찾을 때 참조할 `기본 경로(prefix)`를 설정하는 데 사용된다. `CMAKE_PREFIX_PATH`는 `include`, `lib`, `bin` 등 여러 하위 디렉토리를 자동으로 참조한다.

CMake는 `package-config.cmake`, `FooConfig.cmake` 혹은 `특정 라이브러리의 헤더 및 바이너리 파일` 등을 찾는다. 패키지를 빌드할 때 필요한 여러 파일들을 찾는 과정에서 이 변수가 사용된다.

예를 들어, `find_package(Foo REQUIRED)`를 호출하면, `CMAKE_PREFIX_PATH`에 지정된 경로 내에서 `FooConfig.cmake` 또는  `FindFoo.cmake` 파일을 찾는다.

```cmake
set(CMAKE_PREFIX_PATH "/usr/local/mylib")
```

이 코드는 `/usr/local/mylib` 하위 디렉토리에서 `CMake`가 패키지를 찾도록 설정한다. 이 겅로 아래에 `lib`, `include` 등의 하위 디렉토리도 자동으로 참조된다.

`CMAKE_PREFIX_PATH`는 **하위 디렉토리**들을 자동으로 포함하여 검색한다. 기본적으로 `include`, `lib`, `share`와 같은 하위 디렉토리도 탐색하며, 해당 경로에 있는 관련 파일을 찾는다.

## 👏 차이점

우선 이 두 변수의 차이점을 요약하자면 다음과 같다.

- `CMAKE_MODULE_PATH`
  - 주로 **모듈 파일(`.cmake`)**을 찾기 위한 경로로 사용되며, **지정된 경로 내의 파일만 검색**한다.
- `CMAKE_PREFIX_PATH`
  - **패키지나 라이브러리**를 찾는 경로로 사용되며, **하위 디렉토리를 포함한 경로 전체를 검색**한다.
  
이 두개의 변수 중에 `CMAKE_PREFIX_PATH` 하나만 있어도 될 듯하다. 허나 ***실제 사용 시에는 특정 상황에 따라 `CMAKE_MODULE_PATH`와 `CMAKE_PREFIX_PATH`를 함께 사용하는 것이 더 적절할 수 있다.*** 그 이유는 다음과 같다.

## find_package() 동작 차이

`find_package()`는 두 가지 방식으로 패키지를 찾는다.

1. `FooConfig.cmake` 또는 `foo-config.cmake` 파일을 찾는다. (설치된 패키지 제공)
2. `FindFoo.cmake`와 같은 `모듈 파일`을 찾는다 (CMake 모듈 방식)

`CMAKE_PREFIX_PATH`는 주로 첫 번째 방식, 즉 `FooConfig.cmake` 같은 **패키지 구성 파일**을 찾는 데 사용된다. 이 방식은 패키지가 표준적인 방법으로 설치된 경우에 매우 유용하다.

`CMAKE_MODULE_PATH`는 `FindFoo.cmake`와 같은 **모듈 파일**을 찾는 데 사용되며, 이 파일들은 `CMake`가 기본적으로 제공하지 않거나, `사용자 정의` 된 패키지 찾기 로직이 필요할 때 유용하다.

따라서 `CMAKE_PREFIX_PATH`만 사용할 경우, 패키지의 `config` 파일이 없는 경우, 문제가 발생할 수 있다. `FindXXX.cmake` 모듈을 통해 패키지를 찾으려면 `CMAKE_MODULE_PATH`를 따로 지정해야 한다.

## 사용자 정의 모듈 파일 사용

만약 프로젝트에서 사용자 정의 모듈 파일을 사용한다면, 이 파일들은 `CMake`의 기본 패키지 찾기 시스템에서 바로 인식되지 않는다. 

예를 들어, 특정 라이브러리를 위해 `FindXXX.cmake` 파일을 작성했다면 이 파일의 경로를 `CMAKE_MODULE_PATH`에 추가해야만 `CMake`가 이를 찾아 사용할 수 있다.

> `CMAKE_MODULE_PATH`는 CMake가 모듈 파일을 찾기 위한 `추가 경로`를 제공하는 것이므로, ***사용자 정의 모듈 파일***이 필요한 상황에서는 반드시 설정해야만 하는 변수이다.

## `CMAKE_PREFIX_PATH`의 자동 경로 탐색과 모듈 경로의 차이

`CMAKE_PREFIX_PATH`는 패키지를 찾을 때, `/lib`, `/include`, `/share` 등과 같은 디렉토리를 자동으로 탐색하지만, `FindXXX.cmake`와 같은 모듈 파일을 포함한 경로는 자동으로 탐색하지 않는다.

반면, `CMAKE_MODULE_PATH`는 명확히 지정된 경로 내에서 모듈을 찾도록  설계되었다.

예를 들어, 만약 패키지 파일이 `/opt/mylib`에 설치되어 있고 그 안에 `FooConfig.cmake`가 있으면, `CMAKE_PREFIX_PATH`가 잘 작동한다.
하지만 `/opt/mylib/cmake/FindFoo.cmake` 같은 `모듈 파일`을 사용하려면, `CMAKE_MODULE_PATH`에 명시적으로 경로를 지정해야 한다.

---

## 📒 정리

**패키지가 `CMake 표준 경로`에 잘 설치되어 있고 `FooConfig.cmake` 파일을 제공하는 경우**라면, `CMAKE_PREFIX_PATH` 하나만으로 충분할 수 있다.

하지만 **사용자 정의 모듈 파일**을 사용하거나, **패키지에서 `FindXXX.cmake` 파일을 통해 라이브러리를 찾을 때**는 `CMAKE_MODULE_PATH`도 함께 설정하는 것이 좋다.

즉, ***모든 상황에서 `CMAKE_PREFIX_PATH` 하나로 충분하다고 할 수는 없으며***, 상황에 따라 두 변수를 함께 사용하는 것이 더 유연하고 문제가 발생할 확률을 줄일 수 있다.
