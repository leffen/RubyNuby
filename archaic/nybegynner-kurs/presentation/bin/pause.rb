require 'fltk'
require 'thread'

class Klokke

  def initialize
    @timeout = 5
    t = Time.now
    @gammel = t.min
    @alarmer = []

    @win = Fltk::Window.new(0,0,50,16,"Klokke")
    @output = Fltk::Output.new(0,0,50,16)
    sett_tid( t )
    @win.show


    Fltk.add_timeout( @timeout ){ update }

  end

  def sett_tid(t)
    @output.value = [t.hour,t.min].join(":")
    @gammel = t.min
  end

  def update
    t = Time.now
    ny = t.min
    if @gammel and ny != @gammel
       @alarmer.each{|alarm|
          alarm.sjekk( t )
       }
    end

    sett_tid(t)

    Fltk.add_timeout( @timeout ){
      update 
    }

  end

  def add( a )
    @alarmer << a
  end

end


class Beskjed
  def initialize( naar, hva )
    @naar = naar
    @hva  = hva
  end

  def sjekk( tid )
    if tid.min == @naar
#      @win = Fltk::Window.new(0,0,200,32,"Beskjed")
#      @output = Fltk::Output.new(0,0,200,32 )
#      @output.value = @hva
#      @win.show
      Fltk.alert( @hva )

    end
  end
end


klokke = Klokke.new
klokke.add Beskjed.new(0,"Tid for pause, kanskje?")
klokke.add Beskjed.new(15,"Også starter vi, hva?")
klokke.add Beskjed.new(Time.now.min+1,"Jeg vil ha oppmerksomhet!!!")

Fltk.run
