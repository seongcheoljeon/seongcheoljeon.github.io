---
title: "[OS/Windows] Windows 탐색기에서 해당 경로로 WSL Ubuntu 터미널 열기"
description: >-
  Windows 탐색기에서 우클릭 -> "터미널 열기"를 하면, PowerShell은 해당 경로로 자동으로 이동하지만, WSL Ubuntu는 항상 홈 디렉토리에서 열리는 문제 해결.
author: seongcheol
date: 2026-04-09 00:08:00 +0900
categories: [OS, Windows]
tags: [OS, Windows, Terminal]
pin: false
image:
  path: "/assets/img/common/title/windows_title.png"
---

Windows 탐색기에서 우클릭 → **"터미널에서 열기"** 를 하면 PowerShell은 해당 경로로 자동 이동하지만,
WSL Ubuntu는 항상 홈 디렉토리(`~`)에서 열리는 문제를 해결한다.

---

## 🔍 원인

PowerShell은 Windows 경로를 그대로 사용하므로 탐색기 경로를 바로 상속받는다.

반면 WSL은 Linux 환경이라 `source: "Microsoft.WSL"` 설정만으로는 탐색기 경로를 받지 못하고
기본적으로 홈 디렉토리(`~`)에서 시작한다.

`commandline: "wsl.exe -d Ubuntu-24.04"`를 명시하면 Windows Terminal의 현재 경로를
WSL이 자동으로 `/mnt/c/...` 형식으로 변환하여 시작 경로로 사용한다.
단, 터미널을 그냥 열면 Windows Terminal의 기본 경로인 `C:\Windows\System32`를 상속받으므로
이를 홈으로 돌려보내는 처리가 추가로 필요하다.

---

## ✅ 해결 방법

### 1️⃣ Windows Terminal `settings.json` 수정

`profiles.list` 에서 Ubuntu 프로필을 찾아 `"commandline"` 항목을 추가한다.

```json
{
    "colorScheme": "Campbell",
    "commandline": "wsl.exe -d Ubuntu-24.04",
    "guid": "{본인의 guid}",
    "hidden": false,
    "name": "Ubuntu-24.04",
    "source": "Microsoft.WSL"
}
```

> `guid`는 본인 환경마다 다르다. 기존 Ubuntu 프로필에 `"commandline"` 한 줄만 추가하면 된다.

### 2️⃣ `.zshrc`에 경로 변환 코드 추가

```bash
# 그냥 열었을 때 System32 등 Windows 시스템 경로면 홈으로 이동
case "$PWD" in
    /mnt/c/Windows*|/mnt/c/windows*) cd ~ ;;
esac
```

---

## ⚙️ 동작 원리

| 항목 | 설명 |
|---|---|
| `wsl.exe -d Ubuntu-24.04` (settings.json) | Windows Terminal의 현재 디렉토리를 WSL이 자동으로 `/mnt/c/...`로 변환하여 시작 경로로 사용한다. |
| `case "$PWD"` | 쉘 시작 시점의 `$PWD`를 확인. `/mnt/c/Windows*`이면 Windows 시스템 경로이므로 `~`로 이동한다. |

탐색기에서 `C:\Users\foo\Documents` 경로에서 열면, WSL은 `/mnt/c/Users/foo/Documents`로 이동한다.
그냥 터미널을 열면 기본 경로인 `C:\Windows\System32` → `/mnt/c/Windows/System32`가 되고, `case`문이 `~`로 보낸다.

---

## ❌ 실패했던 방법

### `powershell.exe pwd` 방식

처음에는 `powershell.exe -Command "pwd"` 로 탐색기 경로를 가져오려 했다.

```bash
if [[ -n "$WT_SESSION" && -n "$WT_PROFILE_ID" ]]; then
    WIN_PATH=$(powershell.exe -NoProfile -Command "pwd" 2>/dev/null | tr -d '\r')
    if [[ -n "$WIN_PATH" ]]; then
        WSL_PATH=$(wslpath "$WIN_PATH" 2>/dev/null)
        [[ -d "$WSL_PATH" ]] && cd "$WSL_PATH"
    fi
fi
```

하지만 `powershell.exe -Command "pwd"` 는 Windows 탐색기의 경로가 아닌,
**현재 WSL의 경로를 UNC 형식으로 반환**하기 때문에 의미가 없다.

```
# 실제 출력 예시
Microsoft.PowerShell.Core\FileSystem::\\wsl.localhost\Ubuntu-24.04\home\username
```

`.zshrc`가 실행되는 시점에는 이미 WSL이 `~`에서 시작한 후이므로,
PowerShell도 WSL 홈 경로를 그대로 돌려줄 뿐이다.

### `/proc/$PPID/cwd` 방식

부모 프로세스의 cwd를 읽어 경로를 얻으려 했으나, WSL2에서 Windows 프로세스(Windows Terminal)는 `/proc`에 항목이 없어 `readlink /proc/$PPID/cwd`가 빈 값을 반환한다. 애초에 동작하지 않는 방법이다.

사실 `settings.json`에 `commandline: "wsl.exe -d Ubuntu-24.04"`를 설정하면 **WSL이 Windows Terminal의 현재 경로를 `/mnt/c/...`로 자동 변환하여 시작**하므로, `$PWD`만 확인하면 충분하다.

---

## 🖥️ 환경

- Windows 11
- Windows Terminal
- WSL2 Ubuntu 24.04
- Zsh + Oh My Zsh
