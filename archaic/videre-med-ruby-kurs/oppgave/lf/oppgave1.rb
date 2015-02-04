#!/usr/local/bin/ruby

# Kjapt og stygt LF for oppgave 1.

require 'database1.rb'

require 'cgi'
cgi = CGI.new
brukernavn = cgi['brukernavn'][0]
passord    = cgi['passord'][0]
logg_inn = brukernavn && passord && 
  brukernavn.size.nonzero? && passord.size.nonzero?

content_type ='text/html'
if defined? Apache 
  Apache.request.content_type = content_type
else
  puts "Content-type: #{content_type}\r\n\r\n"
end

puts "<html>"

logg_inn_skjerm =
  "
    <p>Vennligst logg inn:
    <form>
    <p>Brukernavn: <input type='text'     name='brukernavn'>
    <p>Passord:    <input type='password' name='passord'>
    <p><input type='submit' value='Logg inn'>
    </form>
  </body>
  "

if not logg_inn then
  puts   "<head><title>Logg inn</title></head><body>"
  puts logg_inn_skjerm
else

  db = Database.new
  # Sjekk opp passordet for å finne brukeren.
  
  bruker = db.logg_inn( brukernavn, passord )

  # Logget inn rett?
  if bruker then
    # Generell velkomst
    puts "<head><title>Velkommen #{bruker['fornavn']}</title></head>"
    puts "<body>"
    puts "<h1>Kurskalender</h1>"
    puts "<p>Velkommen #{bruker['fornavn']} #{bruker['etternavn']}"

    # Er vedkommende påmeldt på noen kurs?
    kursliste = db.hent_kurs( bruker )
    if not kursliste.empty? then
      puts "<h2>Kurs du er påmeldt:</h2><ul>"
      kursliste.each{|kurs|
        puts "<li><b>#{kurs['tittel']}</b>"
        puts " - #{kurs['beskrivelse']}"
        puts " - holdes #{kurs['dato']}"

        # Er det noen nyheter på dette kurset?
        nyheter = db.hent_nyheter kurs
        if not nyheter.empty? then
          puts "<ul>"
          nyheter.each{|nyhet|
            puts "<li><b>#{nyhet['tittel']}</b>"
            puts " - #{nyhet['innhold']}"
            puts "</li>"
          }
          puts "</ul>"
        end

        puts "</li>"
      }
      puts "</ul>"
    end
    paameldtekurs = kursliste.collect{|kurs| kurs['kursid']}

    # Hvilke kurs er tilgjengelig for påmelding?
    kursliste = db.hent_alle_kurs
 
    # Fjern de som allerede er påmeldt (og nevnt over)
    kursliste = kursliste.delete_if{|kurs| 
      paameldtekurs.include? kurs['kursid']
    }

    if not kursliste.empty? then
       puts "<h2>Kurs som holdes den neste måneden:</h2><ul>"
       kursliste.each{|kurs|
        puts "<li><b>#{kurs['tittel']}</b>"
        puts " - #{kurs['beskrivelse']}"
        puts " - holdes #{kurs['dato']}</li>"
      }
      puts "</ul>"
    end

    puts "</body>"
  else
    # Ingen gydlig bruker. Skriv ut feilmelding
    puts "<head><title>Feil brukernavn eller passord!</title></head>"
    puts" <body><p>Feil brukernavn eller passord!"
    puts logg_inn_skjerm
  end

  db.lukk # Lukk ned databasekoblingen. 
end

puts '</html>'

