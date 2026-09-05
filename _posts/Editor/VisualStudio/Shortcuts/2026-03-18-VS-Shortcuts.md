---
title: "[Editor/VisualStudio] Visual Studio Community : Shortcuts"
description: >-
  Visual Studio 2022의 주요 단축키를 기본 키 바인딩(General 프로필) 기준으로 카테고리별로 정리한다.
author: seongcheol
date: 2026-03-18 13:00:00 +0900
categories: [Editor, VisualStudio]
tags: [Editor, VisualStudio]
pin: false
image:
  path: "/assets/img/common/title/vs_title.png"
---

> Visual Studio 2022 기본 키 바인딩(**General** 프로필) 기준이다. <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>C</kbd> 처럼 쉼표로 구분된 것은 **순서대로 누르는 코드(chord)** 단축키다. 실제 바인딩은 `Tools › Options › Environment › Keyboard` 에서 확인·변경할 수 있다.
{: .prompt-info }

## 자주 쓰는 단축키

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>T</kbd> | 전체로 이동 (Go To All) — 파일·심볼·줄 통합 검색 |
| <kbd>F12</kbd> | 정의로 이동 (Go To Definition) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>O</kbd> | 헤더 ↔ 코드 파일 전환 (.h ↔ .cpp) |
| <kbd>Shift</kbd>+<kbd>F12</kbd> | 모든 참조 찾기 (Find All References) |
| <kbd>Ctrl</kbd>+<kbd>-</kbd> | 이전 위치로 뒤로 가기 |
| <kbd>Ctrl</kbd>+<kbd>.</kbd> | 빠른 작업 및 리팩터링 (Quick Actions) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>R</kbd> | 심볼 이름 바꾸기 (Rename) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>D</kbd> | 전체 문서 코드 포맷 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> | 솔루션 빌드 |
| <kbd>F5</kbd> | 디버그 시작 |
| <kbd>F9</kbd> | 중단점 토글 |
| <kbd>F10</kbd> | 프로시저 단위 실행 (Step Over) |
| <kbd>Ctrl</kbd>+<kbd>Q</kbd> | 빠른 실행 (Quick Launch) — 메뉴·옵션 검색 |

## 빌드 & 프로젝트

### 빌드

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> | 솔루션 빌드 |
| <kbd>Ctrl</kbd>+<kbd>F7</kbd> | 현재 파일만 컴파일 |
| <kbd>Ctrl</kbd>+<kbd>Break</kbd> | 빌드 취소 |
| <kbd>Alt</kbd>+<kbd>F11</kbd> | 솔루션에서 코드 분석 실행 |

### 파일 · 프로젝트

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>N</kbd> | 새 파일 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>N</kbd> | 새 프로젝트 |
| <kbd>Ctrl</kbd>+<kbd>O</kbd> | 파일 열기 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>O</kbd> | 프로젝트 열기 |
| <kbd>Ctrl</kbd>+<kbd>S</kbd> | 현재 파일 저장 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> | 모두 저장 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd> | 새 항목 추가 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>A</kbd> | 기존 항목 추가 |
| <kbd>Alt</kbd>+<kbd>F4</kbd> | Visual Studio 종료 |

### 테스트

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>T</kbd> | 현재 컨텍스트(커서 위치 · 파일)의 테스트 실행 |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>A</kbd> | 모든 테스트 실행 |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>T</kbd> | 현재 컨텍스트의 테스트 디버그 |

## 탐색

### 심볼 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>F12</kbd> | 정의로 이동 (Go To Definition) — C++에서는 선언부(.h)로 이동 |
| <kbd>Ctrl</kbd>+<kbd>F12</kbd> | 선언으로 이동 (Go To Declaration) — 구현부(.cpp)로 직접 이동 |
| <kbd>Alt</kbd>+<kbd>F12</kbd> | 정의 미리보기 (Peek Definition) — 인라인 팝업 |
| <kbd>Shift</kbd>+<kbd>F12</kbd> | 모든 참조 찾기 (Find All References) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>T</kbd> | 호출 계층 구조 보기 (Call Hierarchy) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>O</kbd> | 헤더 ↔ 코드 파일 전환 (.h ↔ .cpp) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Space</kbd> | 매개 변수 정보 (Parameter Info) — 함수 시그니처 힌트 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>I</kbd> | 요약 정보 (Quick Info) — 커서 심볼 타입·문서 표시 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>↓</kbd> | 다음 강조 표시 참조로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>↑</kbd> | 이전 강조 표시 참조로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd> | 커서 아래 파일 이름 열기 |

### 위치 이동

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>T</kbd> | 전체로 이동 (Go To All) — 파일·심볼·줄 통합 검색 |
| <kbd>Ctrl</kbd>+<kbd>,</kbd> | 전체로 이동 (Go To All) — Ctrl+T와 동일 |
| <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>Ctrl</kbd>+<kbd>F</kbd> | 파일로 이동 (Go To File) |
| <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>Ctrl</kbd>+<kbd>T</kbd> | 형식으로 이동 (Go To Type) |
| <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>Ctrl</kbd>+<kbd>S</kbd> | 심볼로 이동 (Go To Symbol) |
| <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>Ctrl</kbd>+<kbd>M</kbd> | 멤버로 이동 (Go To Member) |
| <kbd>Ctrl</kbd>+<kbd>G</kbd> | 줄 번호로 이동 |
| <kbd>Ctrl</kbd>+<kbd>]</kbd> | 매칭 중괄호로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>]</kbd> | 매칭 중괄호까지 선택 확장 |
| <kbd>Ctrl</kbd>+<kbd>-</kbd> | 이전 위치로 뒤로 가기 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>-</kbd> | 다음 위치로 앞으로 가기 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Backspace</kbd> | 마지막 편집 위치로 이동 |

## 편집

### 자동완성 · 빠른 작업

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 단어 자동 완성 (IntelliSense 수동 호출) |
| <kbd>Ctrl</kbd>+<kbd>J</kbd> | 멤버 나열 (List Members) |
| <kbd>Ctrl</kbd>+<kbd>.</kbd> | 빠른 작업 및 리팩터링 (Quick Actions) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>X</kbd> | 코드 스니펫 삽입 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>S</kbd> | 선택 코드를 스니펫으로 감싸기 (VS 2019 이하) |

### 기본 편집

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Z</kbd> | 실행 취소 |
| <kbd>Ctrl</kbd>+<kbd>Y</kbd> | 다시 실행 |
| <kbd>Ctrl</kbd>+<kbd>C</kbd> | 복사 |
| <kbd>Ctrl</kbd>+<kbd>X</kbd> | 잘라내기 |
| <kbd>Ctrl</kbd>+<kbd>V</kbd> | 붙여넣기 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> | 클립보드 링 순환 붙여넣기 |
| <kbd>Ctrl</kbd>+<kbd>D</kbd> | 현재 줄 복제 |
| <kbd>Ctrl</kbd>+<kbd>L</kbd> | 줄 잘라내기 — 클립보드로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>L</kbd> | 줄 삭제 |
| <kbd>Ctrl</kbd>+<kbd>Delete</kbd> | 커서 위치부터 단어 끝까지 삭제 |
| <kbd>Ctrl</kbd>+<kbd>Backspace</kbd> | 커서 위치부터 단어 시작까지 삭제 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> | 단어 바꾸기 (Word Transpose) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>&#92;</kbd> | 가로 공백 삭제 |

### 줄 조작

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Alt</kbd>+<kbd>↑</kbd> | 선택한 줄을 위로 이동 |
| <kbd>Alt</kbd>+<kbd>↓</kbd> | 선택한 줄을 아래로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Enter</kbd> | 현재 줄 위에 빈 줄 삽입 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Enter</kbd> | 현재 줄 아래에 빈 줄 삽입 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd> | 현재 줄과 아래 줄 교체 (Line Transpose) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>U</kbd> | 선택 영역 대문자 변환 |
| <kbd>Ctrl</kbd>+<kbd>U</kbd> | 선택 영역 소문자 변환 |

### 선택 · 멀티 캐럿

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>A</kbd> | 전체 선택 |
| <kbd>Ctrl</kbd>+<kbd>W</kbd> | 현재 단어 선택 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>]</kbd> | 포함하는 블록으로 선택 영역 확장 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>=</kbd> | 선택 영역 확장 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>-</kbd> | 선택 영역 축소 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>↑↓←→</kbd> | 열(Column) 선택 — 박스 선택 모드 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>.</kbd> | 일치하는 다음 항목에 캐럿 추가 (Multi-caret) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>;</kbd> | 일치하는 모든 항목에 캐럿 추가 (Multi-caret) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Click</kbd> | 클릭 위치에 캐럿 추가 (Multi-caret) |
| <kbd>Esc</kbd> | 멀티 캐럿 해제 — 단일 커서로 복귀 |

### 주석 · 포맷

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>C</kbd> | 선택 영역 주석 처리 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>U</kbd> | 선택 영역 주석 해제 |
| <kbd>Ctrl</kbd>+<kbd>/</kbd> | 줄 주석 토글 (VS 2022 17.11+) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>D</kbd> | 전체 문서 코드 포맷 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>F</kbd> | 선택 영역 코드 포맷 |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>G</kbd> | using 제거 및 정렬 |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>W</kbd> | 공백 문자 표시 / 숨기기 |
| <kbd>Ctrl</kbd>+<kbd>E</kbd>, <kbd>Ctrl</kbd>+<kbd>W</kbd> | 자동 줄 바꿈 토글 (Word Wrap) |

### 리팩터링

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>R</kbd> | 심볼 이름 바꾸기 (Rename) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>M</kbd> | 메서드 추출 (Extract Method) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>E</kbd> | 필드 캡슐화 (Encapsulate Field) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>I</kbd> | 인터페이스 추출 (Extract Interface) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>V</kbd> | 매개 변수 제거 (Remove Parameter) |
| <kbd>Ctrl</kbd>+<kbd>R</kbd>, <kbd>Ctrl</kbd>+<kbd>O</kbd> | 매개 변수 다시 정렬 (Reorder Parameters) |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>M</kbd> | 메서드 생성 (Generate Method) |

### 코드 접기

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>M</kbd> | 현재 블록 접기 / 펼치기 토글 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>O</kbd> | 정의 부분만 보이기 — 전체 정의 축소 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>A</kbd> | 전체 개요 축소 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>X</kbd> | 전체 개요 확장 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>L</kbd> | 전체 개요 영역 표시 / 숨기기 토글 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>S</kbd> | 현재 영역만 축소 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>E</kbd> | 현재 영역만 확장 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>H</kbd> | 선택 영역 숨기기 (Custom region) |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>U</kbd> | 현재 숨기기 중지 |
| <kbd>Ctrl</kbd>+<kbd>M</kbd>, <kbd>Ctrl</kbd>+<kbd>P</kbd> | 개요 표시 중지 (Outlining 비활성화) |

### 책갈피

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>K</kbd> | 책갈피 토글 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>N</kbd> | 다음 책갈피로 이동 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>P</kbd> | 이전 책갈피로 이동 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>L</kbd> | 모든 책갈피 지우기 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>W</kbd> | 책갈피 창 열기 |
| <kbd>Ctrl</kbd>+<kbd>K</kbd>, <kbd>Ctrl</kbd>+<kbd>H</kbd> | 작업 목록 바로 가기 토글 (Task List) |

## 검색

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>F</kbd> | 찾기 |
| <kbd>Ctrl</kbd>+<kbd>H</kbd> | 찾기 / 바꾸기 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F</kbd> | 파일에서 찾기 (전체 솔루션) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>H</kbd> | 파일에서 바꾸기 (전체 솔루션) |
| <kbd>F3</kbd> | 다음 찾기 |
| <kbd>Shift</kbd>+<kbd>F3</kbd> | 이전 찾기 |
| <kbd>Ctrl</kbd>+<kbd>F3</kbd> | 선택 단어로 다음 찾기 |
| <kbd>Ctrl</kbd>+<kbd>I</kbd> | 증분 검색 (Incremental Search) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd> | 역방향 증분 검색 |
| <kbd>F8</kbd> | 다음 오류 / 검색 결과로 이동 |
| <kbd>Shift</kbd>+<kbd>F8</kbd> | 이전 오류 / 검색 결과로 이동 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F12</kbd> | 다음 오류로 이동 |

## 디버깅

### 실행

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>F5</kbd> | 디버그 시작 |
| <kbd>Ctrl</kbd>+<kbd>F5</kbd> | 디버그 없이 시작 |
| <kbd>Shift</kbd>+<kbd>F5</kbd> | 디버깅 중지 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F5</kbd> | 디버그 다시 시작 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Break</kbd> | 모두 중단 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> | 프로세스에 연결 |
| <kbd>Alt</kbd>+<kbd>F2</kbd> | 성능 프로파일러 (Performance Profiler) |

### 스테핑

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>F10</kbd> | 프로시저 단위 실행 (Step Over) |
| <kbd>F11</kbd> | 한 단계씩 코드 실행 (Step Into) |
| <kbd>Shift</kbd>+<kbd>F11</kbd> | 프로시저 나가기 (Step Out) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F11</kbd> | 특정 함수로 한 단계 실행 (Step Into Specific) — 중첩 호출 중 하나 선택 |
| <kbd>Ctrl</kbd>+<kbd>F10</kbd> | 커서까지 실행 (Run To Cursor) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F10</kbd> | 다음 문 설정 (Set Next Statement) |
| <kbd>Alt</kbd>+<kbd>Num &#42;</kbd> | 다음 문 표시 (Show Next Statement) |
| <kbd>Alt</kbd>+<kbd>F10</kbd> | 코드 변경 내용 적용 (Edit and Continue) |

### 중단점

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>F9</kbd> | 중단점 토글 |
| <kbd>Ctrl</kbd>+<kbd>F9</kbd> | 중단점 사용 / 사용 안 함 토글 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F9</kbd> | 모든 중단점 삭제 |
| <kbd>Alt</kbd>+<kbd>F9</kbd>, <kbd>C</kbd> | 중단점 조건 설정 |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F9</kbd>, <kbd>T</kbd> | 임시 중단점 삽입 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>B</kbd> | 중단점 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>E</kbd> | 예외 설정 창 |

### 디버그 창

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>V</kbd>, <kbd>A</kbd> | 자동 변수 창 (Autos) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>V</kbd>, <kbd>L</kbd> | 지역 변수 창 (Locals) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>W</kbd>, <kbd>1</kbd> | 조사식 1 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>W</kbd>, <kbd>2</kbd> | 조사식 2 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>W</kbd>, <kbd>3</kbd> | 조사식 3 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>W</kbd>, <kbd>4</kbd> | 조사식 4 창 |
| <kbd>Shift</kbd>+<kbd>F9</kbd> | 간략한 조사식 (Quick Watch) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>I</kbd> | 직접 실행 창 (Immediate Window) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>C</kbd> | 호출 스택 창 (Call Stack) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>H</kbd> | 스레드 창 (Threads) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>G</kbd> | 레지스터 창 (Registers) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>D</kbd> | 디스어셈블리 창 (Disassembly) |
| <kbd>Ctrl</kbd>+<kbd>F11</kbd> | 디스어셈블리 보기 토글 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>M</kbd>, <kbd>1</kbd> | 메모리 1 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>M</kbd>, <kbd>2</kbd> | 메모리 2 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>M</kbd>, <kbd>3</kbd> | 메모리 3 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>M</kbd>, <kbd>4</kbd> | 메모리 4 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>U</kbd> | 모듈 창 (Modules) |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Z</kbd> | 프로세스 창 (Processes) |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>D</kbd>, <kbd>S</kbd> | 병렬 스택 창 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>D</kbd>, <kbd>K</kbd> | 작업 창 (Tasks) |

## 창 & 보기

### 창 관리

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | 열린 탭 전환 (IDE Navigator) |
| <kbd>Ctrl</kbd>+<kbd>F4</kbd> | 현재 탭 닫기 |
| <kbd>Ctrl</kbd>+<kbd>F6</kbd> | 다음 문서 창 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F6</kbd> | 이전 문서 창 |
| <kbd>Ctrl</kbd>+<kbd>PgDn</kbd> | 다음 탭 |
| <kbd>Ctrl</kbd>+<kbd>PgUp</kbd> | 이전 탭 |
| <kbd>F6</kbd> | 다음 분할 창 |
| <kbd>Alt</kbd>+<kbd>F7</kbd> | 다음 도구 창으로 이동 |
| <kbd>Shift</kbd>+<kbd>Esc</kbd> | 도구 창 닫기 |
| <kbd>Ctrl</kbd>+<kbd>Q</kbd> | 빠른 실행 (Quick Launch) |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Enter</kbd> | 전체 화면 토글 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>.</kbd> | 에디터 글꼴 확대 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>,</kbd> | 에디터 글꼴 축소 |
| <kbd>F7</kbd> | 코드 뷰로 전환 |
| <kbd>Shift</kbd>+<kbd>F7</kbd> | 디자이너 뷰로 전환 |

### 도구 창

| 단축키 | 동작 |
| :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>L</kbd> | 솔루션 탐색기 |
| <kbd>Ctrl</kbd>+<kbd>;</kbd> | 솔루션 탐색기 검색 |
| <kbd>Ctrl</kbd>+<kbd>[</kbd>, <kbd>S</kbd> | 솔루션 탐색기에서 현재 문서 선택 (Sync with Active Document) |
| <kbd>Ctrl</kbd>+<kbd>&#92;</kbd>, <kbd>Ctrl</kbd>+<kbd>E</kbd> | 오류 목록 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>O</kbd> | 출력 창 |
| <kbd>F4</kbd> | 속성 창 |
| <kbd>Shift</kbd>+<kbd>F4</kbd> | 속성 페이지 |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>C</kbd> | 클래스 뷰 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>J</kbd> | 개체 브라우저 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>K</kbd> | 호출 계층 구조 창 |
| <kbd>Ctrl</kbd>+<kbd>&#92;</kbd>, <kbd>D</kbd> | 코드 정의 창 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>X</kbd> | 도구 상자 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> | 서버 탐색기 |
| <kbd>Ctrl</kbd>+<kbd>&#92;</kbd>, <kbd>T</kbd> | 작업 목록 |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>A</kbd> | 명령 창 |
