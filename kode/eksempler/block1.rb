# En enkel, naiv iterator metode.
def tell_fingre
  yield "Tommel"
  yield "Peke"
  yield "Lange"
  yield "Ringe"
  yield "Lille"
end

# Blocken har tilgang til lokale variabler.
postfix = "finger..."

# Vi sender med en block når vi kaller iterator-metoden.
tell_fingre do |finger|
  puts finger + postfix
end
