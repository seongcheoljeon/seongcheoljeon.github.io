require "rouge"

load File.expand_path("_plugins/rouge_terminal.rb")

code = 'g++ -std=c++17 -I./include src/A_Module.cpp src/B_Module.cpp -o main.out'

lexer = Rouge::Lexers::Terminal.new
lexer.lex(code).each do |token, value|
  puts "#{token.to_s.ljust(45)} #{value.inspect}"
end

# CMD_START_RE 직접 테스트
puts "\n--- CMD_START_RE match test ---"
re = Rouge::Lexers::Terminal::CMD_START_RE
puts re.match?(code) ? "MATCH" : "NO MATCH"

# g++ 뒤 \b 테스트
puts "\n--- \\b after g++ ---"
puts "g++ test: " + ("g++ foo" =~ /g\+\+\b/ ? "MATCH" : "NO MATCH")
puts "gcc test: " + ("gcc foo" =~ /gcc\b/   ? "MATCH" : "NO MATCH")
