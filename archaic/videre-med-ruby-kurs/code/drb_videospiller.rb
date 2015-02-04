## <CODE>
require 'drb'
$hvor = 'i stua'
class Videospiller  
  # Gjør slik at Videospiller ikke kan serialiseres.
  include DRbUndumped 
  def start
    puts "Videospiller: 'Press play on tape #{$hvor}.'"
  end

  class Kontroll 
    def initialize( spiller )
      @spiller = spiller
## </CODE>
      type.add_finalizer(self)
## <CODE>
    end    

    def hvor_er_du?
      puts "Kontroll: 'Jeg er #{$hvor}.'"
    end
    def start
      @spiller.start
    end
## </CODE>
    def self.add_finalizer(obj)
      ObjectSpace.define_finalizer(obj){|id|
        puts "#{id} er død."
      }
      obj = nil
    end
## <CODE>
  end # Kontroll

end # Videospiller

class Tjener 
  def initialize
    @spiller = Videospiller.new
  end
  def ny_fjernkontroll     # pass-by-value
    Videospiller::Kontroll.new( DRbObject.new( @spiller ) )  
  end
  def ny_kontroll          # pass-by-reference
    Videospiller::Kontroll.new( @spiller )
  end
  def hent_streng   # pass-by-value
    'En streng, en streng, mitt kongerike for en streng.'
  end
  def hent_standard_utput  # pass-by-reference da IO er en av
    $stdout                # klassene som ikke kan serialiseres.
  end
## </CODE>
  def gc
    GC.start
  end
## <CODE>
end

if __FILE__ == $0 then # Start tjeneren med våre utvidelser, og
  load 'drb_server.rb' # gjenbruker koden fra forrige eksempel.
end
## </CODE>
