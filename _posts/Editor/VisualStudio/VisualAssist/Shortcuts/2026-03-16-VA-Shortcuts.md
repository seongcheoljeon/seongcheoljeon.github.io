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
.va { background:#0d0e11; border-radius:12px; padding:24px 28px 28px; font-family:var(--font-sans, sans-serif); max-width:760px; margin:8px auto; border:0.5px solid #1c1e24; }
.va-title { font-size:18px; font-weight:500; color:#e2e4ec; margin:0 0 20px; display:flex; align-items:center; gap:10px; }
.va-grid { display:grid; grid-template-columns:1fr 1fr; gap:0 28px; }
.va-section { font-size:11px; font-weight:500; color:#6b7280; letter-spacing:.09em; margin:18px 0 8px; grid-column:1/-1; }
.va-row { display:flex; align-items:center; gap:10px; padding:9px 0; border-bottom:.5px dashed #1e2028; }
.va-desc { font-size:13px; color:#b0b4c4; flex:1; min-width:0; }
.va-key { display:inline-flex; align-items:center; gap:3px; flex-shrink:0; }
.va kbd { background:#161820; border:1px solid #2a2d38; border-bottom:2px solid #2a2d38; border-radius:6px; padding:2px 7px; font-size:11px; font-weight:500; color:#c8ccd8; white-space:nowrap; line-height:1.6; }
.va .sep { font-size:10px; color:#3a3e4a; }
</style>

<div class="va">
  <p class="va-title">
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><rect x="2" y="3" width="14" height="2" rx="1" fill="#6b7280"/><rect x="2" y="8" width="10" height="2" rx="1" fill="#6b7280"/><rect x="2" y="13" width="12" height="2" rx="1" fill="#6b7280"/></svg>
    Visual Assist — 단축키
  </p>
  <div class="va-grid">

    <p class="va-section">탐색 · NAVIGATION</p>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="va-desc">선언부 ↔ 구현부 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>G</kbd></span><span class="va-desc">관련 심볼로 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="va-desc">대응 파일 열기 (.h ↔ .cpp)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>O</kbd></span><span class="va-desc">솔루션 내 파일 빠른 열기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>←</kbd></span><span class="va-desc">이전 위치로 뒤로 가기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>→</kbd></span><span class="va-desc">다음 위치로 앞으로 가기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↓</kbd></span><span class="va-desc">다음 범위로 이동</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>↑</kbd></span><span class="va-desc">이전 범위로 이동</span></div>

    <p class="va-section">검색 · SEARCH</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>F</kbd></span><span class="va-desc">현재 심볼 참조 찾기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>S</kbd></span><span class="va-desc">솔루션 내 심볼 검색</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>K</kbd></span><span class="va-desc">커서 단어 인스턴스 강조</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>M</kbd></span><span class="va-desc">파일 내 클래스·메소드 목록</span></div>

    <p class="va-section">편집 · EDIT</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>C</kbd></span><span class="va-desc">심볼 생성 (작업 중)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>R</kbd></span><span class="va-desc">심볼 이름 바꾸기 (전체 반영)</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>Q</kbd></span><span class="va-desc">퀵 액션 · 리팩토링 메뉴</span></div>
    <div class="va-row"><span class="va-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>Shift</kbd><span class="sep">+</span><kbd>V</kbd></span><span class="va-desc">클립보드 히스토리 붙여넣기</span></div>

    <p class="va-section">선택 · SELECTION</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="va-desc">선택 영역 조금씩 확장</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="va-desc">선택 영역 크게 확장</span></div>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>]</kbd></span><span class="va-desc">선택 영역 조금씩 축소</span></div>
    <div class="va-row"><span class="va-key"><kbd>Alt</kbd><span class="sep">+</span><kbd>[</kbd></span><span class="va-desc">선택 영역 크게 축소</span></div>

    <p class="va-section">기타 · MISC</p>
    <div class="va-row"><span class="va-key"><kbd>Shift</kbd><span class="sep">+</span><kbd>Alt</kbd><span class="sep">+</span><kbd>H</kbd></span><span class="va-desc">VA 해쉬태그 창 열기</span></div>
    <div class="va-row"><span class="va-key"><kbd>Ctrl</kbd><span class="sep">+</span><kbd>0</kbd></span><span class="va-desc">에디터 확대 100% 리셋</span></div>

  </div>
</div>
