#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(__dir__, '_plugins')
require 'rouge'
require 'rouge_terminal'

CODE = <<~'SHELL'
ln -s libcalories.so.1.2.3 libcalories.so.1
ln -s libcalories.so.1     libcalories.so
SHELL

puts "=" * 70
lexer = Rouge::Lexers::Terminal.new
lexer.lex(CODE).each do |tok, val|
  next if tok == Rouge::Token::Tokens::Text && val =~ /\A[ \t]*\z/
  printf "  %-55s %s\n", tok, val.inspect
end
