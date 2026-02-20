require 'rouge'

Rouge::Token::Tokens.constants.sort.each do |cat|
  cat_mod = Rouge::Token::Tokens.const_get(cat)
  next unless cat_mod.is_a?(Module)
  puts cat_mod.to_s
  cat_mod.constants.sort.each do |sub|
    sub_mod = cat_mod.const_get(sub)
    next unless sub_mod.is_a?(Module)
    puts "  #{sub_mod}"
    sub_mod.constants.sort.each do |subsub|
      subsub_mod = sub_mod.const_get(subsub)
      next unless subsub_mod.is_a?(Module)
      puts "    #{subsub_mod}"
    end
  end
end
