## <CODE>
require 'drb_videospiller' # Trenger definisjonen til Kontroller
$hvor = 'på soverommet'
DRb.start_service
vcr_tjener = DRbObject.new( nil, 'druby://localhost:4242' )

tjener_utput = vcr_tjener.hent_standard_utput 
puts_begge_steder = proc do |tekst|
  puts tekst
  tjener_utput.puts tekst
end

puts_begge_steder.call('--Fjernkontrollen kan vi ta med inn på soverommet')
fjernkontroll = vcr_tjener.ny_fjernkontroll
p fjernkontroll
fjernkontroll.hvor_er_du? #=> Kontroll: 'Jeg er på soverommet.'
fjernkontroll.start       #=> Videospiller: 'Press play on tape i stua.'

puts_begge_steder.call('--Mens kontrollen som er tett knyttet til ' +
                       "videospilleren\n--må forbli i stua.")
# Så vi får bare en referanse til, og ikke en kopi av, kontrollen.
kontroll = vcr_tjener.ny_kontroll
p kontroll
kontroll.hvor_er_du?  #=> Kontroll: 'Jeg er i stua.'
kontroll.start        #=> Videospiller: 'Press play on tape i stua.'
## </CODE>

