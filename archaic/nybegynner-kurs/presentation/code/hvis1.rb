## <CODE>
# Spør først om alderen.
print "Hvor gammel er du?: "
alder = gets.to_i

if alder < 1 then puts "Nå tuller du vel?"; exit end

if alder >= 18
  puts "Du er myndig."
elsif alder >= 16
  puts "Du er lovlig."
else
  puts "Småen!"
end

# 'if' kan også returnere en verdi, så du slipper
# å bruke '?:' operatoren hvis du ikke liker den.
drikkevare = 
  if alder >= 60
    "Sviskejuice"
  else
    if alder >= 20
      "Sprit"
    elsif alder >= 18
      "Øl og vin"
    else
      "Brus"
    end	       
  end
puts "Kjøp deg litt #{drikkevare}"
## </CODE>
