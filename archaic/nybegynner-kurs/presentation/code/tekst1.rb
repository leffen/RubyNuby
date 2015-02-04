## <CODE>
# String objekter kan instansieres
navn = String.new("Ruby") # veldig eksplisit, eller
navn = "Ruby"             # implisitt

# Tekst kan adderes...
fornavn   = 'Ola'
etternavn = 'Nordmann'
fullt_navn = etternavn + ', ' + fornavn 
puts fullt_navn #=> "Nordmann, Ola"

#...multipliseres...
"Ah!" * 2 + " Tsjo!" #=> "Ah!Ah! Tsjo!"

#...manipuleres...
"Karakter fire".sub("fire", "en") #=>"Karakter en"
"14.99".to_f #=> 14.99

#...inspiseres...
"TEAMWORK".include?("I")  #=> false
"Kulturuke".index("tur")  #=> 3 
## </CODE>













