#!/store/bin/ruby

## <CODE>
require 'net/smtp'
Net::SMTP.start('smtp.server.et.sted.invalid') do |smtp|
  til = "kent_dahl@hotmail.com"
  fra = "dittbrukernavn@isp.no.invalid"
  smtp.ready( fra, til ) do |ut|
    ut.write "To: #{til}\n"
    ut.write "Subject: Nok en liten test e-post\n"
    ut.write "\n"
    ut.write "Hei igjen. Ikke sovnet ennu?\n"
  end
end 
## </CODE>
