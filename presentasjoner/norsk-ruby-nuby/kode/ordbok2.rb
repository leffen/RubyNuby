# Nøsting av hash
treet = {
  rot: {
    stamme: {
      grener: [
        {blader: 'grønne', knopper: 'spirende'},
        {blader: 'gule'},
        {blader: 'røde',   bladlus: 'døende'},
        {blader: 'brune'},
        {blader: false, insekter: nil},
        {snø: 'kald'},
      ]
    }
  }
}

puts "Bladene på treet har gjennom året"
treet[:rot][:stamme][:grener].each do |gren|
  dikt = gren.collect do |key, verdi|
    if verdi
      "#{verdi} #{key}"
    else
      "ingen #{key}"
    end
  end.compact.join(' med ')
  puts dikt
end
