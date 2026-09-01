---
title: "[Editor/VisualStudio] Visual Studio Community : Shortcuts"
description: >-
  Visual Studio Community의 주요 단축키를 Microsoft 공식 문서 기반으로 카테고리별로 정리한다.
author: seongcheol
date: 2026-03-18 13:00:00 +0900
categories: [Editor, VisualStudio]
tags: [Editor, VisualStudio]
pin: false
image:
  path: "/assets/img/common/title/vs_title.png"
---

<style>
/* ── 카드 컨테이너 ── */
.vs { background:#0d0e11; border-radius:14px; padding:28px 32px 32px; font-family:var(--font-sans, sans-serif); max-width:860px; margin:8px auto; border:1px solid #1e2028; }
.vs + .vs { margin-top:20px; }

/* ── 카드 타이틀 ── */
.vs-title { font-size:20px; font-weight:600; color:#e2e4ec; margin:0 0 20px; display:flex; align-items:center; gap:10px; padding-bottom:16px; border-bottom:1px solid #1e2028; }

/* ── 그리드 (1열) ── */
.vs-grid { display:grid; grid-template-columns:1fr; }

/* ── 섹션 헤더 ── */
.vs-section { display:flex; align-items:center; font-size:11px; font-weight:700; color:#9ca3af; letter-spacing:.12em; text-transform:uppercase; margin:24px 0 4px; padding:7px 12px; background:#13151a; border-left:3px solid #3b82f6; border-radius:0 6px 6px 0; }

/* ── 단축키 행 ── */
.vs-row { display:flex; align-items:center; border-bottom:1px solid #13151a; transition:background .12s; }
.vs-row:nth-child(even) { background:#0f1014; }
.vs-row:hover { background:#161a22; }

/* ── 키 영역 ── */
.vs-key { display:inline-flex; align-items:center; flex-wrap:wrap; gap:4px; flex-shrink:0; width:260px; padding:10px 14px 10px 12px; }

/* ── 키 / 설명 구분 세로선 ── */
.vs-divider { width:1px; height:38px; background:#1e2028; flex-shrink:0; margin-right:16px; }

/* ── 설명 텍스트 ── */
.vs-desc { font-size:14px; color:#c4c8d4; flex:1; min-width:0; padding:10px 12px 10px 0; line-height:1.5; }

/* ── kbd 키캡 ── */
.vs kbd { display:inline-block; background:#1c1f2b; border:1px solid #373d50; border-bottom:2.5px solid #373d50; border-radius:6px; padding:2px 8px; font-size:12px; font-weight:600; color:#dde1f0; white-space:nowrap; line-height:1.7; box-shadow:0 1px 0 #080a0d; }

/* ── + , 구분자 ── */
.vs .sep { font-size:11px; color:#4b5263; font-weight:500; padding:0 1px; }
</style>

<!-- ===== 카드 1 : 빌드 / 파일 / 프로젝트 ===== -->
<div class="vs">
  <p class="vs-title">
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><rect x="2" y="3" width="14" height="2" rx="1" fill="#6b7280"/><rect x="2" y="8" width="10" height="2" rx="1" fill="#6b7280"/><rect x="2" y="13" width="12" height="2" rx="1" fill="#6b7280"/></svg>
    Visual Studio Community — 단축키
  </p>
  <div class="vs-grid">

    <p class="vs-section">빌드 · BUILD</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>B</kbd></span><span class="vs-divider"></span><span class="vs-desc">솔루션 빌드</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F7</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 파일만 컴파일</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Break</kbd></span><span class="vs-divider"></span><span class="vs-desc">빌드 취소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F11</kbd></span><span class="vs-divider"></span><span class="vs-desc">솔루션에서 코드 분석 실행</span></div>

    <p class="vs-section">파일 · FILE</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>N</kbd></span><span class="vs-divider"></span><span class="vs-desc">새 파일</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>N</kbd></span><span class="vs-divider"></span><span class="vs-desc">새 프로젝트</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">파일 열기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">프로젝트 열기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 파일 저장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">모두 저장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F4</kbd></span><span class="vs-divider"></span><span class="vs-desc">Visual Studio 종료</span></div>

    <p class="vs-section">프로젝트 · PROJECT</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">새 항목 추가</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">기존 항목 추가</span></div>

  </div>
</div>

<!-- ===== 카드 2 : 탐색 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">탐색 · NAVIGATION</p>
    <div class="vs-row"><span class="vs-key"><kbd>F12</kbd></span><span class="vs-divider"></span><span class="vs-desc">정의로 이동 (Go To Definition) — C++에서는 선언부(.h)로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F12</kbd></span><span class="vs-divider"></span><span class="vs-desc">선언으로 이동 (Go To Declaration) — 구현부(.cpp)로 직접 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F12</kbd></span><span class="vs-divider"></span><span class="vs-desc">정의 미리보기 (Peek Definition) — 인라인 팝업</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F12</kbd></span><span class="vs-divider"></span><span class="vs-desc">모든 참조 찾기 (Find All References)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">호출 계층 구조 보기 (Call Hierarchy)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">헤더 ↔ 코드 파일 전환 (.h ↔ .cpp)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체로 이동 (Go To All) — 파일·심볼·줄 통합 검색</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>1</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="vs-divider"></span><span class="vs-desc">멤버로 이동 (Go To Member)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="vs-divider"></span><span class="vs-desc">줄 번호로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="vs-divider"></span><span class="vs-desc">매칭 중괄호로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="vs-divider"></span><span class="vs-desc">매칭 중괄호까지 선택 확장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>-</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 위치로 뒤로 가기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>-</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 위치로 앞으로 가기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>Backspace</kbd></span><span class="vs-divider"></span><span class="vs-desc">마지막 편집 위치로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>Space</kbd></span><span class="vs-divider"></span><span class="vs-desc">매개 변수 정보 (Parameter Info) — 함수 시그니처 힌트</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>I</kbd></span><span class="vs-divider"></span><span class="vs-desc">요약 정보 (Quick Info) — 커서 심볼 타입·문서 표시</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="vs-divider"></span><span class="vs-desc">커서 아래 파일 이름 열기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>↓</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 강조 표시 참조로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>↑</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 강조 표시 참조로 이동</span></div>

  </div>
</div>

<!-- ===== 카드 3 : 편집 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">편집 · EDIT</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Space</kbd></span><span class="vs-divider"></span><span class="vs-desc">단어 자동 완성 (IntelliSense 수동 호출)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>J</kbd></span><span class="vs-divider"></span><span class="vs-desc">멤버 나열 (List Members)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>.</kbd></span><span class="vs-divider"></span><span class="vs-desc">빠른 작업 및 리팩터링 (Quick Actions)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Z</kbd></span><span class="vs-divider"></span><span class="vs-desc">실행 취소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Y</kbd></span><span class="vs-divider"></span><span class="vs-desc">다시 실행</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="vs-divider"></span><span class="vs-desc">복사</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>X</kbd></span><span class="vs-divider"></span><span class="vs-desc">잘라내기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>V</kbd></span><span class="vs-divider"></span><span class="vs-desc">붙여넣기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>V</kbd></span><span class="vs-divider"></span><span class="vs-desc">클립보드 링 순환 붙여넣기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>D</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 줄 복제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">줄 잘라내기 — 클립보드로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">줄 삭제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 주석 처리</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>U</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 주석 해제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>/</kbd></span><span class="vs-divider"></span><span class="vs-desc">줄 주석 토글 (VS 2022 17.11+)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>D</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 문서 코드 포맷</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 코드 포맷</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>X</kbd></span><span class="vs-divider"></span><span class="vs-desc">코드 스니펫 삽입</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 코드를 스니펫으로 감싸기 (VS 2019 이하)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>\</kbd></span><span class="vs-divider"></span><span class="vs-desc">가로 공백 삭제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="vs-divider"></span><span class="vs-desc">using 제거 및 정렬</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Delete</kbd></span><span class="vs-divider"></span><span class="vs-desc">커서 위치부터 단어 끝까지 삭제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Backspace</kbd></span><span class="vs-divider"></span><span class="vs-desc">커서 위치부터 단어 시작까지 삭제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">단어 바꾸기 (Word Transpose)</span></div>

    <p class="vs-section">줄 조작 · LINE MANIPULATION</p>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↑</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택한 줄을 위로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↓</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택한 줄을 아래로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Enter</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 줄 위에 빈 줄 삽입</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>Enter</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 줄 아래에 빈 줄 삽입</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 줄과 아래 줄 교체 (Line Transpose)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>U</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 대문자 변환</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>U</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 소문자 변환</span></div>

  </div>
</div>

<!-- ===== 카드 4 : 선택 / 검색 / 리팩터링 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">선택 · SELECTION</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 선택</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>W</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 단어 선택</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="vs-divider"></span><span class="vs-desc">포함하는 블록으로 선택 영역 확장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>=</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 확장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>-</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 축소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>↑↓←→</kbd></span><span class="vs-divider"></span><span class="vs-desc">열(Column) 선택 — 박스 선택 모드</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>.</kbd></span><span class="vs-divider"></span><span class="vs-desc">일치하는 다음 항목에 캐럿 추가 (Multi-caret)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>;</kbd></span><span class="vs-divider"></span><span class="vs-desc">일치하는 모든 항목에 캐럿 추가 (Multi-caret)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Click</kbd></span><span class="vs-divider"></span><span class="vs-desc">클릭 위치에 캐럿 추가 (Multi-caret)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Esc</kbd></span><span class="vs-divider"></span><span class="vs-desc">멀티 캐럿 해제 — 단일 커서로 복귀</span></div>

    <p class="vs-section">검색 · SEARCH</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F</kbd></span><span class="vs-divider"></span><span class="vs-desc">찾기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="vs-divider"></span><span class="vs-desc">찾기 / 바꾸기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F</kbd></span><span class="vs-divider"></span><span class="vs-desc">파일에서 찾기 (전체 솔루션)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="vs-divider"></span><span class="vs-desc">파일에서 바꾸기 (전체 솔루션)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F3</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 찾기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F3</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 찾기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F3</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 단어로 다음 찾기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>I</kbd></span><span class="vs-divider"></span><span class="vs-desc">증분 검색 (Incremental Search)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>I</kbd></span><span class="vs-divider"></span><span class="vs-desc">역방향 증분 검색</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F8</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 오류 / 검색 결과로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F8</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 오류 / 검색 결과로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F12</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 오류로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>W</kbd></span><span class="vs-divider"></span><span class="vs-desc">공백 문자 표시 / 숨기기</span></div>

    <p class="vs-section">리팩터링 · REFACTORING</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd></span><span class="vs-divider"></span><span class="vs-desc">심볼 이름 바꾸기 (Rename)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="vs-divider"></span><span class="vs-desc">메서드 추출 (Extract Method)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>E</kbd></span><span class="vs-divider"></span><span class="vs-desc">필드 캡슐화 (Encapsulate Field)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>I</kbd></span><span class="vs-divider"></span><span class="vs-desc">인터페이스 추출 (Extract Interface)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>V</kbd></span><span class="vs-divider"></span><span class="vs-desc">매개 변수 제거 (Remove Parameter)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>R</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">매개 변수 다시 정렬 (Reorder Parameters)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="vs-divider"></span><span class="vs-desc">메서드 생성 (Generate Method)</span></div>

  </div>
</div>

<!-- ===== 카드 5 : 코드 접기 / 책갈피 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">코드 접기 · CODE FOLDING</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 블록 접기 / 펼치기 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">정의 부분만 보이기 — 전체 정의 축소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 개요 축소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>X</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 개요 확장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 개요 영역 표시 / 숨기기 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 영역만 축소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>E</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 영역만 확장</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="vs-divider"></span><span class="vs-desc">선택 영역 숨기기 (Custom region)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>U</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 숨기기 중지</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>P</kbd></span><span class="vs-divider"></span><span class="vs-desc">개요 표시 중지 (Outlining 비활성화)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>E</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>W</kbd></span><span class="vs-divider"></span><span class="vs-desc">자동 줄 바꿈 토글 (Word Wrap)</span></div>

    <p class="vs-section">책갈피 · BOOKMARK</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd></span><span class="vs-divider"></span><span class="vs-desc">책갈피 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>N</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 책갈피로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>P</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 책갈피로 이동</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">모든 책갈피 지우기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>W</kbd></span><span class="vs-divider"></span><span class="vs-desc">책갈피 창 열기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>K</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="vs-divider"></span><span class="vs-desc">작업 목록 바로 가기 토글 (Task List)</span></div>

  </div>
</div>

<!-- ===== 카드 6 : 디버그 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">디버그 실행 · DEBUG RUN</p>
    <div class="vs-row"><span class="vs-key"><kbd>F5</kbd></span><span class="vs-divider"></span><span class="vs-desc">디버그 시작</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F5</kbd></span><span class="vs-divider"></span><span class="vs-desc">디버그 없이 시작</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F5</kbd></span><span class="vs-divider"></span><span class="vs-desc">디버깅 중지</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F5</kbd></span><span class="vs-divider"></span><span class="vs-desc">디버그 다시 시작</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Break</kbd></span><span class="vs-divider"></span><span class="vs-desc">모두 중단</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>P</kbd></span><span class="vs-divider"></span><span class="vs-desc">프로세스에 연결</span></div>

    <p class="vs-section">디버그 스테핑 · DEBUG STEPPING</p>
    <div class="vs-row"><span class="vs-key"><kbd>F10</kbd></span><span class="vs-divider"></span><span class="vs-desc">프로시저 단위 실행 (Step Over)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F11</kbd></span><span class="vs-divider"></span><span class="vs-desc">한 단계씩 코드 실행 (Step Into)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F11</kbd></span><span class="vs-divider"></span><span class="vs-desc">프로시저 나가기 (Step Out)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F10</kbd></span><span class="vs-divider"></span><span class="vs-desc">커서까지 실행 (Run To Cursor)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F10</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 문 설정 (Set Next Statement)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>Num</kbd><span class="sep"> </span><kbd>*</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 문 표시 (Show Next Statement)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F10</kbd></span><span class="vs-divider"></span><span class="vs-desc">코드 변경 내용 적용 (Edit and Continue)</span></div>

    <p class="vs-section">중단점 · BREAKPOINT</p>
    <div class="vs-row"><span class="vs-key"><kbd>F9</kbd></span><span class="vs-divider"></span><span class="vs-desc">중단점 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F9</kbd></span><span class="vs-divider"></span><span class="vs-desc">중단점 사용 / 사용 안 함 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F9</kbd></span><span class="vs-divider"></span><span class="vs-desc">모든 중단점 삭제</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F9</kbd><span class="sep">,</span><kbd>C</kbd></span><span class="vs-divider"></span><span class="vs-desc">중단점 조건 설정</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>F9</kbd><span class="sep">,</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">임시 중단점 삽입</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>B</kbd></span><span class="vs-divider"></span><span class="vs-desc">중단점 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>E</kbd></span><span class="vs-divider"></span><span class="vs-desc">예외 설정 창</span></div>

    <p class="vs-section">디버그 창 · DEBUG WINDOWS</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>V</kbd><span class="sep">,</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">자동 변수 창 (Autos)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>V</kbd><span class="sep">,</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">지역 변수 창 (Locals)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>W</kbd><span class="sep">,</span><kbd>1</kbd></span><span class="vs-divider"></span><span class="vs-desc">조사식 1 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>W</kbd><span class="sep">,</span><kbd>2</kbd></span><span class="vs-divider"></span><span class="vs-desc">조사식 2 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>W</kbd><span class="sep">,</span><kbd>3</kbd></span><span class="vs-divider"></span><span class="vs-desc">조사식 3 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>W</kbd><span class="sep">,</span><kbd>4</kbd></span><span class="vs-divider"></span><span class="vs-desc">조사식 4 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F9</kbd></span><span class="vs-divider"></span><span class="vs-desc">간략한 조사식 (Quick Watch)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>I</kbd></span><span class="vs-divider"></span><span class="vs-desc">직접 실행 창 (Immediate Window)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="vs-divider"></span><span class="vs-desc">호출 스택 창 (Call Stack)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="vs-divider"></span><span class="vs-desc">스레드 창 (Threads)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="vs-divider"></span><span class="vs-desc">레지스터 창 (Registers)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>D</kbd></span><span class="vs-divider"></span><span class="vs-desc">디스어셈블리 창 (Disassembly)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>1</kbd></span><span class="vs-divider"></span><span class="vs-desc">메모리 1 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>2</kbd></span><span class="vs-divider"></span><span class="vs-desc">메모리 2 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>3</kbd></span><span class="vs-divider"></span><span class="vs-desc">메모리 3 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd><span class="sep">,</span><kbd>4</kbd></span><span class="vs-divider"></span><span class="vs-desc">메모리 4 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>U</kbd></span><span class="vs-divider"></span><span class="vs-desc">모듈 창 (Modules)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Z</kbd></span><span class="vs-divider"></span><span class="vs-desc">프로세스 창 (Processes)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>D</kbd><span class="sep">,</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">병렬 스택 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>D</kbd><span class="sep">,</span><kbd>K</kbd></span><span class="vs-divider"></span><span class="vs-desc">작업 창 (Tasks)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F11</kbd></span><span class="vs-divider"></span><span class="vs-desc">디스어셈블리 보기 토글</span></div>

  </div>
</div>

<!-- ===== 카드 7 : 창 관리 / 보기 ===== -->
<div class="vs">
  <div class="vs-grid">

    <p class="vs-section">창 관리 · WINDOW</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Tab</kbd></span><span class="vs-divider"></span><span class="vs-desc">열린 탭 전환 (IDE Navigator)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F4</kbd></span><span class="vs-divider"></span><span class="vs-desc">현재 탭 닫기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>F6</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 문서 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>F6</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 문서 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>PgDn</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 탭</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>PgUp</kbd></span><span class="vs-divider"></span><span class="vs-desc">이전 탭</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Esc</kbd></span><span class="vs-divider"></span><span class="vs-desc">도구 창 닫기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F6</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 분할 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Q</kbd></span><span class="vs-divider"></span><span class="vs-desc">빠른 실행 (Quick Launch)</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>F7</kbd></span><span class="vs-divider"></span><span class="vs-desc">다음 도구 창으로 이동</span></div>

    <p class="vs-section">보기 · VIEW</p>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>L</kbd></span><span class="vs-divider"></span><span class="vs-desc">솔루션 탐색기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>\\</kbd><span class="sep">,</span><kbd>Ctrl</kbd><span class="sep">+</span><kbd>E</kbd></span><span class="vs-divider"></span><span class="vs-desc">오류 목록</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="vs-divider"></span><span class="vs-desc">출력 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F4</kbd></span><span class="vs-divider"></span><span class="vs-desc">속성 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F4</kbd></span><span class="vs-divider"></span><span class="vs-desc">속성 페이지</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="vs-divider"></span><span class="vs-desc">클래스 뷰</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>J</kbd></span><span class="vs-divider"></span><span class="vs-desc">개체 브라우저</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>K</kbd></span><span class="vs-divider"></span><span class="vs-desc">호출 계층 구조 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>\\</kbd><span class="sep">,</span><kbd>D</kbd></span><span class="vs-divider"></span><span class="vs-desc">코드 정의 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>X</kbd></span><span class="vs-divider"></span><span class="vs-desc">도구 상자</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="vs-divider"></span><span class="vs-desc">서버 탐색기</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>\\</kbd><span class="sep">,</span><kbd>T</kbd></span><span class="vs-divider"></span><span class="vs-desc">작업 목록</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="vs-divider"></span><span class="vs-desc">명령 창</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Enter</kbd></span><span class="vs-divider"></span><span class="vs-desc">전체 화면 토글</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>.</kbd></span><span class="vs-divider"></span><span class="vs-desc">에디터 글꼴 확대</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>,</kbd></span><span class="vs-divider"></span><span class="vs-desc">에디터 글꼴 축소</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>F7</kbd></span><span class="vs-divider"></span><span class="vs-desc">코드 뷰로 전환</span></div>
    <div class="vs-row"><span class="vs-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>F7</kbd></span><span class="vs-divider"></span><span class="vs-desc">디자이너 뷰로 전환</span></div>

  </div>
</div>
