---
title: "[Editor/VisualStudio] Visual Assist : Shortcuts"
description: >-
  Visual Assist의 주요 단축키를 기본 키 바인딩 기준으로 카테고리별로 정리한다.
author: seongcheol
date: 2026-03-16 01:45:00 +0900
categories: [Editor, VisualStudio]
tags: [Editor, VisualStudio]
pin: false
image:
  path: "/assets/img/common/title/vs_title.png"
---

> Visual Assist 기본 단축키 기준이다. VA는 Visual Studio에 이미 할당된 키를 **덮어쓰지 않으므로** 환경에 따라 일부 단축키가 비어 있을 수 있다. † 표시는 설치 직후에는 할당되지 않고 `VAssistX › Help › Keyboard Shortcuts › Recommended` 에서 권장 단축키를 수락했을 때 할당되며, ‡ 표시는 권장 수락 시 텍스트 에디터 밖(전역)으로 범위가 확장된다. 현재 바인딩은 `VAssistX › Help › Keyboard Shortcuts` 에서 확인하고, 변경은 `Tools › Options › Environment › Keyboard` 의 `VAssistX.*` 명령에서 한다. 출처: Whole Tomato 공식 문서 [Keyboard Shortcuts](https://www.wholetomato.com/en/documentation/configuration/keyboard-shortcuts) (Updated Jun 2026).
{: .prompt-info }

## 자주 쓰는 단축키

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Alt</kbd>+<kbd>G</kbd> | 선언부 ↔ 구현부 이동 (GoTo Implementation) — 대상이 여럿이면 메뉴 표시 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>G</kbd> | 관련 심볼로 이동 (GoTo Related) — 기반 클래스·오버라이드·타입 등 |
| <kbd>Alt</kbd>+<kbd>O</kbd> | 대응 파일 열기 (Open Corresponding File) — .h ↔ .cpp |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>O</kbd> ‡ | 솔루션 내 파일 열기 (Open File in Solution) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> | 솔루션 내 심볼 찾기 (Find Symbol in Solution) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> | 참조 찾기 (Find References) |
| <kbd>Alt</kbd>+<kbd>M</kbd> | 파일 내 메서드 목록 (List Methods in File) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Q</kbd> | 빠른 작업 및 리팩터링 메뉴 (Quick Action and Refactoring) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd> | 이름 바꾸기 (Rename) — 선언·정의·모든 참조 일괄 |

## 탐색

### 심볼 · 파일 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Alt</kbd>+<kbd>G</kbd> | 선언부 ↔ 구현부 이동 (GoTo Implementation) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>G</kbd> | 관련 심볼로 이동 (GoTo Related) |
| <kbd>Alt</kbd>+<kbd>O</kbd> | 대응 파일 열기 (Open Corresponding File) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>O</kbd> ‡ | 솔루션 내 파일 열기 (Open File in Solution) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> | 솔루션 내 심볼 찾기 (Find Symbol in Solution) |
| <kbd>Alt</kbd>+<kbd>M</kbd> | 파일 내 메서드 목록 (List Methods in File) — VA Outline 없이 현재 파일의 클래스·메서드로 점프 |

### 위치 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Alt</kbd>+<kbd>←</kbd> ‡ | 이전 위치로 (Navigate Back) |
| <kbd>Alt</kbd>+<kbd>→</kbd> † | 다음 위치로 (Navigate Forward) |
| <kbd>Alt</kbd>+<kbd>↑</kbd> † | 이전 스코프로 (Move to Previous Scope) |
| <kbd>Alt</kbd>+<kbd>↓</kbd> † | 다음 스코프로 (Move to Next Scope) |

## 검색

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> | 참조 찾기 (Find References) — 결과 창에서 파일별 그룹·읽기/쓰기 구분 |
| <kbd>Alt</kbd>+<kbd>K</kbd> † | 커서 단어 강조 (Find Selected) — Ctrl+F 검색을 실행한 것처럼 인스턴스 하이라이트 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>H</kbd> | VA Hashtags 창 열기 — 주석 내 `#tag` 북마크 모음 |

## 편집

### 리팩터링 · 코드 생성

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Q</kbd> | 빠른 작업 및 리팩터링 메뉴 (Quick Action and Refactoring) — Extract Method, Add Include, Document Method 등은 기본 단축키가 없어 이 메뉴에서 실행 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd> | 이름 바꾸기 (Rename) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>C</kbd> | 사용처로부터 생성 (Create From Usage) — 미정의 심볼에서 선언·정의 생성 |

### 선택 (Smart Select)

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>]</kbd> † | 선택 확장 (Smart Select Extend) — 작은 단위 |
| <kbd>Alt</kbd>+<kbd>]</kbd> | 블록 선택 확장 (Smart Select Extend Block) — 큰 단위 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>[</kbd> † | 선택 축소 (Smart Select Shrink) |
| <kbd>Alt</kbd>+<kbd>[</kbd> | 블록 선택 축소 (Smart Select Shrink Block) |

### 클립보드 · 보기

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> † | 다중 클립보드 붙여넣기 메뉴 (Multiple Clipboards) |
| <kbd>Ctrl</kbd>+<kbd>0</kbd> † | 에디터 확대 100% 리셋 (Reset Editor Zoom) |
