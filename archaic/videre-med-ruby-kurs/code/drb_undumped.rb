## <CODE>
require 'drb'

class Videospiller
  def hent_streng   # pass-by-value
    "En streng, en streng, mitt kongerike for en streng."
  end

  def hent_standard_utput  # pass-by-reference da IO er en av
    $stdout                # klassene som ikke kan serialiseres.
  end

  class Fjernkontroll
    # Gjør slik at Fjernkontroll ikke kan serialiseres.
    include DRbUndumped 
    def start
      puts "Push play on tape."
    end
  end

  def ny_fjernkontroll
    Fjernkontroll.new( self )  # pass-by-reference p.g.a. DRbUndumped
  end

end

Tjener = Videospiller
require 'drb_server.rb' # Start tjeneren med våre utvidelser, og
# gjenbruker koden fra forrige eksempel.
## </CODE>
