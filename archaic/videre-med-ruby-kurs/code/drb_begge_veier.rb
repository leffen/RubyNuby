## <CODE>
require 'drb'

class Verden
  include DRbUndumped
  def hei    
    puts "Hei verden!"
    self
  end
end

class Tjener
  def verden=(v)
    puts "Sett verden #{v.inspect}"
    @verden = v
  end
  def hei
     puts "Kaller verden #{@verden.inspect}"
    @verden.hei
  end
end

uri = 'druby://localhost:4242'

if ARGV[0]=='tjener' then
  tjener = Tjener.new
  DRb.start_service( uri, tjener )
  DRb.thread.join
else
  DRb.start_service
  tjener = DRbObject.new( nil, uri )
  verden = Verden.new
  tjener.verden = verden
  v = tjener.hei
  puts "--------"
  puts v.inspect, verden.inspect
end
## </CODE>
