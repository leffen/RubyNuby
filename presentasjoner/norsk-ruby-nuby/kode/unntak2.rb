begin
  kode_som_kaster_unntak
rescue SecurityError => error
  puts "Sikkerhetsproblem: #{error}"
rescue 
  puts "En eller annen StandardError."
ensure
  puts "Opprydning gjøres okke som."
end
