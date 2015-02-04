## <CODE>
# String objekter kan endres:
navn = "Ola Nordmann"

# Kjønnsoperasjon?
nyttnavn = navn.sub("Ola", "Oline")

# sub lager ett nytt String objekt.
puts nyttnavn #=> "Oline Nordmann"
puts navn     #=> "Ola Nordmann"

# sub! (sub-bang) endrer selve streng objektet
nyttnavn = navn.sub!("Ola", "Oline")
puts nyttnavn #=> "Oline Nordmann"
puts navn     #=> "Oline Nordmann"
## </CODE>
