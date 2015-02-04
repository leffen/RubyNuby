## <CODE>
# La oss skrive ut 3-gange-tabellen
tall = 3

# Ruby har for-løkker som de fleste språk
for i in (1..10)
  puts "#{i} gange #{tall} er #{i*tall}"
end

# 5-gange-tabellen
tall = 5

# men for-løkkens dager er talte. 
# for-løkken over er syntaktisk sukker for
# følgende bruk av iterator-metoden each.
(1..10).each do |i|
  puts "#{i} gange #{tall} er #{i*tall}"
end  
## </CODE>
