# Setter opp MySQL tabellene i testdatabasen, forutsatt at
# det har blitt opprettet MySQL-brukere med nødvendig rettigheter
# på databasen.

require 'dbi'
require 'getoptlong'

class Testdatabase

  # Kommandoer for å sette opp databasen
  Schema_commands = [
  "DROP TABLE person",
  "CREATE TABLE person ( 
    brukerid int unsigned NOT NULL auto_increment,
    brukernavn text, 
    etternavn text,
    fornavn text,
    passord text,
    epost text,
    klarering int unsigned default 0,  
    PRIMARY KEY  (brukerid)
  )",
  "DROP TABLE kurs",
  "CREATE TABLE kurs (
    kursid int unsigned NOT NULL auto_increment,
    tittel      text,
    beskrivelse text,
    url         text,
    dato date,
    kursholder int unsigned,  # referanse inn i person
    PRIMARY KEY  (kursid)
   )",
  "DROP TABLE deltaker",
  "CREATE TABLE deltaker (
    kursid   int unsigned NOT NULL,
    brukerid int unsigned NOT NULL,
    PRIMARY KEY (kursid, brukerid)
   )",
  "DROP TABLE nyhet",
  "CREATE TABLE nyhet (
    nyhetsid int unsigned NOT NULL auto_increment,
    tittel   text,
    innhold  text,
    forfatter int unsigned NOT NULL,
    kursid int unsigned,
    PRIMARY KEY (nyhetsid)
   )"
  ]
  # Dummy data for testing
  Dummy_data_commands = [
  "INSERT INTO person VALUES(1,'ola',   'Nordmann', 'Ola',   'ola',   '',0)",
  "INSERT INTO person VALUES(2,'kari',  'Nordmann', 'Kari',  'kari',  '',0)",
  "INSERT INTO person VALUES(3,'per',   'Nordmann', 'Per',   'per',   '',0)",
  "INSERT INTO person VALUES(4,'werner','Webguru',  'Werner','werner','',0)",
  "INSERT INTO person VALUES(5,'hilde', 'Håtemel',  'Hilde', 'hilde', '',0)",
  "INSERT INTO person VALUES(6,'arne',  'Admin',    'Arne',  'arne',  '',1)",
  "INSERT INTO kurs VALUES (1, 'HTML kurs', 
     'Hvordan skrive HTML som validerer _og_ ser pen ut.', 
     'http://validator.w3.org', '2003-04-01', 4 )",
  "INSERT INTO kurs VALUES (2, 'Nordmann slekten og identiet.',
     'Hvorfor er det så mange Ola Nordmann i Norge og 
      hvordan unngå identitetskriser.',
     '','2003-06-01',1)",
  # HTML kurset
  "INSERT INTO deltaker VALUES (1,2)",
  "INSERT INTO deltaker VALUES (1,3)",
  "INSERT INTO deltaker VALUES (1,5)",
  # Nordmann seminaret
  "INSERT INTO deltaker VALUES (2,1)",
  "INSERT INTO deltaker VALUES (2,2)",
  "INSERT INTO deltaker VALUES (2,3)",
  "INSERT INTO nyhet VALUES (1,'HTML kurs muligens avlyses',
    'Kurset avlyses dersom foredragsholder ikke blir bedre før oppstart.
     Han ligger for tiden på sykehuset med hodeskader og mumler
     usammenhengende om nettlesere, kombinert med spasmer når 
     Internet Explorer nevnes.', 6, 1)",  
  "INSERT INTO nyhet VALUES (2,'Navnelapper',
     'I lys av fjorårets fiasko, oppfordrer vi alle som heter Ola til 
      å ikke bruke navnelapper på møtet. Unike nummer deles ut ved 
      inngangen.',6,2)",    
  ]

  def initialize( login )
    @login = login
    @schema_commands     = Schema_commands
    @dummy_data_commands = Dummy_data_commands
  end


  # Kjør en linje
  def do_one_line( command )
    begin
      @dbh.do( command )
      log( command )
    rescue DBI::DatabaseError => dberr
      log( "-- ## " + command + " #=> "+dberr.to_s )
      raise unless /DROP/.match( command )  
    end
  end    

  def log( what )
    log_write( what,";\n")
  end

  def comment( what )
    log_write( '-- ## ', what,"\n")
  end

  def log_write( *what )
    @utfil.print( *what ) if @utfil
  end

  def generer
    begin
      login = @login
      filnavn = login['output']
      if filnavn
        @utfil = File.open( filnavn, 'w' )
      end
      
      DBI.connect("DBI:Mysql:database=#{login['database']};" +
                  "host=#{login['host']}", 
                  login['username'], login['password']) do |dbh|
        @dbh = dbh

        per_command = self.method(:do_one_line)

        comment "################################"
        %w{database host username}.each{|word|
          comment "#{word.capitalize}: '#{login[word]}'"
        }

        comment "################################"
        comment "## Tabelldefinisjoner"
        @schema_commands.each &per_command

        comment "################################"
        comment "## Dummy dataverdier for testing"
        @dummy_data_commands.each  &per_command
            
        # Kjapp test
        dbh.select_all('select * from person') do | row |
          p row
        end    

        comment "################################"
        comment "Generert: #{Time.now}"

      end      
    rescue Exception => e
      print "Feilmelding: ", e ,"\n", e.backtrace.join("\n"), "\n"
    ensure
      @dbh = nil
      @utfil.close if @utfil
      @utfil = nil
    end    
  end

end


USAGE = <<USAGE
___________________[Ruby.web_nuby.setup_db]___________________
Sett opp tabeller og testdata i eksisterende database.
Bruk: 
ruby setup_db.rb [-u username] [-d database] [-o output] [--host uri] [-p]
Opsjoner:
 -u, --username    Brukernavn til databasen.
 -d, --database    Navn på databasen.
 -o, --output      Fil som kommandoene logges til. (SQL kode)
 -H, --host        URI til MySQL serveren.
 -p, --password    Prompt for passord.

USAGE


# Default values
realuser = ENV['USER']
login = {
  'database' => realuser+'_rubynuby_webapp',
  'username' => realuser+'_admin',
  'password' => 'w3bRg0y1',
  'host'     => 'mysql.pvv.ntnu.no',
#  'output'   => 'skjema.sql'
}

# Get the commandline options
opt = GetoptLong.new(	
                     ["--username","-u",GetoptLong::REQUIRED_ARGUMENT],
                     ["--database","-d",GetoptLong::REQUIRED_ARGUMENT],
                     ["--password","-p",GetoptLong::NO_ARGUMENT],
                     ["--output",  "-o",GetoptLong::REQUIRED_ARGUMENT],
                     ["--host",    "-H",GetoptLong::REQUIRED_ARGUMENT],
                     ["--help",    "-h",GetoptLong::NO_ARGUMENT]
                     )
# Overwrite default values if necessary
opt.each{|opt,arg|
  s = /\-\-([a-z]*)/.match(opt)[1].to_s
  case s
  when 'password' 
    print "Enter password:"
    password = gets.chomp
    login['password']=password
  when 'help'
    puts USAGE
    exit
  else
    login[s] = arg
  end
}

test = Testdatabase.new( login )
test.generer
