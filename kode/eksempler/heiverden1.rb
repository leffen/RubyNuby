# Ett klassisk eksempel
class Verden             # Definer en klasse...
  def si_hei             # med en metode...
    puts 'Hei verden!'   # som skriver ut litt tekst.
  end
end

verden = Verden.new      # Lag en instans av klassen.
verden.si_hei            # Kall en metode på objektet.
