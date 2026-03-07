#!/usr/bin/env ruby
# 실행: ruby _debug_escape.rb

$LOAD_PATH.unshift File.join(__dir__, '_plugins')
require 'rouge'
require 'rouge_ue_cpp'

CODE = <<~'CPP'
  // 1. #define 안 문자열
  #define WIN_PATH "C:\\libs"
  #define WIN_PATH2 "C:\libs"

  // 2. 일반 C++ 코드 문자열
  const char* p1 = "C:\\libs";
  const char* p2 = "C:\libs";

  // 3. PATH 설정 느낌
  const char* env = "PATH=\"%PATH%;C:\\libs\"";
CPP

puts "=" * 70
lexer = Rouge::Lexers::UECpp.new
lexer.lex(CODE).each do |tok, val|
  next if tok == Rouge::Token::Tokens::Text && val =~ /\A\s*\z/
  # 문자열 관련 토큰만 출력
  next unless tok.to_s.include?('String') || tok.to_s.include?('Preproc') || val.include?('\\') || val.include?('libs') || val.include?('PATH')
  printf "  %-55s %s\n", tok, val.inspect
end
