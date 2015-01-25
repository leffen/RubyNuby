#!/usr/bin/ruby 
class Gjett  # Et lite spill 
  def initialize
    @max = 100
    @min = 1
    @forsoek = 0
    @ferdig = false
    @fasit_svar = ((@max-@min)*rand).to_i + @min
  end
  def spill
    puts "\nGjettekonkurranse!"
    while @forsoek < 10 and not @ferdig
      gjett( hent_svar )
    end
  end
  def gjett( svar )
    diff = (svar - @fasit_svar).abs
    if diff > 25
      print "Mye "
    elsif diff > 15  
      print "Endel "
    elsif diff > 0 
      print "Litt "
    end
    if svar > @fasit_svar
      puts "lavere. "
    elsif svar < @fasit_svar
      puts "høyere. "
    end
    if diff == 0
      @ferdig = true
      puts "Du klarte det på #@forsoek forsøk!"
    end
  end
  def hent_svar
    begin
      print "Gjett ett tall mellom #@min og #@max >:"
      svar = gets.to_i
    end until svar >= @min and svar <= @max
    @forsoek += 1
    svar
  end
end 

# La oss unngå å bruke de kryptiske globale variabelnavnene.
require 'English'
if __FILE__ == $PROGRAM_NAME then
  begin
    g = Gjett.new
    g.spill
    print "Spille en gang til? [j/n]: "
    svar = gets.downcase
  end while svar[0] == ?j
end
