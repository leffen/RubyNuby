# Husker du denne?
def si_hei
  puts "Hei verden!"
end

# Hva er vel en funksjon uten argumenter?
def si_hei_til(hva)
  puts "Hei #{hva}"
end

si_hei_til("Bergen!") #=> "Hei Bergen!"

# Funksjoner kan ta flere argumenter og de kan ha default verdier
def send_julegave(til, fra="nissen")
  puts "God jul, #{til}. Hilsen #{fra}."
end

send_julegave("Junior" )    #=> "God jul, Junior. Hilsen nissen."
send_julegave("Ola", "far") #=> "God jul, Ola. Hilsen far."
