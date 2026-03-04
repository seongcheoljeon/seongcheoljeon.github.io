---
title: "[Editor/Vim] 동일한 문자열을 한번에 처리"
description: >-
  Vim에서 동일한 문자열을 한 번에 찾아 일괄 변경하는 방법을 간단히 정리한다.
author: seongcheol
date: 2026-03-03 16:45:00 +0900
categories: [Editor, Vim]
tags: [Editor, Vim]
pin: true
image:
  path: "/assets/img/common/title/vim_title.jpg"
---

## 여러 줄에 동일한 문자열 한번에 삽입하기 ⌨️

> 100줄에 동일한 문자열을 넣어야 한다면?  
> 스크립트를 짜기엔 번거롭고, 하나씩 입력하기엔 너무 많다.  
> Vim의 **Visual Block** 모드를 쓰면 단 몇 번의 키 입력으로 해결할 수 있다.

---

## 🧱 Visual Block 모드란?

Vim의 Visual 모드는 세 가지다.

| 명령 | 모드 | 설명 |
|------|------|------|
| `v` | Character Visual | 문자 단위 선택 |
| `V` | Line Visual | 줄 단위 선택 |
| `<C-v>` | **Block Visual** | **직사각형 블록 단위 선택** |

`<C-v>`로 진입하는 Block Visual이 핵심이다.  
열(column) 기준으로 영역을 선택하기 때문에 여러 줄을 동시에 편집할 수 있다.

---

## 1. ➕ 줄 앞에 삽입 (`I`)

### 방법

```
<C-v>       Block Visual 모드 진입
j / k       원하는 줄까지 선택 범위 확장
I           선택 블록의 앞에 Insert 모드 진입 (대문자 I)
<text>      삽입할 문자열 입력
<Esc>       완료 — 선택된 모든 줄에 적용
```

> ⚠️ `<Esc>` 를 누르기 전까지는 첫 번째 줄에만 보인다.  
> `<Esc>` 를 누르는 순간 선택된 전체 줄에 일괄 적용된다.

### Before / After 예시

문자열 `// ` 를 줄 앞에 삽입 (주석 처리)

**Before**
```
int a = 1;
int b = 2;
int c = 3;
int d = 4;
```

**After**
```
// int a = 1;
// int b = 2;
// int c = 3;
// int d = 4;
```

---

## 2. ➕ 줄 끝에 삽입 (`A`)

`I`가 줄 앞 삽입이라면, `A`는 줄 끝 삽입이다.

```
<C-v>       Block Visual 모드 진입
j / k       원하는 줄까지 선택 범위 확장
A           선택 블록의 끝에 Insert 모드 진입 (대문자 A)
<text>      삽입할 문자열 입력
<Esc>       완료
```

### Before / After 예시

문자열 `;` 를 줄 끝에 삽입

**Before**
```
int a = 1
int b = 2
int c = 3
int d = 4
```

**After**
```
int a = 1;
int b = 2;
int c = 3;
int d = 4;
```

---

## 3. ⚡ 응용 — `:'<,'>norm` 패턴

Visual Block `I` / `A` 보다 더 강력한 방법이 있다.  
줄마다 **Normal 모드 명령을 직접 실행**하는 방식이다.

```vim
:'<,'>norm I// 
```

Visual로 범위를 선택한 뒤 `:` 를 누르면 `'<,'>` 가 자동으로 붙는다.  
`norm I// ` 는 각 줄에 대해 `I// ` (줄 앞에 `// ` 삽입) 를 실행하라는 의미다.

| 명령 | 동작 |
|------|------|
| `:'<,'>norm I// ` | 선택 범위 각 줄 앞에 `// ` 삽입 |
| `:'<,'>norm A;` | 선택 범위 각 줄 끝에 `;` 삽입 |
| `:'<,'>norm dw` | 선택 범위 각 줄에서 단어 하나 삭제 |

> 💡 `norm` 뒤에는 **어떤 Normal 모드 명령이든** 올 수 있다.  
> Visual Block `I` / `A` 로 안 되는 복잡한 편집도 처리할 수 있다.

---

## 🔑 키 표기 정리

이 글에서 사용하는 키 표기 기준이다.

| 표기 | 의미 |
|------|------|
| `<C-v>` | Ctrl + v |
| `<Esc>` | Escape |
| `I` | 대문자 i (Insert, 줄 앞) |
| `A` | 대문자 a (Append, 줄 끝) |

---

## 🏆 정리

| 상황 | 방법 |
|------|------|
| 줄 앞에 동일 문자열 삽입 | `<C-v>` → 범위 선택 → `I` → 입력 → `<Esc>` |
| 줄 끝에 동일 문자열 삽입 | `<C-v>` → 범위 선택 → `A` → 입력 → `<Esc>` |
| 복잡한 편집 (Normal 명령 활용) | Visual 선택 → `:'<,'>norm <명령>` |

---

*참고: `:help visual-block`, `:help norm` (Vim 내장 문서)*
