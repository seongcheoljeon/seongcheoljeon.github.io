require "rouge"

module Rouge
  module Lexers
    class Console < RegexLexer
      title "Console"
      desc  "Windows Command Prompt / PowerShell output"

      tag     "console"
      aliases "cmd", "powershell_session", "pwsh"

      # 공통 CMD 명령어 목록 — CMD_CMD_RE / CMD_START_RE 양쪽에서 공유
      # Windows CMD는 대소문자 무관하므로 소문자로 통일 후 (?i:) 적용
      CONSOLE_CMDS = %w[
        dir cd md mkdir rd rmdir del erase
        copy move ren rename type more find findstr
        echo set path cls exit pause
        where attrib xcopy robocopy
        netstat ipconfig ping tracert nslookup
        netsh route arp
        tasklist taskkill reg sc net runas
        assoc ftype pushd popd call goto if for start
        timeout choice setx
        systeminfo ver vol
        mklink icacls cacls
        wmic wsl
        msiexec certutil cipher
        sfc dism bcdedit
        cmake make ninja ctest cpack ccmake meson
        git python3-config python-config
        python python2 python3 pip pip2 pip3
        node npm yarn pnpm ruby gem bundle
        gcc clang cl link lib msbuild devenv nmake
        cargo rustc rustup
        go
        java javac mvn gradle
        dotnet nuget
        docker docker-compose podman
        kubectl helm
        curl wget ssh scp
        conan vcpkg
        poetry pyenv pipenv
        em++ emrun gh
        winget choco scoop
        7z
        protoc flatc
      ].freeze

      # :cmd_command / :ps_command 안에서 명령어 이름을 실제 소비·색칠
      # (?i:) — Windows CMD 대소문자 무관
      _cmd_alt = CONSOLE_CMDS.map { |c| Regexp.escape(c) }.join('|')
      CMD_CMD_RE  = /(?:\b(?i:#{_cmd_alt})\b|g\+\+(?=\s|-|$)|clang\+\+(?=\s|-|$))/

      # :root 에서 라인이 CMD 명령어로 시작하는지 감지 (zero-width lookahead)
      CMD_START_RE = /^(?=(?i:#{_cmd_alt})\b|g\+\+(?=\s|-|$)|clang\+\+(?=\s|-|$))/

      # PowerShell Verb-Noun 패턴 — CMD와 구조가 달라 별도 유지
      PS_CMD_RE = /\b(?:
        Get-[A-Za-z]+|Set-[A-Za-z]+|New-[A-Za-z]+|
        Remove-[A-Za-z]+|Invoke-[A-Za-z]+|
        Start-[A-Za-z]+|Stop-[A-Za-z]+|
        Test-[A-Za-z]+|Write-[A-Za-z]+|Read-[A-Za-z]+|
        Select-[A-Za-z]+|Where-Object|ForEach-Object|
        Sort-[A-Za-z]+|Format-[A-Za-z]+|Out-[A-Za-z]+|
        Import-[A-Za-z]+|Export-[A-Za-z]+|
        ConvertTo-[A-Za-z]+|ConvertFrom-[A-Za-z]+|
        Measure-[A-Za-z]+|Compare-[A-Za-z]+|
        Add-[A-Za-z]+|Clear-[A-Za-z]+|Copy-[A-Za-z]+|
        Move-[A-Za-z]+|Rename-[A-Za-z]+|
        Enable-[A-Za-z]+|Disable-[A-Za-z]+
      )\b/x

      # :root 에서 라인이 PS Verb- 로 시작하는지 감지 (zero-width lookahead)
      PS_START_RE = /^(?=(?:
        Get-|Set-|New-|Remove-|Invoke-|Start-|Stop-|
        Test-|Write-|Read-|Select-|Where-|ForEach-|
        Sort-|Format-|Out-|Import-|Export-|
        ConvertTo-|ConvertFrom-|Measure-|Compare-|
        Add-|Clear-|Copy-|Move-|Rename-|
        Enable-|Disable-
      ))/x

      state :root do

        # 0. shell 주석: 라인 시작이 #
        rule(/^#[^\n]*$/, Comment::Single)

        # 1. PowerShell 프롬프트: PS C:\Users\...>
        rule(/^(PS\s+)([A-Za-z]:[^\n>]*>)([ \t]*)/) do |m|
          token Keyword,          m[1]
          token Generic::Prompt,  m[2]
          token Text,             m[3]
          push :ps_command
        end

        # 2. CMD 프롬프트: C:\path>
        rule(/^([A-Za-z]:[^\n>]*>)([ \t]*)/) do |m|
          token Generic::Prompt,  m[1]
          token Text,             m[2]
          push :cmd_command
        end

        # 3. dir 출력 — <DIR> 라인
        rule(/^(\d{2}\/\d{2}\/\d{4}\s+\d{2}:\d{2}\s+[AaPp][Mm])(\s+)(<DIR>)(\s+)(.*)$/) do |m|
          token Comment::Single,  m[1]
          token Text,             m[2]
          token Keyword,          m[3]
          token Text,             m[4]
          token Name::Class,      m[5]
        end

        # 4. dir 출력 — 파일 라인
        rule(/^(\d{2}\/\d{2}\/\d{4}\s+\d{2}:\d{2}\s+[AaPp][Mm])(\s+)([\d,]+)(\s+)(.*)$/) do |m|
          token Comment::Single,  m[1]
          token Text,             m[2]
          token Literal::Number,  m[3]
          token Text,             m[4]
          token Generic::Output,  m[5]
        end

        # 5. dir 요약
        rule(/^\s+(\d[\d,]*)\s+(File\(s\)|Dir\(s\))(.*)$/) do |m|
          token Literal::Number,  m[1]
          token Generic::Output,  m[2]
          token Generic::Output,  m[3]
        end

        # 6. 에러 / 경고
        rule(/^.*(?:'.*' is not recognized|is not recognized as an internal or external command|Access is denied|The system cannot find).*$/, Generic::Error)
        rule(/^.*(?:ERROR:|error:).*$/, Generic::Error)
        rule(/^.*(?:WARNING:|warning:).*$/, Generic::Emph)

        # 7. cmake 진행 라인
        rule(/^(\[\s*\d+%\])(\s+)(Building|Linking|Compiling|Scanning|Generating|Archiving|Installing|Built target)(.*)$/) do |m|
          token Generic::Strong,  m[1]
          token Text,             m[2]
          token Keyword,          m[3]
          token Generic::Output,  m[4]
        end

        rule(/^(\[\s*\d+%\])(.*)$/) do |m|
          token Generic::Strong,  m[1]
          token Generic::Output,  m[2]
        end

        # 8. cmake -- 메시지
        rule(/^(--)(\s+)(.*)$/) do |m|
          token Comment::Single,  m[1]
          token Text,             m[2]
          token Generic::Output,  m[3]
        end

        # 9. 프롬프트 없이 PowerShell Verb-Noun 명령어로 시작
        rule(PS_START_RE) { push :ps_command }

        # 10. 프롬프트 없이 CMD/공통 명령어로 시작
        rule(CMD_START_RE) { push :cmd_command }

        # 10-1. ./script, ~/script, /usr/bin/script 로 시작하는 실행
        rule(/^(?:(?:\.{1,2}|~)?\/[^\s;|&>]+)(?=\s|$)/) do |m|
          token Name::Namespace, m[0]
          push :cmd_command
        end

        # 11. inline fallback
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+/, Literal::Number)
        rule(/./, Generic::Output)
        rule(/\n/, Text)
      end

      state :cmd_command do
        # 라인 연속: \ + \n → pop 없이 다음 줄도 유지
        rule(/\\\n/) { token Text, "\\\n" }

        # 인라인 주석: cmd arg # comment
        rule(/#[^\n]*/) { |m| token Comment::Single, m[0] }

        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        rule(CMD_CMD_RE, Name::Builtin)

        # /S /Q /F:value 플래그
        rule(/\/[A-Za-z0-9:\.]+/, Name::Decorator)

        # 긴 플래그: --flag=VALUE (값 분리)
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)(\/[^\s;|&>]*)/) do |m|
          token Name::Decorator,  m[1]
          token Punctuation,      m[2]
          token Name::Namespace,  m[3]
        end
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)([^"'\s]+)/) do |m|
          token Name::Decorator,   m[1]
          token Punctuation,       m[2]
          token Literal::String,   m[3]
        end
        rule(/--[A-Za-z][A-Za-z0-9\-]*/, Name::Decorator)

        # 짧은 플래그: -flag=VALUE (값 분리)
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

        # URL: https://..., git+https://...
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?https?:\/\/[^\s;|&>]+/, Name::Namespace)
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?git:\/\/[^\s;|&>]+/, Name::Namespace)

        # Windows 경로
        rule(/[A-Za-z]:\\[^\s"'|&;,)]*/, Name::Namespace)
        rule(/\.\.?\\[^\s"'|&;,)]*/, Name::Namespace)

        # Unix 스타일 상대 경로
        rule(/(?:\.\.?|~)\/[^\s;|&>]*/, Name::Namespace)

        # bare 상대 경로: src/foo.cpp
        rule(/[A-Za-z_][A-Za-z0-9_.+-]*(?:\/[^\s;|&>]+)+/, Name::Namespace)

        # dotted config key: virtualenvs.in-project, http.sslverify
        rule(/[A-Za-z_][A-Za-z0-9_-]*(?:\.[A-Za-z0-9_-]+)+/, Name::Namespace)

        # 파일명: main.out, foo.cpp — 단, foo.bar-baz 는 제외
        rule(/[A-Za-z_][A-Za-z0-9_+-]*\.[A-Za-z][A-Za-z0-9]*(?![A-Za-z0-9_-])/, Name::Namespace)

        # boolean 값: true, false, yes, no, on, off
        rule(/\b(?:true|false|yes|no|on|off)\b/, Keyword::Constant)

        # 문자열
        rule(/"[^"\n]*"/, Literal::String)
        rule(/'[^'\n]*'/, Literal::String)

        # %환경변수%
        rule(/%[A-Za-z_][A-Za-z0-9_]*%/, Name::Variable)

        rule(/\d+/, Literal::Number)
        rule(/[&|]/, Operator)
        rule(/[ \t]+/, Text)
        rule(/[A-Za-z_\.][A-Za-z0-9_\-\.]*/, Generic::Output)
        rule(/./, Generic::Output)
      end

      state :ps_command do
        # 라인 연속: \ + \n → pop 없이 다음 줄도 유지
        rule(/\\\n/) { token Text, "\\\n" }

        # 인라인 주석: cmd arg # comment
        rule(/#[^\n]*/) { |m| token Comment::Single, m[0] }

        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        rule(PS_CMD_RE,  Name::Builtin)
        rule(CMD_CMD_RE, Name::Builtin)

        # 긴 플래그: --flag=VALUE (값 분리)
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)(\/[^\s;|&>]*)/) do |m|
          token Name::Decorator,  m[1]
          token Punctuation,      m[2]
          token Name::Namespace,  m[3]
        end
        rule(/(--[A-Za-z][A-Za-z0-9\-]*)(=)([^"'\s]+)/) do |m|
          token Name::Decorator,   m[1]
          token Punctuation,       m[2]
          token Literal::String,   m[3]
        end
        rule(/--[A-Za-z][A-Za-z0-9\-]*/, Name::Decorator)

        # 짧은 플래그: -flag=VALUE (값 분리)
        rule(/(-[A-Za-z][A-Za-z0-9]*)(=)(\/[^\s;|&>]*)/) do |m|
          token Name::Decorator,  m[1]
          token Punctuation,      m[2]
          token Name::Namespace,  m[3]
        end
        rule(/(-[A-Za-z][A-Za-z0-9]*)(=)([^"'\s]+)/) do |m|
          token Name::Decorator,   m[1]
          token Punctuation,       m[2]
          token Literal::String,   m[3]
        end
        rule(/-[A-Za-z][A-Za-z0-9]*/, Name::Decorator)

        # URL: https://..., git+https://...
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?https?:\/\/[^\s;|&>]+/, Name::Namespace)
        rule(/(?:[a-z][a-z0-9+\-.]*\+)?git:\/\/[^\s;|&>]+/, Name::Namespace)

        rule(/[A-Za-z]:\\[^\s"'|;,)]*/, Name::Namespace)
        rule(/\.\.?\\[^\s"'|;,)]*/, Name::Namespace)
        rule(/(?:\.\.?|~)\/[^\s;|&>]*/, Name::Namespace)

        # bare 상대 경로: src/foo.cpp
        rule(/[A-Za-z_][A-Za-z0-9_.+-]*(?:\/[^\s;|&>]+)+/, Name::Namespace)

        # dotted config key: virtualenvs.in-project, http.sslverify
        rule(/[A-Za-z_][A-Za-z0-9_-]*(?:\.[A-Za-z0-9_-]+)+/, Name::Namespace)

        # 파일명: main.out, foo.cpp — 단, foo.bar-baz 는 제외
        rule(/[A-Za-z_][A-Za-z0-9_+-]*\.[A-Za-z][A-Za-z0-9]*(?![A-Za-z0-9_-])/, Name::Namespace)

        # boolean 값: true, false, yes, no, on, off
        rule(/\b(?:true|false|yes|no|on|off)\b/, Keyword::Constant)

        rule(/"[^"\n]*"/, Literal::String)
        rule(/'[^'\n]*'/, Literal::String)

        rule(/\$(?:env:[A-Za-z_][A-Za-z0-9_]*|[A-Za-z_][A-Za-z0-9_]*)/, Name::Variable)

        rule(/\d+/, Literal::Number)
        rule(/[|;]/, Operator)
        rule(/[ \t]+/, Text)
        rule(/[A-Za-z_][A-Za-z0-9_\-\.]*/, Generic::Output)
        rule(/./, Generic::Output)
      end
    end
  end
end
