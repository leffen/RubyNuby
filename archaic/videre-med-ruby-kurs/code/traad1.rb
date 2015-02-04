## <CODE>
puts 'A1'
traad = Thread.new do
  puts 'B1'
  sleep 2
  puts 'B2'
end
puts 'A2'
puts traad.join  # Vent på at tråden avslutter.
# Utput blir: A1 B1 A2 B2
## </CODE>
