# Lister
fisketyper = ['torsk', 'laks', 'ørret', 'sei']

pizza  = Array.new
pizza.push 'pepperoni'    # Legge til elementer i listen:
pizza.unshift 'ananas'
pizza << :chorizo
pizza += %w{kylling biff kjøttboller}   # Slå sammen to lister

# Manipulering
puts fisketyper.collect{|fisk| "Jeg liker ikke " + fisk }.join(" ei!\n")

pizza.delete('Ananas')
puts "Jeg vil ha en pizza med #{pizza.join(', ')} og masse ost!"
