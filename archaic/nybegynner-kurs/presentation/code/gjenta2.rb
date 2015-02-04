## <CODE>
# Litt mer gøy med matte.
a = nil

# until - gjenta inntil noe blir sant
until a == 0
  print "Skriv inn ett tall (0 avslutter): "
  a = gets.to_i
  puts "#{a} opphøyd i 2      = " + (a**2).to_s
  puts "Kvaderatroten av #{a} = " + (Math.sqrt(a)).to_s 
end
## </CODE>
