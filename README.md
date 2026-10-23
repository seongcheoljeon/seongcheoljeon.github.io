<!-- markdownlint-disable-next-line -->
<div align="center">

  <!-- markdownlint-disable-next-line -->
  # Seongcheol Jeon's Blog

  [Seongcheol Jeon's Blog...](https://seongcheoljeon.github.io)

</div>


## 로컬에서 사이트 테스트

[Jekyll을 사용하여 로컬로 Github Pages 사이트 테스트](https://docs.github.com/ko/enterprise-cloud@latest/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll)

위의 링크에서 나오는대로 실행.

> 만약, javascript에러가 난다면 다음과 같은 명령 실행
```bash
npm install   
npm run build
```

---

```bash
`bundle exec jekyll serve`
```

실시간 갱신이 자동으로 되길 원한다면 아래의 명령으로 실행.

```bash
`bundle exec jekyll serve --livereload`
```
