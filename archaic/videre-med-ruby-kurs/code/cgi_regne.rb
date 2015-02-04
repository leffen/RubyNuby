#!/usr/local/bin/ruby 

## <CODE>
#!/usr/bin/ruby
print "Content-type: text/html\r\n\r\n"
# Starter HTML-dokumentet.
print '<html><body>'

# Hent inn CGI-biblioteket.
require 'cgi'
# Lag en instans slik at vi får tak i CGI-variablene.
cgi = CGI.new

# Hent CGI-variablene
x = cgi['x'][0] # Oppslaget returnerer en Array,
y = cgi['y'][0] # så vi plukker ut første element.

# Skriv dem bare ut dersom vi fikk noe.
if (x and x.size.nonzero?) and
   (y and y.size.nonzero?) then
  a = x.to_i # Gjør om til heltall.
  b = y.to_i
  print "#{a} multiplisert med #{b} er ", a*b
end

# Skriv ut et lite skjema.
print '<form>'
print '<input name="x" type="text"> *'
print '<input name="y" type="text"> = '
print '<input type="submit" value="gange">'
print '</form>'

# Avslutter HTML-dokumentet.
print '</body></html>'
## </CODE>
