#!/usr/bin/ruby

## <CODE>
require 'dbi' 

databasenavn = 'kentda_rubynuby_webapp'
brukernavn   = 'kentda_rubynuby'
passord      = 'etKryptiskPassord'
server       = 'en.mysql.server.et.sted.invalid'

DBI.connect("DBI:Mysql:database=#{databasenavn};host=#{server}", 
            brukernavn, passord) do |dbh|

  # Et enkelt select-kall hvor hver resultatrad sendes til en block.
  dbh.select_all('select fornavn, etternavn from person') do |rad|
    puts rad.join(', ')
  end  

  # Stedfortreder-argumenter (placeholders) i SQL-uttrykk. 
  soek_etternavn = "Nordma%"
  soek_fornavn = "Ol%"
  dbh.select_all('select brukerid, brukernavn, fornavn, etternavn ' +
                 'from person where etternavn like ? and fornavn like ?', 
                 soek_etternavn, soek_fornavn ) do |rad|
    puts rad.join(', ')
  end  

  # Hent en liste (Array) med alle e-postadressene.
  liste = dbh.select_all('select * from person').collect{|rad| rad['epost'] }
  puts liste.join(', ')

end
## </CODE>
