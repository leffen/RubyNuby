## <CODE>
require 'drb'
class Parameter
  def initialize( streng, tjener )
    @streng, @tjener = streng, DRbObject.new(tjener) #$stdout
  end
  def where?
    puts "Parameter #{id} på #{$hvor} med \n" +
      "streng '#{@streng}' og #{@tjener.type} #{@tjener.id}."
  end
end

class Tjener
  include DRbUndumped
  def initialize
    @tjener_parameter = nil #Parameter.new( "Server streng", self )    
  end
  attr_accessor :tjener_parameter
  attr_accessor :klient_parameter

  def status
    puts "-------"
    print "Tjener parameter #{@tjener_parameter.id} på: "
    @tjener_parameter.where?
    print "Klient parameter #{@klient_parameter.id} på: "
    @klient_parameter.where?
    STDOUT.flush
  end

  def stdout
    puts "STDOUT is-a #{STDOUT.type}."
    STDOUT
  end

end


if $0 == __FILE__ then

  command = ARGV[0]
  uri = 'druby://localhost:4242'

  if command=="tjener"
    $hvor = 'Tjener'
    tjener = Tjener.new
    DRb.start_service( uri, tjener )
    tjener.tjener_parameter = Parameter.new( "Server streng", tjener ) 
    DRb.thread.join
  else
    $hvor = 'Klient'
    DRb.start_service
    puts "----- Hent objekt ------"
    tjener = DRbObject.new( nil, uri )
    fjern_param = tjener.tjener_parameter
    fjern_param.where? 
    gets
    puts "----- Sett fjern parameter -----"
    tjener.klient_parameter = fjern_param
    tjener.status
    puts "----- Sett lokal parameter -----"
    lokal_param = Parameter.new
    tjener.klient_parameter = lokal_param
    tjener.status
    puts "-----  -----"
    stdout = tjener.stdout
    stdout << "Kommer dette opp på serveren?\n"
    puts "stdout is-a #{stdout.type}."
  end

end

## </CODE>
