# Hash map / dictionary
ordbok = {
  'ruby'    => 'Edelsten eller språk',
  'python'  => 'Reptil eller språk',
  :pi       => 'Matematisk symbol',
  alpha:    'Gresk symbol for bokstaven A',
}

# Oppslag 
ordbok['ruby']
ordbok[:alpha]
ordbok[:beta]   #=> nil # fordi nøkkelen ikke finnes
ordbok[:pi]
ordbok['pi']    #=> nil # fordi Symbol og String er forskjellig

ordbok['python'] = 'Mener du som i Monty Python?'   # Overskriver
ordbok[:e] = Math::E    # Legger til
ordbok[:pi] ||= 3.142   # Overskrives ikke, da den allerede finnes

tekst = ordbok.map do |ord, beskrivelse|
  "Ordet '#{ord}' er definert som: #{beskrivelse}." if beskrivelse
end.compact.join("\n")
puts tekst
