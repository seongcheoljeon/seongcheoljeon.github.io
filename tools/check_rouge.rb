require 'rouge'

lexer = Rouge::Lexers::Cpp.new
code = 'std::vector<int> v;'

lexer.lex(code).each do |token, value|
  puts "#{token} => #{value.inspect}"
end
