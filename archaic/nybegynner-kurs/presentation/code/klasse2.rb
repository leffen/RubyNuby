# Vi vil bruke Person-klassen videre
require_relative 'klasse1' 

# Klasser er "åpne" skop, og kan enkelt utvides.
class Person  
  # Ruby tillater deg ikke å få tak i attributtene
  # fra utsiden av objektet. Du må gå via metodekall.

  #  get-metode
  def alder
    @alder
  end
  # set-metode
  def alder=( ny_alder )
    @alder = ny_alder
  end

  # tungvint? Jepp, så Ruby har en snarvei:
  attr_accessor :alder     # definerer metodene over automatisk

  # Vi vil også gjerne kunne lese navnene til personen
  attr_reader   :etternavn, :fornavn

end

if __FILE__ == $0 # Kun når vi kjører denne filen:
  p = Person.new( "Nordmann", "Baby" )
  p.alder = 3     # Vi setter alderen
  puts p.alder    #=> 3
  p.alder += 1    # Øk alderen med et år
  puts p.alder    #=> 4
  puts p.fornavn  #=> "Baby"
end
