---
title: "[Editor/Xcode] Xcode : Shortcuts"
description: >-
  Xcode의 주요 단축키를 기본 키 바인딩 기준으로 카테고리별로 정리한다.
author: seongcheol
date: 2026-09-05 23:10:00 +0900
categories: [Editor, Xcode]
tags: [Editor, Xcode]
pin: false
image:
  path: "/assets/img/common/title/xcode_title.png"
---

> 키 표기: <kbd>⌘</kbd> Command · <kbd>⌥</kbd> Option · <kbd>⌃</kbd> Control · <kbd>⇧</kbd> Shift · <kbd>↩</kbd> Return. **Xcode 26.6 기본 메뉴 단축키**를 직접 확인해 정리했다. 실제 바인딩은 `Xcode › Settings › Key Bindings` 에서 확인·변경할 수 있다.
{: .prompt-info }

> Xcode 26부터 <kbd>⌘</kbd>+<kbd>0</kbd> 은 **Coding Assistant**, <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>0</kbd> 은 **Coding Tools** 로 재할당되었다. 예전의 Navigator / Inspector 열기·닫기에는 기본 단축키가 없으므로 필요하면 Key Bindings에서 직접 지정해야 한다.
{: .prompt-warning }

## 자주 쓰는 단축키

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>O</kbd> | Open Quickly — 파일·심볼 통합 검색 |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>A</kbd> | Quick Actions — 메뉴 명령 검색·실행 |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>J</kbd> | 정의로 이동 (Jump to Definition) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>↑</kbd> | 헤더 ↔ 소스 전환 (Jump to Next Counterpart) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>←</kbd> | 이전 위치로 (Show Previous Location in History) |
| <kbd>⌘</kbd>+<kbd>R</kbd> | 실행 (Run) |
| <kbd>⌘</kbd>+<kbd>B</kbd> | 빌드 (Build) |
| <kbd>⌘</kbd>+<kbd>.</kbd> | 실행 중지 (Stop) |
| <kbd>⌘</kbd>+<kbd>1</kbd> | Project Navigator 표시 |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>Y</kbd> | Debug Area 열기/닫기 |
| <kbd>⌃</kbd>+<kbd>I</kbd> | 재정렬 (Re-Indent) |
| <kbd>⌘</kbd>+<kbd>/</kbd> | 주석 토글 (Comment Selection) |

## 빌드 & 실행

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>R</kbd> | 실행 (Run) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>R</kbd> | 빌드 없이 실행 (Run Without Building) |
| <kbd>⌘</kbd>+<kbd>B</kbd> | 빌드 (Build) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>B</kbd> | 현재 파일만 컴파일 (Compile File) |
| <kbd>⌘</kbd>+<kbd>.</kbd> | 실행 중지 (Stop) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>K</kbd> | 빌드 폴더 정리 (Clean Build Folder) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>B</kbd> | 정적 분석 (Analyze) |
| <kbd>⌘</kbd>+<kbd>U</kbd> | 테스트 실행 (Test) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>G</kbd> | 마지막 테스트 다시 실행 (Test Again) |
| <kbd>⌘</kbd>+<kbd>I</kbd> | 프로파일 (Profile) — Instruments 실행 |
| <kbd>⌘</kbd>+<kbd>&lt;</kbd> | 스킴 편집 (Edit Scheme) |
| <kbd>⌃</kbd>+<kbd>0</kbd> | 스킴 선택 (Choose Scheme) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>0</kbd> | 실행 대상 선택 (Choose Destination) |

## 탐색

### 파일 · 심볼 찾기

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>O</kbd> | Open Quickly — 프로젝트 내 파일·심볼 통합 검색 |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>A</kbd> | Quick Actions — 메뉴 명령을 이름으로 검색·실행 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>J</kbd> | Navigator 필터 검색으로 포커스 이동 (Filter in Navigator) |
| <kbd>⌃</kbd>+<kbd>6</kbd> | 현재 파일의 심볼 목록 (점프 바 · Show Document Items) |
| <kbd>⌃</kbd>+<kbd>1</kbd> | 관련 항목 표시 (Show Related Items) — 호출자·피호출자·카운터파트 등 |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>J</kbd> | 현재 파일을 Project Navigator에서 표시 (Reveal in Project Navigator) |

### 정의 · 위치 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>J</kbd> | 정의로 이동 (Jump to Definition) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>J</kbd> | 정의를 옆 에디터 창에서 열기 (Jump to Definition in Next Editor Pane) |
| <kbd>⌘</kbd>+<kbd>Click</kbd> | 심볼 클릭 → 정의로 이동 또는 액션 메뉴 (Settings › Navigation에서 동작 선택) |
| <kbd>⌃</kbd>+<kbd>Click</kbd> | 컨텍스트 메뉴 (우클릭과 동일) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>↑</kbd> | 헤더 ↔ 소스 전환 (Jump to Next Counterpart) — .h ↔ .cpp |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>↓</kbd> | 헤더 ↔ 소스 전환 (Jump to Previous Counterpart) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>←</kbd> | 이전 위치로 (Show Previous Location in History) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>→</kbd> | 다음 위치로 (Show Next Location in History) |
| <kbd>⌘</kbd>+<kbd>L</kbd> | 줄 번호로 이동 (Jump to Line) |
| <kbd>⌘</kbd>+<kbd>'</kbd> | 다음 이슈로 이동 (Jump to Next Issue) |
| <kbd>⌘</kbd>+<kbd>"</kbd> | 이전 이슈로 이동 (Jump to Previous Issue) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>P</kbd> | 현재 실행 지점으로 이동 (Jump to Instruction Pointer) |

### 검색

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>F</kbd> | 현재 파일에서 찾기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>F</kbd> | 현재 파일에서 찾기 및 바꾸기 |
| <kbd>⌘</kbd>+<kbd>G</kbd> | 다음 찾기 (Find Next) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>G</kbd> | 이전 찾기 (Find Previous) |
| <kbd>⌘</kbd>+<kbd>E</kbd> | 선택 텍스트를 검색어로 사용 (Use Selection for Find) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>F</kbd> | 워크스페이스 전체 텍스트 검색 (Find in Workspace) |
| <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>F</kbd> | 워크스페이스 전체 찾기 및 바꾸기 (Find and Replace in Workspace) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>F</kbd> | 선택 심볼을 워크스페이스에서 찾기 (Find Selected Symbol in Workspace) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>H</kbd> | 호출 계층 보기 (Find Call Hierarchy) |

### 탭 · 에디터 창

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>{</kbd> | 이전 탭 (Show Previous Tab) |
| <kbd>⌘</kbd>+<kbd>}</kbd> | 다음 탭 (Show Next Tab) |
| <kbd>⌘</kbd>+<kbd>W</kbd> | 탭 닫기 — 탭이 하나면 창 닫기 |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>W</kbd> | 현재 파일 닫기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>O</kbd> | 새 탭에서 열기 (Open in New Tab) |
| <kbd>⌃</kbd>+<kbd>&#96;</kbd> | 다음 에디터 창으로 포커스 이동 (Move Focus to Next Editor Pane) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>W</kbd> | 에디터 창 닫기 (Close Editor Pane) |

## 편집

### 자동완성 · 수정

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌃</kbd>+<kbd>Space</kbd> | 코드 자동완성 (Show Completions) — macOS 입력 소스 전환과 충돌 시 시스템 설정에서 변경 |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>Space</kbd> | 예측 코드 완성 (Show Predictive Completion) |
| <kbd>⌃</kbd>+<kbd>.</kbd> | 다음 완성 후보 선택 (Select Next Completion) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>E</kbd> | 스코프 내 이름 일괄 수정 (Edit All in Scope) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>F</kbd> | 모든 이슈 자동 수정 (Fix All Issues) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>E</kbd> | 다음 일치 항목에 커서 추가 (Select Next Occurrence) — 멀티 커서 |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>↑</kbd> | 위 줄에 커서 추가 (Select Column Up) — 멀티 커서 |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>↓</kbd> | 아래 줄에 커서 추가 (Select Column Down) — 멀티 커서 |

### 정렬 · 주석 · 줄 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌃</kbd>+<kbd>I</kbd> | 선택 영역 재정렬 (Re-Indent) |
| <kbd>⌘</kbd>+<kbd>]</kbd> | 들여쓰기 (Shift Right) |
| <kbd>⌘</kbd>+<kbd>[</kbd> | 내어쓰기 (Shift Left) |
| <kbd>⌘</kbd>+<kbd>/</kbd> | 주석 토글 (Comment Selection) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>/</kbd> | 문서 주석 템플릿 삽입 (Add Documentation) |
| <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>V</kbd> | 들여쓰기 맞춰 붙이기 (Paste and Preserve Formatting) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>[</kbd> | 현재 줄 위로 이동 (Move Line Up) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>]</kbd> | 현재 줄 아래로 이동 (Move Line Down) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>C</kbd> | 심볼 이름 복사 (Copy Symbol Name) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>C</kbd> | 파일 경로와 줄 번호 복사 (Copy File and Line) |

### 접기

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>←</kbd> | 현재 블록 접기 (Fold) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>→</kbd> | 현재 블록 펼치기 (Unfold) |
| <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>←</kbd> | 모든 메서드·함수 접기 (Fold Methods & Functions) |
| <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>→</kbd> | 모든 메서드·함수 펼치기 (Unfold Methods & Functions) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>←</kbd> | 주석 블록 접기 (Fold Comment Blocks) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>→</kbd> | 주석 블록 펼치기 (Unfold Comment Blocks) |

### 파일

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>N</kbd> | 새 파일 (File from Template) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>N</kbd> | 새 프로젝트 |
| <kbd>⌘</kbd>+<kbd>S</kbd> | 저장 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>S</kbd> | 모두 저장 (Save All) |

## 패널 & 레이아웃

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>1 ~ 9</kbd> | Navigator 탭 전환 — 1: Project, 2: Source Control, 3: Bookmarks, 4: Find, 5: Issues, 6: Tests, 7: Debug, 8: Breakpoints, 9: Reports |
| <kbd>⌘</kbd>+<kbd>0</kbd> | Coding Assistant 열기 (Xcode 26+) — 이전 버전에서는 Navigator 열기/닫기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>0</kbd> | Coding Tools 열기 (Xcode 26+) — 이전 버전에서는 Inspector 열기/닫기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>1 ~ 3</kbd> | Inspector 탭 전환 — 1: File, 2: History, 3: Quick Help |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>Y</kbd> | Debug Area (콘솔·변수 뷰) 열기/닫기 |
| <kbd>⌘</kbd>+<kbd>J</kbd> | 에디터 창 선택 후 포커스 이동 (Move Focus to Editor Pane…) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>↩</kbd> | 현재 에디터 창만 크게 보기 (Focus Editor Pane) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>↩</kbd> | Assistant 에디터 열기/닫기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>↩</kbd> | Canvas 열기/닫기 (SwiftUI 프리뷰) |
| <kbd>⌃</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>M</kbd> | 미니맵 표시/숨기기 (Minimap) |
| <kbd>⌘</kbd>+<kbd>+</kbd> | 에디터 글꼴 확대 |
| <kbd>⌘</kbd>+<kbd>-</kbd> | 에디터 글꼴 축소 |
| <kbd>⌘</kbd>+<kbd>,</kbd> | Settings |

## 디버깅

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌘</kbd>+<kbd>&#92;</kbd> | 현재 줄에 중단점 추가/제거 (Create Breakpoint at Current Line) |
| <kbd>⌘</kbd>+<kbd>Y</kbd> | 모든 중단점 활성/비활성 (Activate/Deactivate Breakpoints) |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>&#92;</kbd> | 심볼릭 중단점 추가 (Create Symbolic Breakpoint) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>Y</kbd> | 일시정지 / 계속 (Pause / Continue) |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>C</kbd> | 현재 줄까지 실행 (Continue To Current Line) |
| <kbd>F6</kbd> | 한 줄 실행 (Step Over) |
| <kbd>F7</kbd> | 함수 안으로 (Step Into) |
| <kbd>F8</kbd> | 함수 밖으로 (Step Out) |
| <kbd>⌃</kbd>+<kbd>F6</kbd> | 명령어 단위 Step Over (Step Over Instruction) |
| <kbd>⌃</kbd>+<kbd>F7</kbd> | 명령어 단위 Step Into (Step Into Instruction) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>M</kbd> | 메모리 보기 (View Memory) |
| <kbd>⌘</kbd>+<kbd>K</kbd> | 콘솔 지우기 (Clear Console) |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>C</kbd> | 콘솔로 포커스 이동 (Activate Console) |

## 문서 & 도움말

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>⌥</kbd>+<kbd>Click</kbd> | 심볼 위에서 Quick Help 팝업 |
| <kbd>⌃</kbd>+<kbd>⌘</kbd>+<kbd>?</kbd> | 선택 항목의 Quick Help 표시 (Show Quick Help for Selected Item) |
| <kbd>⌃</kbd>+<kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>/</kbd> | 선택 텍스트를 Developer Documentation에서 검색 |
| <kbd>⇧</kbd>+<kbd>⌘</kbd>+<kbd>0</kbd> | Developer Documentation 창 열기 |
| <kbd>⌥</kbd>+<kbd>⌘</kbd>+<kbd>?</kbd> | 키보드 힌트 표시 (Show Keyboard Hints) |

## 기타

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>fn</kbd>+<kbd>E</kbd> | 이모지·심볼 입력 (Emoji & Symbols) — 이전 macOS에서는 ⌃⌘Space |
