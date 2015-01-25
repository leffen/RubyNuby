# Tekst kan skrives ut
navn = 'Finn'
puts 'Jeg heter ' + navn

# Liker du ikke puts?
print "Jeg heter " + navn + ".\n"

# Liker du C?
printf "Jeg heter %s!\n", navn

# Forelska i C++?
STDOUT << "Ikke Bjarne... " <<
  "Ikke Jan-Thomas... " <<
  "Jeg heter " << navn << "!!!\n"

# Tekst-streng interpolering.
puts "Jeg heter fremdeles #{navn}"
puts "Jeg blir #{Time.now.year-1978} år i år"
