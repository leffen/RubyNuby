## <CODE>
streng = "Hvil i fred."

# Vi gir en block som skal kjøres når streng objektet dør.
ObjectSpace.define_finalizer(streng){|id|
  puts "Objektet med ID=#{id} er nå dødt. "
  puts "Rest in peace."
}

# Starter søppeltømmeren eksplisitt.
puts "Henter søppel!"
GC.start
# Men ingenting skjer, da det ennå er en referanse til strengen.

# Prøver en gang til...
streng = nil
puts "Henter mer søppel!"
GC.start
# finalizer blocken blir kjørt.
## </CODE>
