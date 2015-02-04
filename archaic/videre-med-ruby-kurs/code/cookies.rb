#!/usr/local/bin/ruby 

## <CODE>
#!/usr/bin/ruby
require 'cgi'
c = CGI.new('html4')

# Hent ut den gamle kaken.
gammel_cookie = c.cookies['rubywebnuby']

# Kurstekst i første element, antall besøk i andre element.
kurs_tekst, antall_tekst = gammel_cookie
antall_besok = if antall_tekst then 
                 antall_tekst.to_i + 1 
               else 0 end

# Lag ny kake.
ny_cookie = CGI::Cookie.new('rubywebnuby',    # Kakenavn.
  'Ruby Web Nuby', antall_besok.to_s          # Verdier.
)

c.out( 'cookie' => [ny_cookie] ) do # Sett kaken via HTTP. 
  c.html do 
    c.body do
      # Print ut de forrige kakene
      gammel_cookie.join(c.br) + 
        "<P>Du har vært her #{antall_besok} ganger før, " +
        "da i forbindelse med #{kurs_tekst} kurs."
    end 
  end 
end
## </CODE>

