## <CODE>
require 'drb'
DRb.start_service
tjener = DRbObject.new( nil, 'druby://localhost:4242' )
svar = tjener.si_hei
print "Fikk fra tjener: '", svar, "'.\n"
## </CODE>
