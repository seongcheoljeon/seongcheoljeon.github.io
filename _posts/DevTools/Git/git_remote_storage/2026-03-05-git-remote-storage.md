---
title: "[DevTools/Git] 원격 저장소 (Remote Repository)"
description: >-
  원격 저장소는 GitHub/GitLab 같은 서버에 있는 Git 저장소로, 팀원들과 코드 변경을 공유·동기화하는 공간이다.
series: "Git for Beginner"
series_part: 9
author: seongcheol
date: 2026-03-05 10:58:00 +0900
categories: [DevTools, Git]
tags: [Git, Remote Repository]
pin: true
image:
  path: "/assets/img/common/title/git_title.jpg"
mermaid: true
---

## 원격 저장소 (Remote Repository)

Git은 개인 프로젝트 관리에도 유용하지만, 본질적으로 **협업을 위한 분산 버전 관리 시스템**이다. 그 핵심이 바로 **원격 저장소(Remote Repository)**이다.

### 원격 저장소와 [GitHub](https://github.com)

원격 저장소를 제공하는 대표 서비스가 **GitHub**이다. GitHub는 단순한 원격 저장소를 넘어, 다양한 협업 도구를 함께 제공하는 **프로젝트 종합 관리 플랫폼**이다.

#### GitHub의 주요 장점

| # | 장점 |
|:-:|------|
| 1 | 전 세계 오픈 소스 프로젝트에 참여하고 기여할 수 있다 |
| 2 | 작성한 코드를 포트폴리오로 직접 공개할 수 있다 |
| 3 | 개발자뿐만 아니라 디자이너, 기획자도 작업물을 공유할 수 있다 |
| 4 | 다른 사람의 코드를 읽고, 직접 작성하고, 비교하며 실력을 키울 수 있다 |

> '협업'이 GitHub를 관통하는 핵심 키워드다. GitHub를 개인 프로젝트에만 사용하는 것은 그 가능성의 절반도 활용하지 않는 것이다.  
> — *만들면서 배우는 git/github 입문* 발췌
{: .prompt-tip }

---

## 원격 저장소 생성 및 구조

### GitHub 저장소 생성

<https://github.com> 에서 가입 후 저장소를 생성한다.

> **Help me set up an organization next** 옵션은 여러 사람이 팀 단위로 협업할 때 사용하는 설정이다.
{: .prompt-info }

![img](img/image1.png)

#### 저장소 생성 옵션

| 옵션 | 설명 |
|------|------|
| **owner** | 저장소 소유자 (사용자 ID 또는 조직명) |
| **repository name** | 저장소 이름. 로컬 프로젝트 디렉토리명과 동일하게 설정 권장 |
| **description** | 저장소 설명 (선택). 저장소가 많아질수록 구분에 유용함 |
| **public / private** | 공개 여부. 무료 사용자는 public만 선택 가능 |
| **initialize with README** | 체크 시 `README.md`와 함께 저장소 초기화. 즉시 `clone` 가능 |
| **add .gitignore** | 원격 저장소에 포함하지 않을 파일 목록 설정 |
| **add a license** | 프로젝트 라이선스 선택 |

### GitHub 저장소 인터페이스

#### 저장소 상단 버튼

| 버튼 | 설명 |
|------|------|
| **Watch** | 저장소 활동 알림 설정. `Not Watching` / `Watching` / `Ignoring` 선택 가능 |
| **Star** | 관심 표시. 우측 숫자는 관심을 표시한 사용자 수 |
| **Fork** | 저장소 복제. 우측 숫자는 포크한 사용자 수 |

#### 저장소 정보 항목

| 항목 | 설명 |
|------|------|
| **commits** | 총 커밋 수 |
| **branches** | 브랜치 수 |
| **releases** | 태그 수. 특정 버전 다운로드에 활용 |
| **contributors** | 커밋 또는 Pull Request가 반영된 기여자 수 |

#### 브랜치 관련 메뉴

| 메뉴 | 설명 |
|------|------|
| **compare / review / create a pull request** | 브랜치 간 차이 비교 및 리뷰 |
| **current branch** | 현재 선택된 브랜치. 클릭으로 체크아웃 전환 가능 |
| **path** | 현재 저장소 경로. 최상위 경로 기준으로 탐색 |
| **+ (fork and create new file)** | 현재 경로에 파일 추가. 관리자가 아닐 경우 포크 후 추가됨 |

#### 저장소 메뉴 탭

| 탭 | 설명 |
|------|------|
| **Code** | 루트 디렉토리로 이동 |
| **Issues** | 버그, 개선점 등을 게시판 형태로 관리. 댓글로 토론 가능 |
| **Pull Requests** | Pull Request 목록. 항목별 댓글 토론 가능 |
| **Wiki** | 개발 문서, 참고 자료 작성 공간. Markdown 지원 |
| **Pulse** | 최근 변경 내역 (최대 1개월). PR/Issue 처리 현황 확인 |
| **Graphs** | 기여자 활동, 커밋 수 등 그래프 시각화 |
| **Settings** | 저장소 관리자 전용 설정 |

#### 클론 관련 항목

| 항목 | 설명 |
|------|------|
| **HTTPS clone URL** | `clone` 시 사용하는 저장소 주소 (HTTPS / SSH / SVN 전환 가능) |
| **Clone Desktop** | GitHub 전용 데스크탑 클라이언트로 클론 |
| **Download ZIP** | 전체 파일을 ZIP으로 다운로드 |

---

## 원격 저장소의 종류와 권한

GitHub는 **공개(Public)** 와 **비공개(Private)** 원격 저장소로 구분된다.

### 저장소 유형별 특징

| 구분 | 공개 (Public) | 비공개 (Private) |
|:----:|:-------------:|:----------------:|
| **읽기** | 모든 GitHub 사용자 | 지정된 협업자만 |
| **쓰기** | 관리자 + 협업자 | 관리자 + 협업자 |
| **Fork** | 모든 GitHub 사용자 | 지정된 협업자만 |
| **소유권 이전** | 누구에게나 가능 | 유료 사용자에게만 |

### 사용자 유형별 권한

| 사용자 유형 | 읽기 | 쓰기 | Fork | 소유권 이전 |
|:-----------:|:----:|:----:|:----:|:-----------:|
| 저장소 관리자 | ✓ | ✓ | ✓ | ✓ |
| 협업자 | ✓ | ✓ | ✓ | ✗ |
| 일반 사용자 (공개) | ✓ | ✗ | ✓ | ✗ |

> 포크 없이 타인의 저장소를 `clone`한 일반 사용자는, 관리자가 협업자로 지정하거나 소유권을 이전하지 않는 한 쓰기 권한이 없다.  
> 소유권 이전 시 원래 관리자는 **기여자(Contributor)** 로 전환된다.
{: .prompt-info }

---

## 원격 저장소와 Git 명령어

로컬 저장소와 원격 저장소 사이의 동기화를 위한 핵심 명령어는 다음과 같다.

| 명령어 | 방향 | 설명 |
|--------|:----:|------|
| `git clone` | 원격 → 로컬 | 원격 저장소 전체를 로컬로 복사 |
| `git remote` | 연결 설정 | 로컬 저장소를 특정 원격 저장소와 연결 |
| `git push` | 로컬 → 원격 | 로컬의 커밋을 원격 저장소로 업로드 |
| `git fetch` | 원격 → 로컬 | 원격 변경 사항을 로컬로 가져옴 (병합 없음) |
| `git pull` | 원격 → 로컬 | `fetch` + `merge` 자동 수행 (**비추천**) |

### Fork vs Clone

| 구분 | Fork | Clone |
|:----:|------|-------|
| **동작 위치** | GitHub 내부 (원격 → 원격) | GitHub → 내 로컬 |
| **용도** | 타인의 저장소를 내 계정으로 복사 | 원격 저장소를 로컬로 복사 |

---

## git remote: 로컬 ↔ 원격 저장소 연결

기존 로컬 저장소를 새로 만든 빈 원격 저장소와 연결할 때 `git remote add`를 사용한다.

```terminal
git remote add <저장소별칭> https://github.com/<사용자이름>/<저장소이름>.git
```

> **별칭(alias)** 은 자유롭게 지정할 수 있으나, 관례상 `origin`을 사용한다.  
> `git clone` 시에도 기본 별칭은 자동으로 `origin`으로 설정된다.
{: .prompt-tip }

연결 확인:

```terminal
git remote -v
```

---

## git push: 로컬 커밋을 원격 저장소에 업로드

```terminal
# 모든 로컬 브랜치를 원격 저장소에 푸시
git push origin --all

# 특정 브랜치 푸시
git push <원격저장소별칭> <로컬브랜치이름>
```

- `--all` 옵션: 모든 로컬 브랜치를 원격에 푸시
- 동일한 이름의 브랜치가 원격에 존재하면 업데이트, 없으면 신규 생성
- **원격 브랜치와 커밋 이력이 다를 경우 푸시 거부** → `fetch` + `merge` 후 재시도

---

## git fetch / git pull: 원격 변경 사항 가져오기

협업 중 다른 사람이 원격 저장소에 커밋을 먼저 올렸다면, 로컬에서 바로 `push`할 수 없다.  
원격의 최신 커밋을 먼저 로컬에 반영해야 한다.

### fetch vs pull 비교

| 구분 | `git fetch` | `git pull` |
|:----:|:-----------:|:----------:|
| 원격 커밋 가져오기 | ✓ | ✓ |
| 자동 병합 | ✗ | ✓ |
| 변경 내용 확인 후 병합 | ✓ | ✗ |
| **권장 여부** | ✅ 권장 | ⚠️ 비추천 |

> `git pull`은 변경 내용 확인 없이 자동 병합하여 세부 변경 사항 파악이 어렵다.  
> **`git fetch` → `git diff` → `git merge` 순서를 권장한다.**
{: .prompt-warning }

### git fetch 작업 흐름

| 단계 | 위치 | 작업 |
|:----:|------|------|
| 1 | 원격 (GitHub) | 파일 수정 및 커밋 |
| 2 | 로컬 | 로컬 작업 및 커밋 |
| 3 | 로컬 | `git push` 시도 → 거부됨 |
| 4 | 로컬 | `git fetch` — 원격 커밋 로컬로 가져오기 |
| 5 | 로컬 | `git diff origin/master` — 변경 사항 확인 |
| 6 | 로컬 | `git merge origin/master` — 수동 병합 |
| 7 | 로컬 | `git push` — 재시도 성공 |
| 8 | 원격 (GitHub) | 최종 결과 확인 |

### 푸시 거부 에러

원격과 로컬의 같은 브랜치에 서로 다른 커밋이 있을 경우 아래 에러가 발생한다.

```output
! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'https://github.com/<사용자이름>/<저장소이름>.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

에러 힌트는 `git pull`을 권장하지만, **`git fetch` + `git merge`가 더 안전하다.**

```terminal
# 1. 원격 커밋 가져오기
git fetch

# 2. 전체 브랜치 확인 (원격 브랜치 포함)
git branch -a

# 3. 변경 사항 확인
git diff origin/master

# 4. 수동 병합
git merge origin/master

# 5. 커밋 (충돌 해결 후)
git commit -a -m "커밋 메세지"

# 6. 푸시
git push origin master
```

### GitHub 웹 UI에서 직접 커밋 시 옵션

| 옵션 | 설명 |
|------|------|
| **update `<파일명>`** | 커밋 메세지 첫 번째 줄 (제목) |
| **add an optional extended description** | 커밋 메세지 본문 (선택) |
| **commit directly to the master branch** | `master` 브랜치에 직접 커밋 |
| **create a new branch for this commit** | Pull Request용 새 브랜치 생성 |
