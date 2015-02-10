class Brett
  # Spillere : 1,2


  def initialize
    @brett = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    @trekk = 0
    @spiller_tur= 1
    @ferdig = false
  end

  def kryss_av spiller, x, y
    if @ferdig
      puts "Spillet er ferdig"
      return
    end


    if spiller != @spiller_tur
      puts "Det er spiller #{@spiller_tur} sin tur. "
      return
    end

    if @trekk >= 9
      puts "Ikke plass til flere trekk"
      return
    end

    if pos_ledig x, y
      @brett[x][y] = spiller
    else
      print "\a"
      return
    end
    @trekk += 1
    @spiller_tur = neste_spiller @spiller_tur
    @ferdig = won?
  end

  def neste_spiller aktiv_spiller

    aktiv_spiller == 1 ? 2 : 1


  end

  def display
    puts "*** #{@trekk} ***"
    @brett.each { |l|
      puts "#{l}"
    }

  end

  def won?
    [1, 2].each { |spiller|
      sum = alle_brettrader.inject(0) { |b, rad|
        ((rad[0]===spiller && rad[1]===spiller && rad[2]===spiller) ? 1 : 0) }

      if (sum>0)
        display
        puts "Spiller #{spiller} vant"
        return true
      end
    }
    false
  end

  def pos_ledig x, y
    @brett[x][y] == 0
  end

  def alle_brettrader
    @brett +
      [
        [@brett[0][0], @brett[1][1], @brett[2][2]],
        [@brett[0][2], @brett[1][1], @brett[2][0]],
        [@brett[0][0], @brett[0][1], @brett[0][2]],
        [@brett[0][1], @brett[1][1], @brett[2][1]],
        [@brett[0][2], @brett[1][2], @brett[2][2]]
      ]
  end

end

class RandomSpiller

  def initialize nr
    @nr = nr
  end

  def forslag_trekk
    [Random.rand(3),Random.rand(3)]
  end

  def foretatt trekk
    @trekk ||= []
    @trekk << trekk
  end
end

test_nr = 0
begin

  puts "Test nr #{test_nr}"
  spillere=[1,2].map{|spiller| RandomSpiller.new spiller}

  b = Brett.new
  spiller = 1
  ftrekk = [0,0]
  (1..9).each do |trekk|
    s = spillere[spiller-1]
    begin
      ftrekk = s.forslag_trekk
    end while !b.pos_ledig(ftrekk[0],ftrekk[1])
    b.kryss_av spiller, ftrekk[0],ftrekk[1]
    s.foretatt ftrekk
    spiller = spiller == 2 ? 1 : 2
    exit if b.won?
  end
  b.display

  test_nr += 1


end while !b.won?



