require "rouge"

code = "B_Module::~B_Module(){"

lexer = Rouge::Lexers::Cpp.new
lexer.lex(code).each do |token, value|
  puts "#{token.to_s.ljust(40)} #{value.inspect}"
end
