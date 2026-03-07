#!/usr/bin/env ruby
# _debug_preproc.rb — dynlib.h #define 토큰 확인
# 실행: ruby _debug_preproc.rb

$LOAD_PATH.unshift File.join(__dir__, '_plugins')
require 'rouge'
require 'rouge_ue_cpp'

CODE = <<~'CPP'
  // dynlib.h — 크로스 플랫폼 동적 로딩 래퍼
  #pragma once

  #ifdef _WIN32
  #  include <windows.h>
     typedef HMODULE DynLib;
  #  define dynlib_open(path)        LoadLibraryA(path)
  #  define dynlib_sym(lib, name)    ((void*)GetProcAddress(lib, name))
  #  define dynlib_close(lib)        FreeLibrary(lib)
  #else
  #  include <dlfcn.h>
     typedef void*  DynLib;
  #  define dynlib_open(path)        dlopen(path, RTLD_NOW | RTLD_LOCAL)
  #  define dynlib_sym(lib, name)    dlsym(lib, name)
  #  define dynlib_close(lib)        dlclose(lib)
  #endif
CPP

lexer = Rouge::Lexers::UECpp.new

# ── 1. RAW tokens (before post-processing) ──────────────────────────────────
puts "=" * 70
puts "RAW tokens (from base Cpp lexer, before UECpp post-processing):"
puts "=" * 70
base_lexer = Rouge::Lexers::Cpp.new
base_lexer.lex(CODE).each do |tok, val|
  next if tok == Rouge::Token::Tokens::Text && val =~ /\A\s*\z/
  printf "  %-55s %s\n", tok, val.inspect
end

# ── 2. POST-PROCESSED tokens (UECpp output) ──────────────────────────────────
puts
puts "=" * 70
puts "POST-PROCESSED tokens (UECpp lexer output):"
puts "=" * 70
lexer.lex(CODE).each do |tok, val|
  next if tok == Rouge::Token::Tokens::Text && val =~ /\A\s*\z/
  printf "  %-55s %s\n", tok, val.inspect
end

# ── 3. Focus: only preproc-related tokens ─────────────────────────────────
puts
puts "=" * 70
puts "PREPROC tokens only (any token on #define lines):"
puts "=" * 70
in_define = false
lexer.lex(CODE).each do |tok, val|
  in_define = true  if val.include?('#') && val.include?('define')
  in_define = false if val == "\n" && in_define
  if in_define || tok.to_s.include?('Preproc') || tok.to_s.include?('Keyword')
    printf "  %-55s %s\n", tok, val.inspect
  end
end
