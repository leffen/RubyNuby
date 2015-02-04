#!/store/bin/ruby

## <CODE>
require 'net/smtp'
til = 'kent_dahl@hotmail.com'  # Ikke /dev/null, men nært nok.
fra = 'dittbrukernavn@isp.no.invalid'
Net::SMTP.start('smtp.server.et.sted.invalid') do |smtp|
  tekst = [ "To: #{til}\n", 
    "Subject: En liten test e-post\n", "\n",
    "Hei, hei, alle sammen. Har vi det bra dere?\n"
  ]  
  smtp.sendmail( tekst,  fra, [til] )
end 
## </CODE>
