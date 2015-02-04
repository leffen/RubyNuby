require 'dbi'

# Samler litt databasegruff i en klasse.
class Database
  def initialize
    databasenavn = 'kentda_rubynuby_webapp'
    brukernavn   = 'kentda_rubynuby'
    passord      = 'w3bRg0y1'
    server       = 'mysql.pvv.org'

    @dbh = DBI.connect("DBI:Mysql:database=#{databasenavn};host=#{server}", 
                       brukernavn, passord )
  end
  def lukk
    @dbh.disconnect
  end

  ##
  # Logg inn. Returnerer en Hash med informasjon om brukeren, dersom
  # brukernavn og passord stemmer. 
  def logg_inn( brukernavn, passord )
    @dbh.execute('select * from person ' +
                 'where brukernavn=? and passord=?',
                 brukernavn, passord){|sth|
      sth.fetch_hash
    }    
  end

  ##
  # Utility metode, slik at vi slipper duplisert kode i
  # endel av hent_* metodene. En eventuell block vil fungere som
  # filter.
  def hent_array_med_hashtabeller( sth )
    liste = []
    begin
      hash = sth.fetch_hash
      liste << hash if hash and (not block_given? or yield hash)
    end while hash
    liste
  end
  private :hent_array_med_hashtabeller
    
  ##
  # Henter ut en liste fylt med Hash-objekter som 
  # beskriver de forskjellige kursene.
  def hent_kurs( bruker = nil )
    idag = Time.now
    @dbh.execute('select * from kurs ' +
                 'left join deltaker using (kursid) where brukerid=?',
                 bruker['brukerid']) do |sth|
      hent_array_med_hashtabeller(sth){|kurs|
          idag <= kurs['dato'].to_time
      }
    end
  end

  ##
  # Henter alle kurs som holdes innen 30 dager som en liste fylt
  # med Hash-objekter som beskriver de forskjellige kursene.
  def hent_alle_kurs( innen_dager = 30 )
    idag = Time.now
    siste_tid = idag + 60*60*24*innen_dager
    @dbh.execute('select * from kurs') do |sth|
      hent_array_med_hashtabeller(sth){|kurs|
          kurstid = kurs['dato'].to_time
          kurstid >= idag and kurstid <= siste_tid
      }
    end
  end

  ##
  # Hent ut alle nyhetene for et kurs.
  def hent_nyheter( kurs )
    @dbh.execute('select * from nyhet where kursid=?', 
                 kurs['kursid'] ){|sth|
      hent_array_med_hashtabeller(sth)
    }
  end
end
