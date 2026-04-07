---
title: "[Editor/Vim] Text Object"
description: >-
  textobject는 텍스트를 블록 단위로 선택할 수 있게 해주는 기능이다. 블록 단위로 선택할 수 있게 되면, 블록에 대해 다양한 명령어를 사용할 수 있다. 
author: seongcheol
date: 2026-04-05 00:00:00 +0900
categories: [Editor, Vim]
tags: [Vim, neovim, text-object]
pin: false
image:
  path: "/assets/img/common/title/vim_title.jpg"
---

`ciw`, `di"`, `ci(` 같은 명령을 쓰면서도 왜 이렇게 동작하는지 정확히 알고 쓰는 사람은 생각보다 적다.  
text object 의 원리를 이해하면 응용 범위가 완전히 달라진다.

---

## 🧱 문법 구조

```
[operator] [a | i] [object]
```

| 명령 | 풀이 |
|---|---|
| `ciw` | **c**hange **i**nner **w**ord |
| `da"` | **d**elete **a**round `"` |
| `yi(` | **y**ank **i**nner `()` |

`a` / `i` 의 차이:

- `i` (inner) : object **내부만** 선택
- `a` (around) : object + **구분자(공백, 괄호, 따옴표 등)까지** 포함

```
hello "world foo" bar
           ^
         커서
```

| 명령 | 결과 |
|---|---|
| `ci"` | `world foo` 를 지우고 insert mode 진입 — 따옴표는 남음 |
| `ca"` | `"world foo"` 전체를 지우고 insert mode 진입 |

---

## 📖 Built-in Text Object

| object | 대상 | 별칭 |
|---|---|---|
| `w` | 단어 (영문자, 숫자, `_`) — `iskeyword` 기본 설정 기준 | |
| `W` | WORD (공백 기준) | |
| `s` | 문장 (`.` `!` `?` + 뒤에 공백 또는 줄 끝) | |
| `p` | 단락 (빈 줄 기준) | |
| `(` or `)` | `( )` | `b` |
| `{` or `}` | `{ }` | `B` |
| `[` or `]` | `[ ]` | |
| `<` or `>` | `< >` | |
| `t` | `<tag> </tag>` | |
| `"` | `"..."` | |
| `'` | `'...'` | |
| `` ` `` | `` `...` `` | |

`w` 와 `W` 의 차이: `foo.bar` 위에서 `iw` 는 `foo` 하나만, `iW` 는 `foo.bar` 전체를 선택한다.

paired delimiter(`(`, `{`, `[` 등)는 여는 쪽과 닫는 쪽 모두 동일하게 동작한다.  
중첩된 경우 커서를 감싸는 **가장 안쪽 쌍**을 기준으로 한다.

```
foo(bar(baz))
        ^
      커서
```

`ci(` → `baz` 삭제 후 insert mode. 바깥 `(bar(...))` 는 그대로.

---

## ⌨️ 단축키 정리

### ✏️ c — 삭제 후 insert mode

**📌 Word**

* `ciw` : 단어를 지우고 insert mode 진입
* `caw` : 단어 + 인접 공백을 지우고 insert mode 진입
* `ciW` : WORD (공백 기준) 를 지우고 insert mode 진입
* `caW` : WORD + 인접 공백을 지우고 insert mode 진입

**🔤 Quotes**

* `ci"` : `"..."` 안의 내용을 지우고 insert mode 진입
* `ca"` : `"..."` 포함 전체를 지우고 insert mode 진입
* `ci'` : `'...'` 안의 내용을 지우고 insert mode 진입
* `ca'` : `'...'` 포함 전체를 지우고 insert mode 진입
* `` ci` `` : `` `...` `` 안의 내용을 지우고 insert mode 진입
* `` ca` `` : `` `...` `` 포함 전체를 지우고 insert mode 진입

**🔲 Delimiters**

* `ci(` or `ci)` or `cib` : `(...)` 안의 내용을 지우고 insert mode 진입
* `ca(` or `ca)` or `cab` : `(...)` 포함 전체를 지우고 insert mode 진입
* `ci{` or `ci}` or `ciB` : `{...}` 안의 내용을 지우고 insert mode 진입
* `ca{` or `ca}` or `caB` : `{...}` 포함 전체를 지우고 insert mode 진입
* `ci[` or `ci]` : `[...]` 안의 내용을 지우고 insert mode 진입
* `ca[` or `ca]` : `[...]` 포함 전체를 지우고 insert mode 진입
* `ci<` or `ci>` : `<...>` 안의 내용을 지우고 insert mode 진입
* `ca<` or `ca>` : `<...>` 포함 전체를 지우고 insert mode 진입
* `cit` : `<tag>...</tag>` 안의 내용을 지우고 insert mode 진입
* `cat` : `<tag>...</tag>` 포함 전체를 지우고 insert mode 진입

**📄 Sentence / Paragraph**

* `cis` : 현재 문장을 지우고 insert mode 진입
* `cas` : 현재 문장 + 공백을 지우고 insert mode 진입
* `cip` : 현재 단락을 지우고 insert mode 진입
* `cap` : 현재 단락 + 빈 줄을 지우고 insert mode 진입

---

### 🗑️ d — 삭제

**📌 Word**

* `diw` : 단어 삭제
* `daw` : 단어 + 인접 공백 삭제
* `diW` : WORD 삭제
* `daW` : WORD + 인접 공백 삭제

**🔤 Quotes**

* `di"` : `"..."` 안의 내용 삭제
* `da"` : `"..."` 포함 삭제
* `di'` : `'...'` 안의 내용 삭제
* `da'` : `'...'` 포함 삭제
* `` di` `` : `` `...` `` 안의 내용 삭제
* `` da` `` : `` `...` `` 포함 삭제

**🔲 Delimiters**

* `di(` or `di)` or `dib` : `(...)` 안의 내용 삭제
* `da(` or `da)` or `dab` : `(...)` 포함 삭제
* `di{` or `di}` or `diB` : `{...}` 안의 내용 삭제
* `da{` or `da}` or `daB` : `{...}` 포함 삭제
* `di[` or `di]` : `[...]` 안의 내용 삭제
* `da[` or `da]` : `[...]` 포함 삭제
* `di<` or `di>` : `<...>` 안의 내용 삭제
* `da<` or `da>` : `<...>` 포함 삭제
* `dit` : `<tag>...</tag>` 안의 내용 삭제
* `dat` : `<tag>...</tag>` 포함 삭제

**📄 Sentence / Paragraph**

* `dis` : 현재 문장 삭제
* `das` : 현재 문장 + 공백 삭제
* `dip` : 현재 단락 삭제
* `dap` : 현재 단락 + 빈 줄 삭제

---

### 📋 y — 복사 (yank)

**📌 Word**

* `yiw` : 단어 복사
* `yaw` : 단어 + 인접 공백 복사
* `yiW` : WORD 복사
* `yaW` : WORD + 인접 공백 복사

**🔤 Quotes**

* `yi"` : `"..."` 안의 내용 복사
* `ya"` : `"..."` 포함 복사
* `yi'` : `'...'` 안의 내용 복사
* `ya'` : `'...'` 포함 복사
* `` yi` `` : `` `...` `` 안의 내용 복사
* `` ya` `` : `` `...` `` 포함 복사

**🔲 Delimiters**

* `yi(` or `yi)` or `yib` : `(...)` 안의 내용 복사
* `ya(` or `ya)` or `yab` : `(...)` 포함 복사
* `yi{` or `yi}` or `yiB` : `{...}` 안의 내용 복사
* `ya{` or `ya}` or `yaB` : `{...}` 포함 복사
* `yi[` or `yi]` : `[...]` 안의 내용 복사
* `ya[` or `ya]` : `[...]` 포함 복사
* `yi<` or `yi>` : `<...>` 안의 내용 복사
* `ya<` or `ya>` : `<...>` 포함 복사
* `yit` : `<tag>...</tag>` 안의 내용 복사
* `yat` : `<tag>...</tag>` 포함 복사

**📄 Sentence / Paragraph**

* `yis` : 현재 문장 복사
* `yas` : 현재 문장 + 공백 복사
* `yip` : 현재 단락 복사
* `yap` : 현재 단락 + 빈 줄 복사

---

### 👁️ v — visual 선택

**📌 Word**

* `viw` : 단어 visual 선택
* `vaw` : 단어 + 인접 공백 visual 선택
* `viW` : WORD visual 선택
* `vaW` : WORD + 인접 공백 visual 선택

**🔤 Quotes**

* `vi"` : `"..."` 안의 내용 visual 선택
* `va"` : `"..."` 포함 visual 선택
* `vi'` : `'...'` 안의 내용 visual 선택
* `va'` : `'...'` 포함 visual 선택
* `` vi` `` : `` `...` `` 안의 내용 visual 선택
* `` va` `` : `` `...` `` 포함 visual 선택

**🔲 Delimiters**

* `vi(` or `vi)` or `vib` : `(...)` 안의 내용 visual 선택
* `va(` or `va)` or `vab` : `(...)` 포함 visual 선택
* `vi{` or `vi}` or `viB` : `{...}` 안의 내용 visual 선택
* `va{` or `va}` or `vaB` : `{...}` 포함 visual 선택
* `vi[` or `vi]` : `[...]` 안의 내용 visual 선택
* `va[` or `va]` : `[...]` 포함 visual 선택
* `vi<` or `vi>` : `<...>` 안의 내용 visual 선택
* `va<` or `va>` : `<...>` 포함 visual 선택
* `vit` : `<tag>...</tag>` 안의 내용 visual 선택
* `vat` : `<tag>...</tag>` 포함 visual 선택

**📄 Sentence / Paragraph**

* `vis` : 현재 문장 visual 선택
* `vas` : 현재 문장 + 공백 visual 선택
* `vip` : 현재 단락 visual 선택
* `vap` : 현재 단락 + 빈 줄 visual 선택

---

### 📐 들여쓰기 / 포맷

* `=i{` or `=iB` : `{...}` 안의 내용 들여쓰기 정렬
* `=a{` or `=aB` : `{...}` 포함 들여쓰기 정렬
* `=ip` : 현재 단락 들여쓰기 정렬
* `>i{` : `{...}` 안의 내용 들여쓰기 증가
* `<i{` : `{...}` 안의 내용 들여쓰기 감소
* `>ip` : 현재 단락 들여쓰기 증가
* `<ip` : 현재 단락 들여쓰기 감소

---

### 🔡 대소문자 변환

* `gUiw` : 단어를 대문자로 변환
* `guiw` : 단어를 소문자로 변환
* `g~iw` : 단어 대소문자 토글
* `gUi"` : `"..."` 안의 내용을 대문자로 변환
* `gui"` : `"..."` 안의 내용을 소문자로 변환
* `gUip` : 현재 단락을 대문자로 변환
* `guip` : 현재 단락을 소문자로 변환

---

## 🖱️ Visual Mode 연계

visual mode 에서 text object 를 연속으로 적용하면 선택 범위를 **점진적으로 확장**할 수 있다.

아래 코드에서 커서가 `x` 위에 있다고 하면:

```c
void foo(int x, float y) { return x + y; }
```

```
viw   → x 선택
a(    → (int x, float y) 로 확장
a{    → { return x + y; } 로 확장
```

`o` 키로 선택 영역의 반대쪽 끝으로 커서를 이동할 수 있다.

---

## 🔌 플러그인

built-in text object 는 함수 단위, 클래스 단위, 인자 단위 선택이 안 된다. 이걸 플러그인으로 보완한다.

### targets.vim (Vim / Neovim)

가장 널리 쓰이는 text object 플러그인. 두 가지가 핵심이다.

**1. 커서가 delimiter 밖에 있어도 다음 쌍을 탐색한다.**

```
let x = 10;  foo(a, b)
^
커서
```

기본 `ci(` 는 커서가 `()` 밖에 있으면 동작하지 않는다.  
targets.vim 은 `cin(` (change inner **n**ext `()`) 으로 다음 `()` 를 바로 공략할 수 있다.

**2. 인자(argument) text object 추가 — `ia` / `aa`**

```c
foo(aaa, bbb, ccc)
         ^
       커서
```

* `dia` : `bbb` 삭제 → `foo(aaa, , ccc)`
* `daa` : `, bbb` 포함 삭제 → `foo(aaa, ccc)`
* `cia` : `bbb` 교체

```vim
" vim-plug
Plug 'wellle/targets.vim'
```

---

### nvim-treesitter-textobjects (Neovim 전용)

Treesitter AST 기반이라 언어 문법을 정확히 이해한다. 함수, 클래스, 조건문, 루프 단위 조작이 가능하다.

```lua
require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer", -- 함수 전체 (선언 포함)
        ["if"] = "@function.inner", -- 함수 바디만
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer", -- 인자 + 쉼표
        ["ia"] = "@parameter.inner", -- 인자만
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start     = { ["]f"] = "@function.outer" },
      goto_previous_start = { ["[f"] = "@function.outer" },
    },
    swap = {
      enable = true,
      swap_next     = { ["<leader>a"] = "@parameter.inner" },
      swap_previous = { ["<leader>A"] = "@parameter.inner" },
    },
  },
}
```

```c
void foo(int a, float b, bool c) {
    return a + b;
}
```

* `daf` : 함수 전체 삭제
* `cif` : 함수 바디만 교체
* `dia` : 커서 위치 인자 삭제
* `<leader>a` : 인자를 다음 인자와 swap
* `]f` : 다음 함수로 이동
* `[f` : 이전 함수로 이동

---

## ✅ 요약

```
[operator] [i | a] [object]
     c         i       w     →  ciw : 단어 삭제 후 insert
     d         a       "     →  da" : 따옴표 포함 삭제
     y         i       (     →  yi( : 괄호 안 복사
     v         a       {     →  va{ : 중괄호 포함 visual 선택
```

`i` 는 내부만, `a` 는 구분자까지. 이 하나만 제대로 이해하면 나머지는 전부 조합이다.
