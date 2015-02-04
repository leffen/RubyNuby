#!/usr/local/bin/ruby 

## <CODE>
#!/usr/bin/ruby
require 'cgi'

# CGI-biblioteket kan også hjelpe deg med å få skrevet HTML-koden.
cgi = CGI.new('html4')
cgi.out {
  cgi.html {
    cgi.head { 
      cgi.title { 'Penere kildekode?' } 
    } + 
    cgi.body {
      cgi.h1 { 'Gjør dette kildekoden penere?' } + 
      cgi.p +
      'Eller får man krøllparentes-overdose?'
    }
  }
}
## </CODE>
