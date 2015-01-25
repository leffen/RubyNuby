# Fortsetter der vi slapp...
require 'klasse2.rb' 

# Arv - alle studenter er en submengde av alle personer
class Student < Person
  def initialize( etternavn, fornavn, alder = 0, 
		  studiested = "NTNU" )
    # kall super-klassens versjon av metoden
    super( etternavn, fornavn, alder )
    @studiested = studiested
    @karakterer = [] # Eventuelt Array.new
  end
  
  # redefinerer Person#to_s metoden
  def to_s
    "#{@etternavn}, #{@fornavn} - studerer ved #{@studiested}."
  end

  def ta_eksamen( karakter )
    @karakterer.push karakter
  end

  def karaktersnitt
    sum = 0
    @karakterer.each{ |karakter|
      sum += karakter
    }
    sum.to_f / @karakterer.size
  end
  
end

if __FILE__ == $0 # Kun når vi kjører denne filen:
  flinkis = Student.new("Einstein", "Al", 128, "Mensa")
  flinkis.ta_eksamen( 1.0 )
  flinkis.ta_eksamen( 2.0 )
  puts flinkis #=> "Einstein, Al - studerer ved Mensa."
  puts flinkis.karaktersnitt #=> 1.5
end
