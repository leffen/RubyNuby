##<CODE>
r = Apache.request # Hent den gjeldende forespørsel.
gammel_innholdstype = r.content_type
r.content_type = 'text/html'
r.sync=true # Slå på synkron utskrift.
puts '<HTML><BODY>'
puts '<H1>Grave litt rundt i mod_ruby APIen.</H1>'
puts '<P>Gammel innholdstype: ' + gammel_innholdstype
puts '<P>Server versjon: ' + Apache.server_version
puts '<UL>'
sleep 3 # Bare for å vise at synkron utskrift er påslått.
[ :filename,     :protocol,     :request_method, 
  :request_time, :server_name,  :server_port, 
  :status,       :uri,
].each do |symbol|
  print '<LI>', symbol.to_s, ' = ', r.send(symbol), '</LI>'
end
puts '</UL></BODY></HTML>'
##</CODE>
