# Hent filnavn fra kommandolinjen.
filnavn = ARGV[0]

# Gamle måten.
fil = File.open( filnavn, "r" )
linjenummer = 0
fil.readlines.each{ |linje|
  linjenummer +=1
  print "#{linjenummer}: #{linje}" 
}
fil.close   # Lukker filen eksplisitt

# Bruk block til ressurs styring.
File.open( filnavn, "r") { |fil|
  linjenummer = 0
  fil.readlines.each{ |linje|
    linjenummer += 1
    print "#{linjenummer}>: #{linje}" 
  }
} 
# File.open lukker filen etter å ha  kjørt koden i blocken.
