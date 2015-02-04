## <CODE>
# Pakker sandkasselekingen i en metode slik at det 
# ikke vil være (mange) variabler tilgjengelig i konteksten.
def sandkasse_lek( kode )
  sandkasse = Thread.new do
    # "evil" eval kan være skummel, så la oss være paranoide.
    $SAFE = 4   # Nivå 1-3 lar oss ikke bruke eval på  
    eval kode   # besudlet data, men det gjør nivå 4!
  end
  print 'Koden din returnerte: ', sandkasse.value.inspect, "\n"
end

begin
  print 'Skriv inn vilkårlig Ruby-kode: '
  kildekode = gets.chomp              # Brukerdata er tainted.
  sandkasse_lek( kildekode )
end while kildekode.size.nonzero?
## </CODE>
