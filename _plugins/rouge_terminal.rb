require "rouge"

module Rouge
  module Lexers
    class Terminal < RegexLexer
      title "Terminal"
      desc  "Linux / macOS shell terminal output (prompt, cmake, ls, tree, ...)"

      tag     "terminal"
      aliases "bash_session", "sh_session"

      # 공통 명령어 목록 — UNIX_CMD_RE / CMD_START_RE 양쪽에서 공유
      UNIX_CMDS = %w[
        ls ll la cd pwd pushd popd
        mkdir rmdir rm cp mv touch ln
        cat less more head tail tee
        grep egrep fgrep rg fd find locate which whereis
        chmod chown chgrp stat file
        ps top htop btop kill killall pkill bg fg jobs nohup
        df du free uname uptime
        tar gzip gunzip bzip2 zip unzip xz zstd
        ssh scp rsync curl wget
        ssh-keygen ssh-copy-id ssh-agent
        git cmake make ninja ctest cpack ccmake meson bazel
        gcc clang ld ar ranlib strip pkg-config
        ldd nm objdump readelf objcopy otool
        addr2line size patchelf install
        python python2 python3 pip pip2 pip3
        python3-config python-config
        ruby gem bundle jekyll
        node npm yarn pnpm
        cargo rustc rustup
        go
        java javac mvn gradle
        dotnet
        swift swiftc
        docker docker-compose podman
        kubectl helm
        conan vcpkg
        echo printf read export unset source alias
        sudo su env
        date time sleep watch
        vi vim nvim nano emacs code
        awk sed tr sort uniq wc cut paste xargs
        diff patch comm
        hexdump xxd
        md5sum sha1sum sha256sum sha512sum
        base64
        jq yq
        tree lsof strace ltrace
        tmux screen
        systemctl service journalctl
        sysctl
        apt apt-get apt-cache
        dnf yum pacman brew snap port
        ldconfig
        poetry pyenv pipenv
        em++ emrun gh
        xcodebuild xcrun
        dumpbin
        protoc flatc
      ].freeze

      # :command 상태 안에서 명령어 이름을 실제 소비·색칠 (\b 워드 바운더리 사용)
      # g++/clang++ 는 \b 가 + 뒤에서 동작하지 않으므로 lookahead 별도 처리
      _cmd_alt = UNIX_CMDS.map { |c| Regexp.escape(c) }.join('|')
      UNIX_CMD_RE = /(?:\b(?:#{_cmd_alt})\b|g\+\+(?=\s|-|$)|clang\+\+(?=\s|-|$))/

      # :root 상태에서 라인이 명령어로 시작하는지 감지 (zero-width lookahead, 텍스트 소비 없음)
      CMD_START_RE = /^(?=(?:#{_cmd_alt})\b|g\+\+(?=\s|-|$)|clang\+\+(?=\s|-|$))/

      state :root do

        # 1. cmake 진행 라인: [  0%], [100%]
        rule(/^(\[\s*\d+%\])(\s+)(Building|Linking|Compiling|Scanning|Generating|Archiving|Installing|Built target|Linking CXX|Linking C )(.*)$/) do |m|
          token Generic::Strong,  m[1]
          token Text,             m[2]
          token Keyword,          m[3]
          token Generic::Output,  m[4]
        end

        rule(/^(\[\s*\d+%\])(.*)$/) do |m|
          token Generic::Strong,  m[1]
          token Generic::Output,  m[2]
        end

        # 2. cmake -- 메시지
        rule(/^(--)(\s+)(.*)$/) do |m|
          token Comment::Single,  m[1]
          token Text,             m[2]
          token Generic::Output,  m[3]
        end

        # 3. CMake / make 에러·경고
        rule(/^CMake Error.*$/, Generic::Error)
        rule(/^CMake Warning.*$/, Generic::Emph)
        rule(/^make(?:\[\d+\])?:\s+\*\*\*.*$/, Generic::Error)

        # 4. 일반 error / warning 라인
        rule(/^.*\b(?:error|Error|ERROR):\s+.*$/, Generic::Error)
        rule(/^.*\b(?:warning|Warning|WARNING):\s+.*$/, Generic::Emph)

        # 5. ls -alF 권한 라인
        rule(/^([d\-lrwxstST]{10})(\s+\d+)(\s+)(\S+)(\s+)(\S+)(\s+)([\d,]+)(\s+)(\w{3}\s+\d+\s+[\d:]+)(\s+)(.+)$/) do |m|
          token Name::Decorator,  m[1]
          token Literal::Number,  m[2]
          token Text,             m[3]
          token Name::Variable,   m[4]
          token Text,             m[5]
          token Name::Variable,   m[6]
          token Text,             m[7]
          token Literal::Number,  m[8]
          token Text,             m[9]
          token Comment::Single,  m[10]
          token Text,             m[11]
          token Generic::Output,  m[12]
        end

        # 6. tree 출력
        rule(/^([│├└─][│├└─ \t]*)(\S.*)$/) do |m|
          token Punctuation,      m[1]
          token Generic::Output,  m[2]
        end

        # 7. 프롬프트: user@host:~$ / $
        rule(/^([^\n$]*\$[ \t]+)/) do |m|
          token Generic::Prompt, m[1]
          push :command
        end

        # 8-a. shell 주석: 라인 시작이 # (root 프롬프트보다 먼저 매칭)
        rule(/^#[^\n]*$/, Comment::Single)

        # 8-b. root 프롬프트: user@host:/path# 또는 [user@host dir]#
        # [^\n#]+ 는 인라인 주석(ln ... # comment)도 매칭해버리므로
        # 반드시 @ 또는 [] 가 있는 실제 프롬프트 형태만 허용
        rule(/^(?:[A-Za-z0-9._-]+@[A-Za-z0-9._-]+:[^\n]*?#|\[[^\]]+\]#)[ \t]+/) do |m|
          token Generic::Prompt, m[0]
          push :command
        end

        # 9. 프롬프트 없이 명령어로 시작하는 라인
        rule(CMD_START_RE) do
          push :command
        end

        # 9-1. ./script, ~/script, /usr/bin/script 로 시작하는 실행
        rule(/^(?:(?:\.{1,2}|~)?\/[^\s;|&>]+)(?=\s|$)/) do |m|
          token Name::Namespace, m[0]
          push :command
        end

        # 10. inline fallback
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+(?:\.\d+)?/, Literal::Number)
        rule(/./, Generic::Output)
        rule(/\n/, Text)
      end

      state :command do
        # 라인 연속: \ + \n → pop 없이 다음 줄도 :command 유지
        rule(/\\\n/) { token Text, "\\\n" }

        # 인라인 주석: cmd arg # comment
        rule(/#[^\n]*/) { |m| token Comment::Single, m[0] }

        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        rule(UNIX_CMD_RE, Name::Builtin)

        # 긴 플래그: --output, --build-type=VALUE (값 분리)
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)(\/[^\s;|&>]*)/) do |m|
          token Name::Decorator,  m[1]  # --prefix
          token Punctuation,      m[2]  # =
          token Name::Namespace,  m[3]  # /home/sources/...
        end
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)([^"'\s]+)/) do |m|
          token Name::Decorator,   m[1]  # --with-python
          token Punctuation,       m[2]  # =
          token Literal::String,   m[3]  # python3.10
        end
        rule(/--[A-Za-z][A-Za-z0-9\-]*/, Name::Decorator)

        # 짧은 플래그: -a, -DCMAKE_=VALUE (값 분리)
        rule(/(-[A-Za-z][A-Za-z0-9_]*)(=)(\/[^\s;|&>]*)/) do |m|
          token Name::Decorator,  m[1]
          token Punctuation,      m[2]
          token Name::Namespace,  m[3]
        end
        rule(/(-[A-Za-z][A-Za-z0-9_]*)(=)([^"'\s]+)/) do |m|
          token Name::Decorator,   m[1]
          token Punctuation,       m[2]
          token Literal::String,   m[3]
        end
        rule(/-[A-Za-z][A-Za-z0-9_]*/, Name::Decorator)

        # URL: https://..., git+https://..., ssh+git://...
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?https?:\/\/[^\s;|&>]+/, Name::Namespace)
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?git:\/\/[^\s;|&>]+/, Name::Namespace)

        # 절대 경로: /usr/local/bin
        rule(/(?:\/[^\s\/;|&>]+)+\/?/, Name::Namespace)

        # 상대 경로 (명시적): ./build, ../src, ~/project
        rule(/(?:\.\.?|~)\/[^\s;|&>]*/, Name::Namespace)

        # bare 상대 경로: src/foo.cpp, include/bar.h
        rule(/[A-Za-z_][A-Za-z0-9_.+-]*(?:\/[^\s;|&>]+)+/, Name::Namespace)

        # dotted config key: virtualenvs.in-project, http.sslverify, core.autocrlf
        rule(/[A-Za-z_][A-Za-z0-9_-]*(?:\.[A-Za-z0-9_-]+)+/, Name::Namespace)

        # 파일명 (확장자 있는 경우): main.out, foo.cpp — 단, foo.bar-baz 는 제외
        rule(/[A-Za-z_][A-Za-z0-9_+-]*\.[A-Za-z][A-Za-z0-9]*(?![A-Za-z0-9_-])/, Name::Namespace)

        # boolean 값: true, false, yes, no, on, off
        rule(/\b(?:true|false|yes|no|on|off)\b/, Keyword::Constant)

        # 문자열
        rule(/"[^"\n]*"/, Literal::String)
        rule(/'[^'\n]*'/, Literal::String)

        # 셸 변수
        rule(/\$\{[A-Za-z_][A-Za-z0-9_]*\}/, Name::Variable)
        rule(/\$[A-Za-z_][A-Za-z0-9_]*/, Name::Variable)

        # 파이프 / 리다이렉트 / 논리 연산자
        rule(/\|\||&&|>>?|<<|[|;&]/, Operator)

        # 숫자
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/\d+/, Literal::Number)

        rule(/[ \t]+/, Text)
        rule(/[A-Za-z_][A-Za-z0-9_\-\.]*/, Generic::Output)
        rule(/./, Generic::Output)
      end
    end
  end
end
