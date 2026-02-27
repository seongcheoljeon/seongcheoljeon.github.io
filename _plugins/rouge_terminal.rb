require "rouge"

module Rouge
  module Lexers
    class Terminal < RegexLexer
      title "Terminal"
      desc  "Linux / macOS shell terminal output (prompt, cmake, ls, tree, ...)"

      tag     "terminal"
      aliases "bash_session", "sh_session"

      UNIX_CMD_RE = /\b(?:
        ls|ll|la|dir|cd|pwd|pushd|popd|
        mkdir|rmdir|rm|cp|mv|touch|ln|
        cat|less|more|head|tail|tee|
        grep|egrep|fgrep|rg|find|locate|which|whereis|
        chmod|chown|chgrp|stat|file|ldd|nm|objdump|
        ps|top|htop|kill|killall|pkill|bg|fg|jobs|
        df|du|free|uname|uptime|
        tar|gzip|gunzip|bzip2|zip|unzip|xz|
        ssh|scp|rsync|curl|wget|
        git|cmake|make|ninja|ctest|cpack|ccmake|
        gcc|g\+\+|clang|clang\+\+|ld|ar|ranlib|strip|pkg-config|
        python3?|pip3?|ruby|gem|bundle|jekyll|node|npm|yarn|
        echo|printf|read|export|unset|source|alias|
        sudo|su|env|
        vi|vim|nvim|nano|emacs|code|
        awk|sed|tr|sort|uniq|wc|cut|paste|xargs|
        tree|lsof|strace|ltrace|
        apt|apt-get|dnf|yum|pacman|brew|snap
      )\b/x

      # 프롬프트 없이 명령어로 시작하는 라인 감지용 lookahead
      CMD_START_RE = /^(?=(?:
        ls|ll|la|cd|pwd|pushd|popd|
        mkdir|rmdir|rm|cp|mv|touch|ln|
        cat|less|more|head|tail|tee|
        grep|egrep|fgrep|rg|find|locate|which|whereis|
        chmod|chown|chgrp|stat|file|
        ps|top|htop|kill|killall|pkill|
        df|du|free|uname|uptime|
        tar|gzip|gunzip|bzip2|zip|unzip|xz|
        ssh|scp|rsync|curl|wget|
        git|cmake|make|ninja|ctest|cpack|ccmake|
        gcc|clang|
        python3?|pip3?|ruby|gem|bundle|jekyll|node|npm|yarn|
        echo|printf|export|unset|source|alias|
        sudo|su|env|
        vi|vim|nvim|nano|emacs|code|
        awk|sed|tr|sort|uniq|wc|cut|xargs|
        tree|lsof|
        apt|apt-get|dnf|yum|pacman|brew|snap
      )\b)/x

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

        # 5. ls -alF 권한 라인: drwxr-xr-x  2 user group 4096 Feb 27 12:00 name
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

        # 6. tree 출력 — box-drawing 문자로 시작하는 라인만
        rule(/^([│├└─][│├└─ \t]*)(\S.*)$/) do |m|
          token Punctuation,      m[1]
          token Generic::Output,  m[2]
        end

        # 7. 프롬프트 있는 경우: user@host:~$ cmd  /  $ cmd
        rule(/^([^\n$]*\$[ \t]+)/) do |m|
          token Generic::Prompt, m[1]
          push :command
        end

        # 8. root 프롬프트: #
        rule(/^([^\n#]*#[ \t]+)/) do |m|
          token Generic::Prompt, m[1]
          push :command
        end

        # 9. 프롬프트 없이 명령어로 시작하는 라인
        rule(CMD_START_RE) do
          push :command
        end

        # 10. inline fallback
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+(?:\.\d+)?/, Literal::Number)
        rule(/./, Generic::Output)
        rule(/\n/, Text)
      end

      state :command do
        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        # 명령어 (최우선)
        rule(UNIX_CMD_RE, Name::Builtin)

        # 긴 플래그: --output, --build-type
        rule(/--[A-Za-z][A-Za-z0-9\-]*(?:=[^"'\s]*)?/, Name::Decorator)

        # 짧은 플래그: -a, -alF, -DCMAKE_TOOLCHAIN_FILE=...
        # =[^"'\s]* — = 이후 따옴표/공백 앞에서 멈춰 다음 string rule이 처리
        rule(/-[A-Za-z][A-Za-z0-9_]*(?:=[^"'\s]*)?/, Name::Decorator)

        # 절대 경로: /usr/local/bin
        rule(/(?:\/[^\s\/;|&>]+)+\/?/, Name::Namespace)

        # 상대 경로: ./build, ../src, ~/project
        rule(/(?:\.\.?|~)\/[^\s;|&>]*/, Name::Namespace)

        # 문자열
        rule(/"[^"\n]*"/, Literal::String)
        rule(/'[^'\n]*'/, Literal::String)

        # 셸 변수: $HOME, ${CMAKE_BUILD_TYPE}
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
