# Material for MkDocs

Material for MkDocs는 MkDocs의 주제 중 하나입니다.
솔직하게 말해, 표준의 테마나 readthedocs도 이마이치이므로, 테마를 자작하지 않는 것이면 Material 테마 1택이라고 생각합니다. 이 문서에서는 Material 테마를 사용한다고 가정합니다.

```yml
theme:
   name: material
```

## 컬러

테마 색상을 지정할 수 있습니다. 지정할 수 있는 색상은 다음과 같습니다.

```
red, pink, purple, deep purple, indigo,
blue, light blue, cyan, teal,
green, light green, lime, yellow,
amber, orange, deep orange, brown,
grey, blue grey, black,, white
```

테마 색상은 `theme.palette.primary`로 지정됩니다.

```yml
theme:
   palette:
     primary: pink
```

라이트 테마나 다크 테마와 같이 테마를 전환하는 버튼을 추가할 수 있습니다.
다음과 같이 지정합니다.

```yml
theme:
   palette:
     - scheme: default
       primary: pink
       toggle:
         icon: material/brightness-7
         name: Switch to dark mode
     - scheme: slate
       toggle:
         icon: material/brightness-4
         name: Switch to light mode
```

검색 상자의 왼쪽에 테마를 전환하는 버튼이 추가되고 버튼을 누르면 테마를 전환할 수 있습니다.
각 테마마다 색상을 CSS로 조정할 수도 있습니다.

```css
[data-md-color-scheme=default] {
   --md-default-fg-color--light: #222 !important;
}
[data-md-color-scheme=slate] {
   --md-default-fg-color--light: #fefefe !important;
   --md-typeset-a-color: #fc0 !important;
}
```


## 폰트

통상 폰트와 고정폭 폰트를 각각 지정할 수 있습니다. 글꼴은 GoogleFont에있는 것을 지정할 수 있습니다.
필요한 css 파일도 자동으로 설정해 주기 때문에, 커스텀 css로 등록할 필요는 없습니다.

```yml
theme:
   font:
     text: Noto Sans KR
     code: Inconsolata
```


## 언어

여러 언어를 지정할 수 있습니다.

```yml
extra:
   alternate:
     - name: English
       링크: /en/
       lang: en
     - name: Korean
       링크: /
       lang: ko
```

검색 상자 옆에 언어를 전환하는 버튼이 추가됩니다. 각 문서는 링크 대상이되도록 배치하면 좋을 것 같습니다.


## 로고, 파비콘, 홈페이지

각각 다음과 같이 설정할 수 있습니다.

```yml
theme:
   logo: assets/logo.png
   favicon: images/favicon.png

extra:
   homepage: https://example.com
```


## 쿠키 사용 동의

일반 데이터 보호규칙(GDPR)에 의해 EU권내로부터의 액세스가 있었을 경우에 사이트에서 쿠키를 이용해 정보 수집하고 있는 경우는 확인을 취할 필요가 있습니다. Google 애널리틱스 등을 사용하고 있으면 필요합니다.
Material 테마에는 쿠키의 사용에 동의하는 팝업을 표시하는 기능이 준비되어 있습니다. 사용법은 다음과 같습니다.

```yml
extra:
   consent:
     title: Cookie consent
     description:
       We use cookies to recognize your repeated visits and preferences, as well
       as to measure the effectiveness of our documentation and whether users
       find what they're searching for. With your consent, you're helping us to
       make our documentation better.
```

표준으로 Google 애널리틱스와 GitHub가 활성화되어 있습니다. 추가하려면 'extra.content.cookies'로 지정하십시오.

```yml
extra:
   consent:
     cookies:
       analytics: Custom name
```

또한 팝업 버튼을 사용자 정의 할 수 있습니다. 일반적으로 "승인"과 "관리"가 표시됩니다. 그렇지 않으면 "거부"가 있습니다.

```yml
extra:
   consent:
     actions:
       - accept
       - manage
       - 거부
```


## 네비게이션

### 탭

탭은 `theme.features`로 활성화됩니다.

```yml
theme:
   features:
     - navigation.tabs
```

최상위 섹션은 탭이됩니다. 화면을 스크롤하면 탭 화면이 숨겨지지만 항상 표시하고 싶은 경우는 `navigation.tabs.sticky`를 추가합니다.


```yml
theme:
   features:
     - navigation.tabs
     - navigation.tabs.sticky
```


### 섹션 접기

계층이 깊은 컨텐츠의 경우, 사이드바에 있는 섹션 일람으로 접는 기능이 들어가 있습니다. 이것을 무효로 해 모두 플랫으로 표시하고 싶은 경우,`navigation.sections`를 지정합니다.

```yml
theme:
   features:
     - navigation.sections
```

또한 `navigation.expand`를 지정하면 처음부터 모두 확장 된 상태가됩니다.

```yml
theme:
   features:
     - navigation.expand
```

각 섹션에 인덱스 페이지를 지정하려면`navigation.indexes`를 지정하십시오.

```yml
theme:
   features:
     - navigation.indexes
```

문서의 구성은 다음과 같습니다.

```yml
nav:
   - Section:
     - section/index.md
     - Page 1: section/page-1.md
     - Page 2: section/page-2.md
```

이 경우`section/index.md`가 섹션의 항목에 통합됩니다.


### 맨 위로 가기 버튼

`navigation.top`을 추가합니다. 확인한 바, 항상이 아닌 위쪽으로 스크롤했을 때 표시됩니다.

```yml
theme:
   features:
     - navigation.top
```


### 사이드바 비활성화

탭을 사용하도록 설정하는 등 사이드바를 사용하지 않으려면 콘텐츠 쪽에서 다음을 지정합니다.

```
---
hide:
   - navigation
---
```


## 검색

플러그인으로 구현되었습니다. 검색 플러그인은 표준으로 들어 있습니다. 일본어 검색을 활성화하는 경우는 다음과 같이 합니다.

```yml
plugins:
   search:
     lang: 'ko'
```


## Google 애널리틱스

Google 애널리틱스는 다음과 같이 설정합니다.

```yml
extra:
   analytics:
     provider: google
     property: UA-XXXXXXXX-X
```


## 블로그

아직 실험 단계이지만 블로그 기능이 플러그인으로 구현되어있는 것 같습니다. 지금은 스폰서만 사용할 수 있는 것 같습니다. 관심있는 사람은 [Setting up a blog] (https://squidfunk.github.io/mkdocs-material/setup/setting-up-a-blog/)를 참조하십시오.


## 헤더와 바닥글

### 타이틀 바

제목 표시 줄은 항상 표시되지만`header.autohide`를 활성화하면 숨겨집니다.

```yml
theme:
   features:
     - header.autohide
```

### 소셜 링크

Twitter, Facebook, GitHub 등의 아이콘을 설정할 수 있습니다.

```yml
extra:
   social:
     - icon: fontawesome/brands/twitter
       link: https://twitter.com/mebiusbox2
       name: mebiusbox2 on Twitter
     - icon: fontawesome/brands/github
       link: https://github.com/mebiusbox/MkDocsTest
```


### 저작권 표기

다음과 같이 지정합니다. 처음에 `&copy;`를 사용하면 더블 따옴표로 묶습니다.

```yml
site_name: Mkdocs Test
copyright: "&copy; 2022 mebiusbox"
```


### 제너레이터 표기

바닥 글에 MkDocs에서 생성 된 내용이 자동으로 표시되지만 숨길 수 있습니다.

```yml
extra:
   generator: false
```


### Prev/Next 링크 숨기기

각 페이지에는 이전/다음 페이지 링크가 표시되지만, 이것을 숨기고 싶은 경우, 페이지측에서 지정합니다.

```
---
hide:
   - footer
---
```


### Git 저장소 링크 설정

오른쪽 상단에 Git 저장소 링크를 추가 할 수 있습니다. 자동으로 스타 수와 포크 수가 표시됩니다.

```yml
repo_url: https://github.com/mebiusbox/MkDocsTest
repo_name: mebiusbox/MkDocsTest
```

아이콘을 변경하려면 다음을 수행합니다.

```yml
theme:
   icon:
     repo: fontawesome/brands/github
```

예를 들어, GitLab 아이콘을 원한다면 다음과 같습니다.

```yml
theme:
   icon:
     repo: fontawesome/brands/gitlab
```


## 코멘트 기능

[giscus] (https://giscus.app/)가 지원됩니다. 절차는 다음과 같습니다.

1. 대상 리포지토리의 giscus 앱을 설치합니다.
2. 리포지토리에서 Dicussion을 활성화합니다.
3. giscus 페이지에서 필요한 정보를 입력합니다. 설정은 특별히 필요가 없으면 초기 그대로 좋다. "giscus 사용"에 표시된 코드를 복사합니다.
4. 맞춤 테마 사용
5. 코멘트 템플릿을 편집하고 붙여넣기

사용자 정의 테마를 사용하려면 다음을 수행하십시오.

```yml
theme:
   custom_dir: overrides
```

주석 템플릿 (overrides/partials/comments.html) 파일을 작성하여 다음을 붙여 넣습니다.

```html
{% if page.meta.comments %}
   <h2 id="__comments">{{ lang.t("meta.comments") }}</h2>
   <!-- Insert generated snippet here -->

   <!-- Synchronize Giscus theme with palette -->
   <script>
     var giscus = document.querySelector("script[src*=giscus]")

     /* Set palette on initial load */
     var palette = __md_get("__palette")
     if (palette && typeof palette.color === "object") {
       var theme = palette.color.scheme === "slate" ? "dark" : "light"
       giscus.setAttribute("data-theme", theme)
     }

     /* Register event handlers after documented loaded */
     document.addEventListener("DOMContentLoaded", function() {
       var ref = document.querySelector("[data-md-component=palette]")
       ref.addEventListener("change", function() {
         var palette = __md_get("__palette")
         if (palette && typeof palette.color === "object") {
           var theme = palette.color.scheme === "slate" ? "dark" : "light"

           /* Instruct Giscus to change theme */
           var frame = document.querySelector(".giscus-frame")
           frame.contentWindow.postMessage(
             { giscus: { setConfig: { theme } } },
             "https://giscus.app"
           )
         }
       })
     })
   </script>
{%endif%}
```

이 코드의 `<!-- Insert generated snippet here -->` 아래에 giscus로 복사 한 코드를 그대로 붙여 넣습니다. 이것으로 설정이 완료됩니다.


## GitHub Pages에서 게시

GitHub Action을 사용하여 리포지토리에서 빌드하고 게시하려면 GitHub Action 워크 플로 파일 (.github/workflows/ci.yml)을 만듭니다.

```yml
이름: ci
on:
   push:
     branches:
       - 마스터
       - main
permissions:
   contents: write
jobs:
   deploy:
     runs-on: ubuntu-latest
     steps:
       - uses: actions/checkout@v3
       - uses: actions/setup-python@v4
         with:
           python-version: 3.x
       - run: pip install mkdocs-material
       - run: mkdocs gh-deploy --force
```

CI가 성공적으로 종료되면`<username>.github.io/<repository>`에 배치됩니다.