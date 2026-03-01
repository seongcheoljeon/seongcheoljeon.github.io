require "rouge"
require "strscan"

load File.expand_path("_plugins/rouge_ue_cpp.rb")

code = <<~'CODE'
#pragma once

#if defined(_WIN32) || defined(_WIN64)
  #ifdef MYLIB_EXPORTS
    #define MYLIB_API __declspec(dllexport)
  #else
    #define MYLIB_API __declspec(dllimport)
  #endif
#elif defined(__linux__) || defined(__APPLE__)
  #ifdef MYLIB_EXPORTS
    #define MYLIB_API __attribute__((visibility("default")))
  #else
    #define MYLIB_API
  #endif
#else
  #define MYLIB_API
#endif
CODE

lexer = Rouge::Lexers::UECpp.new
lexer.lex(code).each do |token, value|
  next if token == Rouge::Token::Tokens::Text && value =~ /\A\s*\z/
  puts "#{token.to_s.ljust(45)} #{value.inspect}"
end
