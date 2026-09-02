---
title: "[Programming/Swift] Concurrency Basic"
description: >-
  Swift는 구조화된 방식으로 비동기(asynchronous)와 병렬(parallel) 코드 작성을 지원한다. 
author: seongcheol
date: 2026-09-01 00:06:00 +0900
categories: [Programming, Swift]
tags: [Swift, Concurrency]
pin: false
image:
  path: /assets/img/common/title/swift_title.png
---


`Swift`는 구조화된 방식으로 `비동기 (asynchronous)`와 `병렬 (parallel)` 코드 작성을 지원한다. 
`비동기 코드(Asynchronous code)`는 일시적으로 중단되었다가 다시 실행할 수 있지만 한 번에 프로그램의 한 부분만 실행된다. 프로그램에서 코드를 일시 중단하고 다시 실행하면 UI 업데이트와 같은 짧은 작업을 계속 진행하면서 네트워크를 통해 데이터를 가져오거나 파일을 분석하는 것과 같은 긴 실행 작업을 계속할 수 있다.

`병렬 코드(Parallel code)`는 동시에 코드의 여러 부분이 실행됨을 의미한다. 예를 들어 4코어 프로세스의 컴퓨터는 각 코어가 하나의 작업을 수행하므로 코드의 네 부분을 동시에 실행할 수 있다. 

병렬이나 비동기 코드의 추가적인 스케줄링 유연성에는 복잡성이 증가한다. 동시성 코드를 작성할 때 어떤 코드가 동시에 실행될지 알 수 없으며, 코드 실행 순서도 항상 알 수 없을 수 있다. 동시성 코드에서 흔히 발생하는 문제는 여러 코드가 일부 공유 가능한 가변 상태에 접근하려고 할 때 발생하고, 이것을 `데이터 경쟁(data race)`이라고 한다. 
언어 차원의 동시성 지원을 사용하면 Swift는 데이터 경쟁을 감지하고 방지하며, 대부분의 데이터 경쟁은 컴파일 시 오류를 발생시킨다. 일부 데이터 경쟁은 코드가 실행될 때까지 감지되지 않을 수 있다. 이러한 데이터 경쟁은 코드 실행을 종료시킨다.

> Actor와 격리(isolation)를 사용하면 `데이터 경쟁(data race)`으로부터 보호할 수 있다.

다음 코드는 사진 이름 목록을 다운로드하고, 해당 목록의 첫 번째 사진을 다운로드하고, 해당 사진을 사용자에게 보여주는 코드이다.

```swift
listPhotos(inGallery: "Summer Vacation") { photoNames in
    let sortedNames = photoNames.sorted()
    let name = sortedNames[0]
    downloadPhoto(named: name) { photo in
        show(photo)
    }
}
```

위 코드는 `완료 핸들러(completion handler)` 방식으로, 간단한 경우에도 클로저가 중첩되어 코드가 복잡해진다. 이런 문제를 해결하기 위해 Swift는 `async/await` 기반의 비동기 함수를 제공한다.

## 비동기 함수 정의와 호출 (Defining and Calling Asynchronous Functions)

`비동기 함수(asynchronous function)`나 `비동기 메서드(asynchronous method)`는 실행 도중에 일시적으로 중단될 수 있는 특수한 함수나 메서드이다.
이것은 완료될 때까지 실행 혹은 오류가 발생하는 반환되지 않는 일반적인 `동기 함수(synchronous function)`나 `메서드(sychrounous method)`와 대조된다. 

함수나 메서드가 `비동기(asynchronous)`임을 나타내려면 `던지는 함수(throwing function)`를 나타내기 위해 `throws` 사용하는 것과 유사하게 매개변수 뒤의 선언에 `async` 키워드를 작성한다. 

> 함수나 메서드가 값을 반환한다면, `반환 화살표(->)` 앞에 `async`를 작성한다. 

```swift
func listPhotos(inGallery name: String) async -> [String] {
    let result = // ... 비동기 코드
    return result
}
```

비동기 메서드를 호출할 때, 해당 메서드가 반환할 때까지 실행이 일시 중단된다. 중단될 가능성이 있는 지점을 표시하기 위해 호출 앞에 `await`를 작성한다. 
이것은 오류가 있는 경우 프로그램의 흐름이 변경 가능함을 나타내기 위해 던지는 함수를 호출할 때 `try`를 작성하는 것과 같다.

비동기 메서드 내에서 실행 흐름은 다른 비동기 메서드를 호출할 때만 일시 중단될 수 있다. 중단은 암시적이거나 선점적이지 않다. 이것은 가능한 모든 중단 지점이 `await`로 표시된다는 의미이다. 코드에서 중단 가능한 모든 지점을 표시하면 동시성 코드를 읽기 쉽고 이해하기 쉽게 만들어 준다.

예를 들어 아래 코드는 갤러이에 모든 사진의 이름으 가져온 다음, 첫 번째 사진을 보여준다.

```swift
let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames.first ?? "No photos found"
let photo = await downloadPhoto(named: name)
show(photo)
```

`listPhotos(inGallery:)`와 `downloadPhoto(named:)` 함수 모두 네트워크 요청을 필요로 하기 때문에, 완료하는데 비교적 오랜 시간이 걸릴 수 있다. 반환 화살표 전에 `async`를 작성하여 둘 다 비동기로 만들면 이 코드는 사진이 준비될 때까지 기다리는 동안 앱의 나머지 코드가 계속 실행될 수 있다.

위 예시 코드의 동시성을 이해하기 위한 실행 순서는 다음과 같다.

1. 코드는 첫 번째 줄에서 실행을 시작하고, 첫 번째 `await`까지 실행된다. `listPhotos(inGallery:)` 함수를 호출하고 해당 함수가 반환할 때까지 실행을 일시 중단한다.


---

* 출처: [Swift 공식 Doc](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)
