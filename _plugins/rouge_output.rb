# Custom Rouge lexer for terminal-style output blocks.
#
# Usage in markdown:
#   ```output
#   error: cannot bind rvalue reference of type 'int&&' to lvalue of type 'int'
#         PrintValue(x);
#   |                ^
#   ```
#
# Token mapping:
#   Generic::Error    (.ge)  → "error:" / "fatal error:" 라벨         (빨간색)
#   Generic::Emph     (.gi)  → "warning:" 라벨                        (노란색)
#   Generic::Strong   (.gs)  → ^ ~ | 마커 / 구분선                   (밝은 초록, bold)
#   Generic::Prompt   (.gp)  → 소스 파일 경로                         (하늘색)
#   Generic::Output   (.go)  → 코드 스니펫 / 일반 출력               (기본 초록)
#   Comment::Single   (.c1)  → "note:" / dim 라인                     (어두운 초록)
#   Keyword::Type     (.kt)  → C++ primitive 타입 (int, bool, ...)    (파란색)
#   Name::Class       (.nc)  → UE / STL 타입 (FString, TArray, ...)  (금색)
#   Operator          (.o)   → &&, &, *, ::                           (회색)
#   Literal::String   (.s)   → 에러 메시지 일반 텍스트               (밝은 흰색)
#   Name::Builtin     (.nb)  → LogXxx: 프리픽스                       (teal)
#   Literal::Number   (.m)   → 숫자, 0x...                            (연두)
#   Punctuation       (.p)   → : ' " 구분자                           (회색)

require "rouge"

module Rouge
  module Lexers
    class Output < RegexLexer
      title "Output"
      desc  "Terminal-style output / compiler error / log block"

      tag     "output"
      aliases "build_output"

      # ------------------------------------------------------------------
      # C++ primitive types
      # ------------------------------------------------------------------
      CPP_PRIMITIVE_TYPES = %w[
        int float double bool char void auto
        long short unsigned signed
        size_t ptrdiff_t nullptr_t intptr_t uintptr_t
        wchar_t char8_t char16_t char32_t
      ].freeze

      # UE / STL 타입 패턴 — [FUATEISN] 대문자로 시작하는 2+ 글자
      UE_TYPE_RE  = /\b[FUATEISN][A-Z][A-Za-z0-9_]+/
      # std::xxx
      STD_TYPE_RE = /\bstd::[A-Za-z_][A-Za-z0-9_:<>]*/

      CPP_PRIM_RE = /\b(?:#{CPP_PRIMITIVE_TYPES.join('|')})\b/

      # ------------------------------------------------------------------
      # Helper: message 상태에서 줄 끝까지 토큰화
      # ------------------------------------------------------------------
      state :message do
        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        # 작은따옴표 안 타입 표현 e.g. 'int&&', 'FString'
        # inner tokenization: push :quoted_type 으로 처리
        rule(/'/) do
          token Punctuation, "'"
          push :quoted_type
        end

        # rvalue / lvalue 키워드
        rule(/\b(?:rvalue|lvalue|prvalue|xvalue|glvalue)\b/, Keyword)

        # UE / STL 타입
        rule(UE_TYPE_RE,  Name::Class)
        rule(STD_TYPE_RE, Name::Class)

        # C++ primitive 타입
        rule(CPP_PRIM_RE, Keyword::Type)

        # 참조/포인터 한정자: &&, &, *
        rule(/&&?|\*/, Operator)

        # 숫자
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+(?:\.\d+)?/, Literal::Number)

        # 나머지 텍스트 — 메시지 본문
        rule(/./, Literal::String)
      end

      # ------------------------------------------------------------------
      # code_snippet state: 컴파일러 출력 안에 삽입된 C++ 코드 라인 토큰화
      # e.g.  "      PrintValue(x);"
      # ------------------------------------------------------------------
      state :code_snippet do
        rule(/\n/) do
          token Text, "\n"
          pop!
        end

        # 함수 호출: 식별자 바로 뒤 '('
        rule(/([A-Za-z_][A-Za-z0-9_]*)(?=\s*\()/) do |m|
          token Name::Function, m[1]
        end

        # C++ 타입 한정자 — 파란색
        rule(/\b(?:const|volatile|mutable|constexpr|consteval|constinit)\b/, Keyword::Type)

        # C++ 키워드
        rule(/\b(?:return|if|else|for|while|do|switch|case|break|continue|
                   new|delete|nullptr|true|false|this|static|auto|
                   inline|virtual|override|final|noexcept|explicit|operator)\b/x,
             Keyword)

        # C++ primitive 타입
        rule(CPP_PRIM_RE, Keyword::Type)

        # UE / STL 타입
        rule(UE_TYPE_RE,  Name::Class)
        rule(STD_TYPE_RE, Name::Class)

        # 문자열 리터럴
        rule(/"[^"\n]*"/, Literal::String)
        rule(/'[^'\n]*'/, Literal::String::Char)

        # 숫자
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+(?:\.\d+)?/, Literal::Number)

        # 연산자
        rule(/->|&&?|\|\|?|[+\-*\/=!<>%^&~]+/, Operator)

        # 구두점
        rule(/[()\[\]{};,.]/, Punctuation)

        # 변수 / 일반 식별자
        rule(/[A-Za-z_][A-Za-z0-9_]*/, Name::Variable::Instance)

        # 공백
        rule(/[ \t]+/, Text)

        # 그 외
        rule(/./, Generic::Output)
      end

      # 작은따옴표 내부 state
      state :quoted_type do
        # 닫는 따옴표 → pop
        rule(/'/) do
          token Punctuation, "'"
          pop!
        end

        rule(/\n/) do
          token Text, "\n"
          pop!
          pop!  # message 도 pop
        end

        # UE / STL 타입
        rule(UE_TYPE_RE,  Name::Class)
        rule(STD_TYPE_RE, Name::Class)

        # C++ primitive 타입
        rule(CPP_PRIM_RE, Keyword::Type)

        # 참조/포인터 한정자
        rule(/&&?|\*|&/, Operator)

        # 그 외 (const, volatile, ...)
        rule(/./, Literal::String)
      end

      # ------------------------------------------------------------------
      # [[ ... ]] 어노테이션 state
      # e.g. [[ T&로 추론됨 ]], [[ const T&로 추론됨 ]]
      # ------------------------------------------------------------------
      state :annotation do
        # 닫는 ]] → pop
        rule(/\]\]/) do
          token Punctuation, ']]'
          pop!
        end

        # const / volatile → 파란색
        rule(/\b(?:const|volatile)\b/, Keyword::Type)

        # UE 타입 (FString 등) → 금색
        rule(UE_TYPE_RE, Name::Class)

        # 템플릿 파라미터: 대문자 시작 식별자 (T, U, Args, Key, Value 등) → 금색
        rule(/\b[A-Z][A-Za-z0-9_]*\b/, Name::Class)

        # &&, &, * → 연회색
        rule(/&&?|\*/, Operator)

        # 그 외 (한국어 포함) → 일반 출력 색
        rule(/./, Generic::Output)

        rule(/\n/) do
          token Text, "\n"
          pop!
        end
      end

      # ------------------------------------------------------------------
      # Root state
      # ------------------------------------------------------------------
      state :root do

        # 0. [[ ... ]] 어노테이션 라인
        rule(/\[\[/) do
          token Punctuation, '[['
          push :annotation
        end

        # 1. 주석 / dim 라인
        rule(/^(?:#|\/\/).*$/, Comment::Single)

        # 2. 구분선 (---- / ==== / ~~~~ 또는 ---- text ---- 형태)
        rule(/^[-=~]{2,}[^\n]*[-=~]{2,}$/, Generic::Strong)
        rule(/^[-=~]{4,}$/, Generic::Strong)

        # 3. "error:" / "fatal error:" 라벨 → message 상태로 진입
        rule(/^((?:fatal )?error)(:)/) do |m|
          token Generic::Error, m[1]
          token Punctuation,    m[2]
          push :message
        end

        # 4. "warning:" 라벨
        rule(/^(warning)(:)/) do |m|
          token Generic::Emph, m[1]
          token Punctuation,   m[2]
          push :message
        end

        # 5. "note:" 라벨
        rule(/^(note)(:)/) do |m|
          token Comment::Single, m[1]
          token Punctuation,     m[2]
          push :message
        end

        # 6. 소스 위치 라인  e.g.  main.cpp:12:5: error: ...
        rule(/^([\w\/\\.]+\.\w+)(:\d+(?::\d+)?:)(.*)$/) do |m|
          token Generic::Prompt,  m[1]
          token Literal::Number,  m[2]
          token Generic::Output,  m[3]
        end

        # 7. ^ ~ | 마커 라인
        rule(/^[\s]*[|^~][\s|^~]*$/, Generic::Strong)

        # 8. UE 로그 라인
        rule(/^(Log\w+)(:\s+)(Warning)(:.*)$/) do |m|
          token Name::Builtin,   m[1]
          token Punctuation,     m[2]
          token Generic::Emph,   m[3]
          token Generic::Output, m[4]
        end

        rule(/^(Log\w+)(:\s+)(Error|Fatal)(:.*)$/) do |m|
          token Name::Builtin,   m[1]
          token Punctuation,     m[2]
          token Generic::Error,  m[3]
          token Generic::Output, m[4]
        end

        rule(/^(Log\w+)(:)(.*)$/) do |m|
          token Name::Builtin,   m[1]
          token Punctuation,     m[2]
          token Generic::Output, m[3]
        end

        # 9. SUCCESS / PASS 라인
        rule(/^.*\b(?:SUCCESS|PASS(?:ED)?|DONE|OK|Succeeded?)\b.*$/i, Generic::Strong)

        # 10. 코드 스니펫 라인 (들여쓰기로 시작하는 C++ 코드)
        rule(/^([ \t]+)(?=[A-Za-z_0-9"'\(])/) do |m|
          token Text, m[1]
          push :code_snippet
        end

        # 11. rvalue / lvalue / value category 키워드 (inline, 모든 라인 적용)
        rule(/\b(?:rvalue|lvalue|prvalue|xvalue|glvalue)\b/, Keyword)

        # 12. C++ 한정자 (inline) — Keyword::Type → 파란색
        rule(/\b(?:const|volatile|mutable|constexpr|consteval|constinit)\b/, Keyword::Type)

        # 13. UE / STL 타입 (inline)
        rule(UE_TYPE_RE,  Name::Class)
        rule(STD_TYPE_RE, Name::Class)

        # 14. C++ primitive 타입 (inline)
        rule(CPP_PRIM_RE, Keyword::Type)

        # 15. 참조/포인터 (inline)
        rule(/&&?|\*/, Operator)

        # 16. 숫자 (inline)
        rule(/0[xX][0-9a-fA-F]+/, Literal::Number)
        rule(/-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?/, Literal::Number)

        # 17. 나머지 — 한 글자씩 일반 출력 색으로
        rule(/./, Generic::Output)

        # 18. 개행
        rule(/\n/, Text)
      end
    end
  end
end
