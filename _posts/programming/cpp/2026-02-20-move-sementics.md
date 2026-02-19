---
title: std::move sementics
description: >-
  std::move sementics
author: seongcheol
date: 2026-02-20 01:52:00
categories: [Programming, C++]
tags: [C++, std::move]
pin: true
media_subpath: '/assets/img/common'
image:
  path: /title/cpp_title.jpg
---

## std::move

C++의 모든 `expression`은 `value category`를 가진다.

| Category| 개념                          | 예시                 |
| :-----  | :--------------------------- | :------------------ |
| lvalue  | 이름이 있는, 주소를 취할 수 있는 것 | `int x = 5;` -> `x` |
| rvalue  | 임시 객체, 이름 없는 것           | `5`, `foo()` 반환값  |

## std::mvoe의 정체

```cpp
// <utility> 헤더의 실체 구현 (단순화)
template<typename T>
constexpr std::remove_reference_t<T>&& move(T&& t) noexcept
{
  return static_cast<std::remove_reference_t<T>&&>(t);
}
```

`std::move`는 아무것도 이동하지 않는다. 단지 `lvalue`를 `rvalue refernece`로 `casting`할 뿐이다.

> `std::move(x)` == `static_cast<T&&>(x)`
{: .prompt-tip }
