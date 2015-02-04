#!/usr/local/bin/ruby 

## <CODE>
puts "Nåværende $SAFE-nivå: #{$SAFE}." 

filnavn = "/etc/hosts"

# Eksempel på potensielt farlig operasjon.
print File.open(filnavn).read.size, " bytes lest.\n"

# La oss simulere en ekstern kilde og øke paranoiaen litt.
filnavn.taint
$SAFE = 1

begin
  print File.open(filnavn).read.size, " bytes lest.\n"
rescue SecurityError => sec_err
  puts sec_err #=> "Insecure operation - open"
end
## </CODE>
