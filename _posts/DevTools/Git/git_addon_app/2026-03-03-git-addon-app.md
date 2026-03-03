---
title: "[DevTools/Git] Git 관련 Application 소개"
description: >-
  GitHub, GitLab, Sourcetree 같은 Git 관련 앱들을 한눈에 비교하고, 목적별로 어떤 도구가 좋은지 짧게 정리한다.
series: "Git for Beginner"
series_part: 2
author: seongcheol
date: 2026-03-03 18:22:00 +0900
categories: [DevTools, Git]
tags: [Git, ]
pin: true
image:
  path: "/assets/img/common/title/git_title.jpg"
mermaid: true
---

## [Git History](https://githistory.xyz/)

`git`의 `history`를 직관적으로 한 눈에 볼 수 있는 프로그램이다.   
chrome, firefox, terminal, visual studio 등을 지원한다.

## [GitHub Desktop](https://desktop.github.com/download/)

Git을 GUI로 쉽게 커밋/브랜치/PR 처리하는 데스크톱 앱

## [Sourcetree](https://www.sourcetreeapp.com/)

브랜치/머지 흐름을 시각화해 관리하는 무료 Git GUI

## [GitKraken](https://www.gitkraken.com/)

강력한 시각화와 충돌 해결을 제공하는 Git GUI 클라이언트

## [Fork](https://git-fork.com/)

가볍고 빠른 Git GUI(브랜치/리베이스 작업에 편함)

## [TortoiseGit](https://tortoisegit.org/)

Windows Explorer에 통합되는 Git GUI(우클릭으로 작업)

## [GitHub CLI](https://cli.github.com/)

GitHub CLI는 터미널에서 GitHub 작업을 수행할 수 있게 해주는 공식 커맨드라인 도구다. 웹 브라우저를 열지 않고도 이슈, Pull Request, 저장소 등을 관리할 수 있다.

위의 링크에서 다운받아 설치하던지 혹은 아래와 같이 설치할 수 있다.

### Windows

```console
# winget 사용
winget install --id GitHub.cli
```

```console
# Chocolatey 사용
choco install gh
```

```console
# Scoop 사용
scoop install gh
```

### MacOS

```terminal
# Homebrew 사용
brew install gh
```

### Linux

```terminal
# Ubuntu/Debian
sudo apt install gh

# Fedora
sudo dnf install gh

# Arch Linux
sudo pacman -S github-cli
```

### 설치 확인

```terminal
gh --version
```
