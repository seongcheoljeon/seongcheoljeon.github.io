---
title: "[Editor/VisualStudio] Visual Assist : Shortcuts"
description: >-
  Visual Assist의 주요 단축키와 생산성을 높이는 핵심 기능을 간단히 정리한다.
author: seongcheol
date: 2026-03-16 01:45:00 +0900
categories: [Editor, VisualStudio]
tags: [Editor, VisualStudio]
pin: true
image:
  path: "/assets/img/common/title/vs_title.jpg"
---

<style>
/* ── 카드 컨테이너 ── */
.va { background:#0d0e11; border-radius:14px; padding:28px 32px 32px; font-family:var(--font-sans, sans-serif); max-width:860px; margin:8px auto; border:1px solid #1e2028; }
.va + .va { margin-top:20px; }

/* ── 카드 타이틀 ── */
.va-title { font-size:20px; font-weight:600; color:#e2e4ec; margin:0 0 20px; display:flex; align-items:center; gap:10px; padding-bottom:16px; border-bottom:1px solid #1e2028; }

/* ── 그리드 (1열) ── */
.va-grid { display:grid; grid-template-columns:1fr; }

/* ── 섹션 헤더 ── */
.va-section { display:flex; align-items:center; font-size:11px; font-weight:700; color:#9ca3af; letter-spacing:.12em; text-transform:uppercase; margin:24px 0 4px; padding:7px 12px; background:#13151a; border-left:3px solid #3b82f6; border-radius:0 6px 6px 0; }

/* ── 단축키 행 ── */
.va-row { display:flex; align-items:center; border-bottom:1px solid #13151a; transition:background .12s; }
.va-row:nth-child(even) { background:#0f1014; }
.va-row:hover { background:#161a22; }

/* ── 키 영역 ── */
.va-key { display:inline-flex; align-items:center; flex-wrap:wrap; gap:4px; flex-shrink:0; width:260px; padding:10px 14px 10px 12px; }

/* ── 키 / 설명 구분 세로선 ── */
.va-divider { width:1px; height:38px; background:#1e2028; flex-shrink:0; margin-right:16px; }

/* ── 설명 텍스트 ── */
.va-desc { font-size:14px; color:#c4c8d4; flex:1; min-width:0; padding:10px 12px 10px 0; line-height:1.5; }

/* ── kbd 키캡 ── */
.va kbd { display:inline-block; background:#1c1f2b; border:1px solid #373d50; border-bottom:2.5px solid #373d50; border-radius:6px; padding:2px 8px; font-size:12px; font-weight:600; color:#dde1f0; white-space:nowrap; line-height:1.7; box-shadow:0 1px 0 #080a0d; }

/* ── + , 구분자 ── */
.va .sep { font-size:11px; color:#4b5263; font-weight:500; padding:0 1px; }

/* ── 핵심 기능 행 ── */
.va-feat-row { display:grid; grid-template-columns:36px 1fr; gap:0 14px; align-items:start; padding:14px 0; border-bottom:1px solid #13151a; transition:background .12s; }
.va-feat-row:nth-child(even) { background:#0f1014; }
.va-feat-row:hover { background:#161a22; }
.va-feat-icon { width:32px; height:32px; border-radius:8px; display:flex; align-items:center; justify-content:center; flex-shrink:0; margin-top:1px; }
.va-feat-body { display:flex; flex-direction:column; gap:4px; }
.va-feat-name { font-size:15px; font-weight:600; color:#e2e4ec; }
.va-feat-desc { font-size:14px; color:#9ca3b4; line-height:1.65; }
.va-feat-kbd { margin-top:6px; }
</style>

<!-- ===== 카드 1 : 단축키 ===== -->
<div class="va">
  <p class="va-title">
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><rect x="2" y="3" width="14" height="2" rx="1" fill="#6b7280"/><rect x="2" y="8" width="10" height="2" rx="1" fill="#6b7280"/><rect x="2" y="13" width="12" height="2" rx="1" fill="#6b7280"/></svg>
    Visual Assist — 단축키
  </p>
  <div class="va-grid">

    <p class="va-section">탐색 · NAVIGATION</p>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="va-divider"></span><span class="va-desc">선언부 ↔ 구현부 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="va-divider"></span><span class="va-desc">관련 심볼로 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="va-divider"></span><span class="va-desc">대응 파일 열기 (.h ↔ .cpp)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="va-divider"></span><span class="va-desc">솔루션 내 파일 빠른 열기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>←</kbd></span><span class="va-divider"></span><span class="va-desc">이전 위치로 뒤로 가기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>→</kbd></span><span class="va-divider"></span><span class="va-desc">다음 위치로 앞으로 가기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↓</kbd></span><span class="va-divider"></span><span class="va-desc">다음 범위로 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↑</kbd></span><span class="va-divider"></span><span class="va-desc">이전 범위로 이동</span></div>

    <p class="va-section">검색 · SEARCH</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>F</kbd></span><span class="va-divider"></span><span class="va-desc">현재 심볼 참조 찾기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="va-divider"></span><span class="va-desc">솔루션 내 심볼 검색</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>K</kbd></span><span class="va-divider"></span><span class="va-desc">커서 단어 인스턴스 강조</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="va-divider"></span><span class="va-desc">파일 내 클래스·메소드 목록</span></div>

    <p class="va-section">편집 · EDIT</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="va-divider"></span><span class="va-desc">심볼 생성 (작업 중)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>R</kbd></span><span class="va-divider"></span><span class="va-desc">심볼 이름 바꾸기 (전체 반영)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Q</kbd></span><span class="va-divider"></span><span class="va-desc">퀵 액션 · 리팩토링 메뉴</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>A</kbd></span><span class="va-divider"></span><span class="va-desc">코드 주석 자동 생성 (Doxygen / XML)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>J</kbd></span><span class="va-divider"></span><span class="va-desc">코드 스니펫 삽입</span></div>
    <div class="va-row"><span class="va-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>V</kbd></span><span class="va-divider"></span><span class="va-desc">클립보드 히스토리 붙여넣기</span></div>

    <p class="va-section">선택 · SELECTION</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="va-divider"></span><span class="va-desc">선택 영역 조금씩 확장</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="va-divider"></span><span class="va-desc">선택 영역 크게 확장</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>[</kbd></span><span class="va-divider"></span><span class="va-desc">선택 영역 조금씩 축소</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>[</kbd></span><span class="va-divider"></span><span class="va-desc">선택 영역 크게 축소</span></div>

    <p class="va-section">기타 · MISC</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="va-divider"></span><span class="va-desc">VA 해쉬태그 창 열기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>0</kbd></span><span class="va-divider"></span><span class="va-desc">에디터 확대 100% 리셋</span></div>

  </div>
</div>

<!-- ===== 카드 2 : 핵심 기능 ===== -->
<div class="va">
  <p class="va-title">
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="7" stroke="#6b7280" stroke-width="1.5"/><path d="M9 6v4l2.5 2.5" stroke="#6b7280" stroke-width="1.5" stroke-linecap="round"/></svg>
    Visual Assist — 핵심 기능
  </p>
  <div class="va-grid">

    <p class="va-section">코드 인텔리전스 · INTELLIGENCE</p>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#1a2236"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><path d="M3 7.5h9M3 4.5h6M3 10.5h7" stroke="#3b82f6" stroke-width="1.4" stroke-linecap="round"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">향상된 IntelliSense</span>
        <span class="va-feat-desc">VA 자체 C++ 파서를 사용해 VS 기본 IntelliSense보다 빠르고 정확한 자동완성을 제공한다. 대규모 프로젝트·UE5 코드베이스에서 특히 체감 차이가 크다.</span>
      </div>
    </div>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#1a2a1e"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="5" cy="5" r="2" fill="#10b981"/><circle cx="10" cy="5" r="2" fill="#f59e0b"/><circle cx="5" cy="10" r="2" fill="#8b5cf6"/><circle cx="10" cy="10" r="2" fill="#ef4444"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">향상된 색상 강조 (Enhanced Colorization)</span>
        <span class="va-feat-desc">지역 변수·멤버 변수·매크로·타입·함수를 역할별로 세밀하게 구분해 착색한다. VS 기본 색상보다 훨씬 많은 구분 기준을 제공하며, VA Options에서 색상을 자유롭게 커스터마이징할 수 있다.</span>
      </div>
    </div>

    <p class="va-section">탐색 · NAVIGATION</p>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#1e1a2e"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="6" cy="6" r="4" stroke="#8b5cf6" stroke-width="1.4"/><path d="M9.5 9.5L13 13" stroke="#8b5cf6" stroke-width="1.4" stroke-linecap="round"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">Find References 패널</span>
        <span class="va-feat-desc">심볼 참조 검색 결과를 인터랙티브 패널로 표시한다. 파일·범위별로 그룹화되며, 클릭 시 즉시 해당 위치로 이동한다. 대규모 리팩토링 전 영향 범위 파악에 유용하다.</span>
        <span class="va-feat-kbd"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>F</kbd></span></span>
      </div>
    </div>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#1a2236"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><rect x="2" y="2" width="4" height="4" rx="1" fill="#3b82f6"/><rect x="2" y="9" width="4" height="4" rx="1" fill="#3b82f6" opacity=".5"/><path d="M8 4h5M8 11h5" stroke="#3b82f6" stroke-width="1.3" stroke-linecap="round"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">VA Outline</span>
        <span class="va-feat-desc">현재 파일의 클래스·함수·멤버를 트리 구조로 탐색한다. 대형 헤더 파일에서 원하는 심볼로 즉시 점프할 수 있다.</span>
        <span class="va-feat-kbd"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd></span></span>
      </div>
    </div>

    <p class="va-section">코드 관리 · CODE MANAGEMENT</p>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#2a1e1e"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><path d="M2 4h11M5 4V2.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 .5.5V4M4 4v8.5a.5.5 0 0 0 .5.5h6a.5.5 0 0 0 .5-.5V4" stroke="#ef4444" stroke-width="1.3" stroke-linecap="round"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">VA Hashtags</span>
        <span class="va-feat-desc">코드 내 <code style="background:#1e2028;padding:1px 5px;border-radius:4px;font-size:11px;color:#c8ccd8">//TODO</code> <code style="background:#1e2028;padding:1px 5px;border-radius:4px;font-size:11px;color:#c8ccd8">//FIXME</code> 또는 커스텀 태그(<code style="background:#1e2028;padding:1px 5px;border-radius:4px;font-size:11px;color:#c8ccd8">#my-tag</code>)를 북마크로 수집해 한곳에서 관리한다. VA Options에서 커스텀 태그를 자유롭게 정의할 수 있다.</span>
        <span class="va-feat-kbd"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>H</kbd></span></span>
      </div>
    </div>

    <div class="va-feat-row">
      <div class="va-feat-icon" style="background:#1a2a1e"><svg width="15" height="15" viewBox="0 0 15 15" fill="none"><path d="M4 2h7l2 2v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V3a1 1 0 0 1 1-1z" stroke="#10b981" stroke-width="1.3"/><path d="M5 7h5M5 9.5h3" stroke="#10b981" stroke-width="1.3" stroke-linecap="round"/></svg></div>
      <div class="va-feat-body">
        <span class="va-feat-name">Document Code (자동 주석 생성)</span>
        <span class="va-feat-desc">함수·클래스 위에서 실행하면 파라미터·반환값이 포함된 Doxygen / XML 주석 템플릿을 자동으로 삽입한다. 기존 주석이 있으면 파라미터 변경분만 갱신한다.</span>
        <span class="va-feat-kbd"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>A</kbd></span></span>
      </div>
    </div>

  </div>
</div>
