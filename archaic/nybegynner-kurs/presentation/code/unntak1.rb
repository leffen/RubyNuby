## <CODE>
$livvakter = true

def hent_kongen
  if $livvakter
    puts "Kanskje kommer Kongen..."
  else
    raise SecurityError, "Redd for bløtekake."
  end
end

begin
  hent_kongen #=> "Kanskje kommer Kongen..."
  $livvakter = false
  hent_kongen #=> "Niks: Redd for bløtekake."
rescue SecurityError => error
  puts "Niks: #{error}"
end
## </CODE>