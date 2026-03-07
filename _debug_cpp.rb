require "rouge"

code = <<~'CODE'
#ifdef _WIN32
#  include <windows.h>
#  define dynlib_open(path) LoadLibraryA(path)
#else
#  include <dlfcn.h>
#  define dynlib_open(path) dlopen(path, RTLD_NOW)
#endif
CODE

lexer = Rouge::Lexers::Cpp.new
lexer.lex(code).each do |token, value|
  next if value =~ /\A\n\z/
  puts "#{token.to_s.ljust(45)} #{value.inspect}"
end
