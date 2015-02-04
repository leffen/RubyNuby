#!/usr/local/bin/ruby 

## <CODE>
#!/usr/bin/ruby
require 'cgi'
require 'cgi/session'
c = CGI.new('html4')
sesjon = CGI::Session.new( c, 
  'session_key' => 'rubywebnuby2',
  'prefix' => 'ruby_sesjon.')

# Hent ut antall besøk fra sesjonen
antall_tekst = sesjon['AntallBesok']
antall_besok = (antall_tekst ? antall_tekst.to_i+1 : 0)

# Sett det nye antallet tilbake i sesjonen
sesjon['AntallBesok'] = antall_besok

c.out do 
  c.html do 
    c.body do
     "Du har vært her #{sesjon['AntallBesok']} ganger før."
    end 
  end 
end
## </CODE>

