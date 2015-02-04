require 'fltk'
require 'thread'

class Alarm

  def alarm
    puts "ALARM!"
    Fltk.alert("Øy, Kent! Hva med en pause snart?")
  end

  def update
    @mutex = Mutex.new
    t = Time.now

    tid = ((t.hour * 60) + t.min )
    puts tid

    @output.value = [t.hour, t.min, t.sec ].join(":")
    if @alarm && tid >= @alarm
      @mutex.synchronize do
	alarm
      end
      @alarm = nil
    end

    Fltk.repeat_timeout( @timeout ){ update }

  end

  def initialize( timeout, first  )
    @alarm = first[0]*60 + first[1]
    puts @alarm

    @mutex = Mutex.new

    @timeout = timeout
    @win = Fltk::Window.new(0,0,100,50,"Alarm")
    @output = Fltk::Output.new(0,0,100,50)
    @win.show


    Fltk.add_timeout( @timeout ){
      update
    }
  end



end

[ [14,38],
  [14,40]
].each{|tid|
  a = Alarm.new( 1.0,tid )
} 



Fltk.run
