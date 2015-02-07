# Hash map / dictionary
ordbok = {
  'ruby'    => 'Edelsten eller språk',
  'python'  => 'Reptil eller språk',
  :pi       => 'Matematisk symbol',
  alpha:    'Gresk symbol for bokstaven A'
}

puts ordbok['ruby']
puts ordbok[:alpha]

puts ordbok[:pi]
puts ordbok['pi']   #=> nil # fordi Symbol og String er forskjellig.

tekst = ordbok.map do |ord, beskrivelse|
  "Ordet '#{ord}' er definert som: #{beskrivelse}."
end.join("\n")
puts tekst
