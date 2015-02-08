log = '[25/Apr/2004:09:21:07 +0200] "GET / HTTP/1.1" 200 3145'

r = Regexp.new('\[(\d\d)\/(\w*)\/(\d{4}):' + # dato
               '(\d{2}):(\d{2}):(\d{2})'   + # tidspunkt
               ' ([+-]\d{4})\]'              # tidssone
               )
m = r.match log
puts m[1..7].join(", ") #=> 25, Apr, 2004, 09, 21, 07, +0200
