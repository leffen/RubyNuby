require 'drb'

## <CODE>
require 'drb'
class Parameter
  include DRbUndumped
  def where?
    puts "Parameter #{id} på #{$hvor}."
  end
end

class Tjener

  def initialize
    @tjener_parameter = Parameter.new    
  end
  attr_reader :tjener_parameter
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
    DRb.thread.join
  else
    $hvor = 'Klient'
    DRb.start_service
    puts "----- Hent objekt ------"
    tjener = DRbObject.new( nil, uri )
    fjern_param = tjener.tjener_parameter
    fjern_param.where? 
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
