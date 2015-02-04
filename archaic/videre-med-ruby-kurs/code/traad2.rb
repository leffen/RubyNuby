## <CODE>
pi_traad = Thread.new do
  # Regn ut PI til ørten desimaler ...
  puts 'Regne, regne, regne!'
  sleep 5   # Vanlig student-innsats fra denne tråden...
  Math::PI  # ... og tror du ikke den koker også!
end
puts 'Tråden går i bakgrunnen.'
print 'PI er ', pi_traad.value  # Vent på returverdien fra tråden.
## </CODE>
