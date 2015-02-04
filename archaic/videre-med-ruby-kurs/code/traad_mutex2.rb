## <CODE>
require 'thread'

$delt_teller = 0
$mutex = Mutex.new

traader = (1..10).collect do
  Thread.new do
    10.times do 
      $mutex.synchronize do
        gammel_verdi = $delt_teller
        ny_verdi = gammel_verdi + 1
        sleep 0.0001 # Framtvinge trådproblematikk
        $delt_teller = ny_verdi
      end
    end
  end
end

traader.each{|t| t.join}
puts $delt_teller
##</CODE>
