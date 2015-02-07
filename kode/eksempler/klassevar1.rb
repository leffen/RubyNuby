class Bil
  # En klassevariabel for å telle antall biler i verden.
  @@num_biler = 0
  def initialize
    @@num_biler += 1
  end
  def Bil.antall
    @@num_biler
  end
end

class Lada < Bil
end

class Yugo < Bil
  def krasj
    # klassevariabelen er felles for alle instanser av Bil,
    # samt instanser av subklasser av bil
    @@num_biler -= 1
  end
end

lada = Lada.new
yugo = Yugo.new
puts Bil.antall #=> 2

yugo.krasj
puts Bil.antall #=> 1
