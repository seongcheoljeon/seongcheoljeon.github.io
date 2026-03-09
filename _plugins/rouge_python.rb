# Custom Rouge lexer for Python with semantic token classification.
#
# Extends the built-in Python lexer with a 2-pass analysis:
#   1st pass — collect module names, imported symbols, local variables,
#               function params, loop vars, with-as vars
#   2nd pass — re-emit .n tokens with semantic roles
#
# Token mapping:
#   Name::Namespace          (.nn) → module names                   (asyncio, os, sys)     연초록  #b8d7a3
#   Name::Class              (.nc) → PascalCase import / class name (Request, TaskGroup)   금색    #ffd700
#   Name::Function           (.nf) → function / method names        (fetch, main)          주황    #ff8000  italic
#   Name::Builtin            (.nb) → lowercase import symbols       (urlopen, time)        teal    #4ec9b0
#   Name::Variable::Instance (.vi) → local vars / params / loop vars                       황록    #bdb76b  bold
#   Name::Attribute          (.na) → attribute access after '.'     (response.read)        하늘색  #9cdcfe
#   Name                     (.n)  → fallback                                               금색    #ffd700

require "rouge"
require "set"

module Rouge
  module Lexers
    class EnhancedPython < Python
      title "Enhanced Python"
      desc  "Python with improved semantic token classification (variables, modules, imports)"

      tag     "python"
      aliases "py", "python3"

      # ------------------------------------------------------------------
      # Token aliases
      # ------------------------------------------------------------------
      T_NAME    = Token::Tokens::Name
      T_NAME_F  = Token::Tokens::Name::Function
      T_NAME_C  = Token::Tokens::Name::Class
      T_NAME_NS = Token::Tokens::Name::Namespace           # .nn  연초록
      T_NAME_VI = Token::Tokens::Name::Variable::Instance  # .vi  황록색 bold
      T_NAME_B  = Token::Tokens::Name::Builtin             # .nb  teal
      T_NAME_NA = Token::Tokens::Name::Attribute           # .na  하늘색
      T_KW      = Token::Tokens::Keyword
      T_KW_NS   = Token::Tokens::Keyword::Namespace        # import, from
      T_KW_DECL = Token::Tokens::Keyword::Declaration      # def, class
      T_PUNC    = Token::Tokens::Punctuation
      T_TEXT    = Token::Tokens::Text
      T_OP      = Token::Tokens::Operator
      T_OP_W    = Token::Tokens::Operator::Word            # in, not, and, or, is

      # ------------------------------------------------------------------
      # Helper: skip whitespace/text tokens
      # ------------------------------------------------------------------
      def skip_ws(tokens, i)
        i += 1 while i < tokens.size && tokens[i][0] == T_TEXT
        i
      end

      # ------------------------------------------------------------------
      # Override stream_tokens for 2-pass semantic analysis
      # ------------------------------------------------------------------
      def stream_tokens(code, &block)
        # ----------------------------------------------------------------
        # Step 1: base tokenization
        # ----------------------------------------------------------------
        raw = []
        super(code) { |tok, val| raw << [tok, val] }

        # ----------------------------------------------------------------
        # Step 2: 1st pass — collect semantic sets
        # ----------------------------------------------------------------
        local_vars    = Set.new  # assigned / param / loop / with-as vars
        local_modules = Set.new  # import X  /  from X import ...
        local_imports = Set.new  # from X import Y, Z  (Y, Z)
        local_classes = Set.new  # class Foo  (used for assignment exclusion)

        i = 0
        while i < raw.size
          tok, val = raw[i]

          # ── import asyncio  (plain import) ────────────────────────────
          # 'from X import Y' 패턴 구분: 같은 라인을 역방향 스캔해 'from' 키워드 존재 확인
          if tok == T_KW_NS && val == 'import'
            k = i - 1
            is_from = false
            while k >= 0
              break if raw[k][0] == T_TEXT && raw[k][1].include?("\n")
              if raw[k][0] == T_KW_NS && raw[k][1] == 'from'
                is_from = true
                break
              end
              k -= 1
            end
            unless is_from
              j = skip_ws(raw, i + 1)
              local_modules.add(raw[j][1]) if j < raw.size && raw[j][0] == T_NAME
            end
          end

          # ── from urllib.request import Request, urlopen ───────────────
          if tok == T_KW_NS && val == 'from'
            # 모듈명 수집 (urllib.request 같이 점 포함된 단일 토큰)
            j = skip_ws(raw, i + 1)
            if j < raw.size && (raw[j][0] == T_NAME || raw[j][0] == T_NAME_NS)
              local_modules.add(raw[j][1])
            end
            # 'import' 키워드까지 스킵
            j = i + 1
            j += 1 while j < raw.size &&
                          !(raw[j][0] == T_KW_NS && raw[j][1] == 'import')
            j += 1  # 'import' 스킵
            # import 심볼 수집 (newline 전까지)
            while j < raw.size
              t2, v2 = raw[j]
              break if t2 == T_TEXT && v2.include?("\n")
              if t2 == T_NAME || t2 == T_NAME_C || t2 == T_NAME_F || t2 == T_NAME_NS
                local_imports.add(v2)
              end
              j += 1
            end
          end

          # ── class Foo ─────────────────────────────────────────────────
          if (tok == T_KW || tok == T_KW_DECL) && val == 'class'
            j = skip_ws(raw, i + 1)
            local_classes.add(raw[j][1]) if j < raw.size
          end

          # ── def func(a, b, c=default, *args, **kwargs) ────────────────
          if (tok == T_KW || tok == T_KW_DECL) && val == 'def'
            j = skip_ws(raw, i + 1)
            j += 1 while j < raw.size &&
                          !(raw[j][0] == T_PUNC && raw[j][1].include?('('))
            # 파라미터 수집 (닫는 ')' 전까지)
            depth = 1
            j += 1
            while j < raw.size && depth > 0
              t2, v2 = raw[j]
              if t2 == T_PUNC
                depth += v2.count('(')
                depth -= v2.count(')')
              end
              if t2 == T_NAME && depth > 0
                k2 = j - 1
                k2 -= 1 while k2 >= 0 && raw[k2][0] == T_TEXT
                unless k2 >= 0 && raw[k2][0] == T_PUNC && raw[k2][1] == '.'
                  local_vars.add(v2)
                end
              end
              j += 1
            end
          end

          # ── for x in / for x, y in ───────────────────────────────────
          if tok == T_KW && val == 'for'
            j = skip_ws(raw, i + 1)
            while j < raw.size
              t2, v2 = raw[j]
              break if (t2 == T_OP_W && v2 == 'in') ||
                       (t2 == T_KW   && v2 == 'in') ||
                       (t2 == T_OP   && v2 == 'in')
              local_vars.add(v2) if t2 == T_NAME
              j += 1
            end
          end

          # ── with ... as x ─────────────────────────────────────────────
          if tok == T_KW && val == 'as'
            j = skip_ws(raw, i + 1)
            local_vars.add(raw[j][1]) if j < raw.size && raw[j][0] == T_NAME
          end

          # ── X = ...  (assignment) ─────────────────────────────────────
          if tok == T_NAME
            j = skip_ws(raw, i + 1)
            if j < raw.size && raw[j][0] == T_OP && raw[j][1] == '='
              k2 = i - 1
              k2 -= 1 while k2 >= 0 && raw[k2][0] == T_TEXT
              preceded_by_dot = k2 >= 0 && raw[k2][0] == T_PUNC && raw[k2][1] == '.'
              unless preceded_by_dot ||
                     local_classes.include?(val) ||
                     local_modules.include?(val)
                local_vars.add(val)
              end
            end
          end

          i += 1
        end

        # ----------------------------------------------------------------
        # Step 3: 2nd pass — emit with semantic classification
        # ----------------------------------------------------------------
        raw.each_with_index do |(tok, val), idx|
          if tok == T_NAME || tok == T_NAME_NS
            # '.' 뒤에 오는 식별자 → attribute
            k = idx - 1
            k -= 1 while k >= 0 && raw[k][0] == T_TEXT
            preceded_by_dot = k >= 0 && raw[k][0] == T_PUNC && raw[k][1].end_with?('.')

            new_tok = if preceded_by_dot
              T_NAME_NA  # .na  하늘색  (attribute / method)
            elsif local_vars.include?(val)
              T_NAME_VI  # .vi  황록색 bold
            elsif local_modules.include?(val)
              T_NAME_NS  # .nn  연초록
            elsif local_imports.include?(val)
              val =~ /\A[A-Z]/ ? T_NAME_C : T_NAME_B  # PascalCase → 금색, lowercase → teal
            else
              tok == T_NAME_NS ? T_NAME_NS : T_NAME  # 베이스 .nn 유지 또는 .n fallback
            end
            block.call(new_tok, val)
          else
            block.call(tok, val)
          end
        end
      end
    end
  end
end
