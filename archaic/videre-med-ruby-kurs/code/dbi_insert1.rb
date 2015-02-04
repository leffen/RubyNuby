#!/usr/bin/ruby


require 'dbi' 
# ... samme login-verdiene som i forrige ...

databasenavn = 'kentda_rubynuby_webapp'
brukernavn   = 'kentda_admin'
passord      = 'etKryptiskPassord'
server       = 'en.mysql.server.et.sted.invalid'


DBI.connect("DBI:Mysql:database=#{databasenavn};host=#{server}", 
            brukernavn, passord) do |dbh|
  # Fortsetter der vi slapp, men med skrivetilgang.

## <CODE>
  # 'do' kjører SQL-uttrykk og returnerer antall rader påvirket.  
  n = dbh.do("INSERT INTO person VALUES (NULL, 'rubynuby1', " + 
             " 'Nuby', 'Ruby', 'r0bY', 'nuby1@ruby.no')")
  puts "Antall rader påvirket av 'do': #{n}"
  
  # 'execute' kan brukes omtrent som 'do', men gir et
  # DBI::StatementHandle tilbake.
  sth = dbh.execute('INSERT INTO person VALUES (NULL, ?, ?, ?, ?, ?)',
                    'rubynuby2', 'Nuby', 'Ruby', 
                    'r0bY', 'nuby2@ruby.no')
  puts "Antall rader påvirket av 'execute': #{sth.rows}"
  sth.finish # Ikke bruker block? Husk å lukke ressurser.

  # 'execute' kan også gi oss et "halvferdig" statement.
  dbh.prepare('INSERT INTO person VALUES (NULL, ?, ?, ?, ?, ?)') do |sth|
    # Kjekt når ting skal gjentas endel...
    sth.execute( 'rubynuby3', 'Nuby', 'Ruby', 'r0bY', 'nuby3@ruby.no')
    sth.execute( 'rubynuby4', 'Nuby', 'Ruby', 'r0bY', 'nuby4@ruby.no')
    sth.execute( 'rubynuby5', 'Nuby', 'Ruby', 'r0bY', 'nuby5@ruby.no')
  end # Møkk lei sth.finish nå!
## </CODE>
end

