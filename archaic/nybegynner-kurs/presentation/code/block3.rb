# Lager ett Proc-objekt av en block.
p = proc do |i| 
  puts "Hei #{i}!" 
end

# Vi kan kalle Proc'en eksplisitt...
p.call('Jens') #=> "Hei Jens!"

# Bruke den som block...
[1,2,3].each(&p) 

# & prefikset gjør en evt. block om til et Proc-objekt.
def tar_block(a, &block)
  block.call(a)
end

tar_block(5) do |b| 
  puts  "Hallo #{b}."
end #=> "Hallo 5."
