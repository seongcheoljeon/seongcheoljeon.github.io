require "rouge"
load File.expand_path("_plugins/rouge_output.rb")

code = <<~'CODE'
ModuleNotFoundError: No module named '_lzma'
WARNING: The Python lzma extension was not compiled. Missing the lzma lib?
CODE

lexer = Rouge::Lexers::Output.new
lexer.lex(code).each do |token, value|
  next if token == Rouge::Token::Tokens::Text && value =~ /\A\s*\z/
  puts "#{token.to_s.ljust(50)} #{value.inspect}"
end
