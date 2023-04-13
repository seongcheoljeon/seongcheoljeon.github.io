# 소개

## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> MkDocs란?

mkdocs는 정적 사이트 생성기입니다. 컨텐츠는 기본적으로 markdown 형식으로 기술한 소스 파일이 됩니다. HTML 형식의 파일을 사용할 수도 있습니다. 이 기사에서는 Windows에서 개인적이고 최소한의 제작 환경을 요약했습니다.

- [MkDocs](http://www.mkdocs.org/)


## <i class="fa fa-arrow-circle-right" aria-hidden="true"></i> 설치

먼저 파이썬을 설치합니다. 그런 다음 pip를 사용하여 mkdocs를 설치합니다.

```
pip install mkdocs
```


나는 다음 환경에서 작동을 확인했다.

```
python 3.9.5
mkdocs 1.4.2
mkdocs-material 8.5.11
mkdocs-material-extentions 1.1.1
pymdown-extensions 9.9
```


## MkDocs의 기본 명령

프로젝트를 새로 만들려면 `mkdocs new`를 사용하십시오.

```
mkdocs new
```

그런 다음 사이트에 필요한 파일을 생성하려면 빌드를 수행합니다. 빌드는 다음 명령을 실행합니다.

```
mkdocs build
```

성공적으로 생성되면 site 폴더에 생성됩니다. 인터넷에 게시하는 경우 이 폴더를 업로드합니다. 빌드한 내용을 공개하기 전에, 로컬에서 확인하고 싶은 경우는 `serve` 명령을 실행해, 서버를 기동합니다.

```
mkdocs serve
```

명령의 출력에 `Serving on http://127.0.0.1:8000` 와 같이 주소와 포트 번호가 표시되므로, 그 주소를 브라우저에 입력해 확인할 수 있습니다.

serve를 실행하는 동안 파일의 추가 및 변경이 감지되고 자동으로 빌드됩니다.


## mkdocs.yml

mkdocs.yml 파일을 편집하여 문서를 구성하고 사용자 지정할 수 있습니다. 이 파일은 사이트 제목과 테마, 확장 기능 설정 등을 설명합니다. 프로젝트를 만들면 이 파일이 자동으로 만들어집니다.


## 문서 구성

mkdocs.yml의`nav`로 지정하십시오.

```yml
nav:
   - 초기 화면: index.md
   - introduction.md
   - material.md
   - section1:
       section1-1:
         section1-1-1:
           section1-1-1.md
       section1-2:
         section1-2-1:
           section1-2-1.md
   - section2:
     - page2-1.md
     - page2-2.md
```