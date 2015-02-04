## <CODE>
print "Er du gutt eller jente?: "
svar = gets.downcase.chomp

# case er også kjent som switch/case i andre språk
case svar
when "intetkjønn" 
  puts "Hei!"
when "jente", "kvinne", "dame"
  puts "Heisann søta!"
when "gutt", "mann", "herre"
  puts "Heisann kjekken!"
else 
  puts "God dag herr/fru?"
end
## </CODE>
