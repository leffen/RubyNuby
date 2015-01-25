# Lager ett Proc-objekt av en block.
p = proc {|i| 
  puts "Hei #{i}!" 
}

# Vi kan kalle Proc'en eksplisitt...
p.call('Jens') #=> "Hei Jens!"

# Bruke den som block...
[1,2,3].each( &p ) 

# & prefikset gjør en evt. block om til et Proc-objekt.
def tar_block( a, &block )
  block.call( a )
end

tar_block(5){|b| 
  puts  "Hallo #{b}."
} #=> "Hallo 5."
