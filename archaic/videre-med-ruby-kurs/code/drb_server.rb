## <CODE>
require 'drb'
class Tjener
  def si_hei
    puts 'Hei!'
    return 'Hei fra tjeneren!'
  end
end
tjener = Tjener.new
DRb.start_service( 'druby://localhost:4242', tjener )
DRb.thread.join
## </CODE>
