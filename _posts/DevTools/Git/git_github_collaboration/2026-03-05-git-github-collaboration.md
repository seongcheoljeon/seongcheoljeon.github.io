---
title: "[DevTools/Git] GitHub 협업 (Collaboration)"
description: >-
  GitHub 협업은 PR 기반으로 브랜치 작업을 리뷰·머지하고, 이슈/프로젝트로 업무를 함께 관리하는 방식이다.
series: "Git for Beginner"
series_part: 10
author: seongcheol
date: 2026-03-05 14:00:00 +0900
categories: [DevTools, Git]
tags: [Git, GitHub Collaboration]
pin: true
image:
  path: "/assets/img/common/title/git_title.jpg"
mermaid: true
---

GitHub는 원격 저장소를 넘어, 프로젝트 협업에 필요한 다양한 도구를 함께 제공하는 플랫폼이다.

---

## GitHub 협업 도구

| 도구 | 설명 |
|------|------|
| **이슈 트래커 (Issues)** | 버그 보고, 기능 개선, 프로젝트 관련 주제를 게시판 형태로 관리 |
| **위키 (Wiki)** | 프로젝트 문서, 참고 자료를 Markdown으로 작성·공유 |
| **풀 리퀘스트 (Pull Request)** | 브랜치 변경 사항을 리뷰하고 머지 요청 |
| **코드 리뷰 (Code Review)** | PR 내 코드를 줄 단위로 댓글 달며 리뷰 |

---

## 이슈 트래커 (Issues)

이슈 트래커는 버그 보고, 기능 개선 건의, 프로젝트 관련 주제를 등록하고 관리하는 공간이다.  
일반 게시판과 달리, 아래와 같은 GitHub 특유의 기능을 제공한다.

| 기능 | 설명 |
|------|------|
| **담당자 (Assignees)** | 이슈 담당자를 저장소 기여자 중에서 지정 |
| **알림 (Mention)** | `@<사용자명>` 형식으로 특정 사용자 또는 그룹에 알림 전송 |
| **라벨 (Labels)** | 이슈 카테고리를 색상 라벨로 분류 |
| **커밋 레퍼런스** | 커밋 SHA-1 해시를 본문에 입력하면 해당 커밋에 자동 링크 |
| **마일스톤 (Milestone)** | 이슈들을 하나의 목표 그룹으로 묶는 표식. 이슈 해결 시 진행률 표시 |

### 이슈 목록 구조

![img](img/image1.png)
_Issues 게시물 구조_

| 표시 | 의미 |
|:----:|------|
| 🔴 빨간 화살표 | 이슈 넘버 (자동 증가, 1부터 시작) |
| 🔵 파란 화살표 | 마일스톤 |
| 🟢 녹색 화살표 | 라벨 |

---

## 이슈 작성

`<New Issue>` 를 클릭해 이슈를 작성한다.

![img](img/image2.png)
_이슈 작성 화면_

> 이슈 본문에 커밋 SHA-1 체크섬 값을 입력하면, 등록 후 해당 커밋 내역에 자동으로 링크가 생성된다.  
> 이슈를 커밋 내역과 연결하는 것이 이슈 트래커를 제대로 활용하는 핵심이다.
{: .prompt-tip }

### 커밋 SHA-1 값 복사 방법

**① Commits 탭에서 커밋 목록 확인**

![img](img/image3.png)
_Commits 탭 클릭_

**② 커밋 우측 아이콘 클릭 → SHA-1 체크섬 클립보드 복사**

![img](img/image4.png)
_SHA-1 복사 아이콘_

**③ 이슈 본문에 붙여넣기 → 등록 시 자동 링크 생성**

![img](img/image5.png)
_이슈 등록 후 커밋 링크가 자동으로 표시된 모습_

> 이슈 본문 하단의 **"Attach files by dragging & dropping, selecting or pasting them."** 영역을 통해 이미지를 드래그하거나 붙여넣기로 첨부할 수 있다.
{: .prompt-info }

### 라벨 · 마일스톤 · 담당자 지정

![img](img/image6.png)
_라벨, 마일스톤, 담당자 지정 패널_

| 항목 | 설정 방법 |
|------|----------|
| **Labels** | 우측 톱니바퀴 클릭 → 라벨 선택 또는 신규 생성 |
| **Milestone** | 우측 톱니바퀴 클릭 → 이름 입력 후 "Create and assign to new milestone" 선택 |
| **Assignees** | 우측 톱니바퀴 클릭 → 저장소 기여자 중 선택 |

> 하나의 이슈에는 **마일스톤을 하나만** 할당할 수 있다.  
> 동일한 마일스톤을 공유하는 이슈들이 해결될수록 마일스톤 진행 막대가 올라간다.
{: .prompt-info }

---

## 이슈 등록 결과

![img](img/image7.png)
_이슈 등록 완료 화면_

![img](img/image8.png)
_이슈 상세 화면_

이슈가 등록되면, 이슈 페이지에서 댓글을 남기거나 참조 커밋을 확인하며 이슈를 진행한다.

| 탭 | 설명 |
|:--:|------|
| **Write** | 댓글 입력 공간. 커밋 SHA-1 값 및 이미지 첨부 가능 |
| **Preview** | 입력한 댓글의 렌더링 결과 미리보기 |

---

## 이슈 닫기 / 재열기

이슈가 해결되면 `<Close issue>` 를 클릭해 이슈를 닫는다.  
닫힌 이슈는 이슈 진행 목록에 `closed this N minutes ago` 로 표시된다.

![img](img/image9.png)
_이슈를 닫은 후의 모습_

닫힌 이슈도 재논의가 필요하면 언제든지 다시 열 수 있다.  
**Closed** 탭 클릭 → 해당 이슈 선택 → `<Reopen issue>` 클릭.

![img](img/image10.png)
_닫힌 이슈 다시 열기_

> 이슈를 생성하고, 댓글로 논의하고, 해결 후 닫는 사이클을 팀 전체가 적극적으로 활용하는 것이 GitHub 협업의 핵심이다.
{: .prompt-tip }
