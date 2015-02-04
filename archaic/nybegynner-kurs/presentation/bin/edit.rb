#!/usr/bin/env ruby

# Various text massaging code


module LineSubstituter
  def LineSubstituter.substitute( infile, outfile )

    File.open( infile, "r" ) do 
      |cin|
      File.open( outfile, "w") do 
	|cout|	
	cin.readlines.each{|line|
	  cout.puts yield line
	}	
      end
    end    
        
  end
end


module UmlautSub
  UMLAUTS = { 
	'æ' => '&aelig;', #'&#230;',
	'Æ' => '&AElig;', #'&#198;',
	'ø' => '&oslash;',
	'Ø' => '&Oslash;',
	'å' => '&aring;',
	'Å' => '&Aring;'
}

  def UmlautSub.sgml( input )
    output = input.dup
    UMLAUTS.each{|umlaut,sgmlentity|
      #puts umlaut, sgmlentity
      output.gsub!(umlaut, sgmlentity )
    }
    output	         
  end
end # UmlautSub


module LaTeX
  def LaTeX.sub( input )
    r = input.dup
    r.gsub! '&', '&amp;'
    r.gsub! '"', '&quot;'
    r.gsub! '<', '&lt;'
    r.gsub! '>', '&gt;'
    r
  end
end # LaTeX


# Commands that one can call from the commandlinex
module Commands
  

  ##
  # Flattens any subsection <sect> tags, so that linuxdoc makes a nice 
  # linked presentation for me.
  #
  class Flatten
    def initialize( argv )
      @infile = argv[0]
      @outfile= argv[1]
      @section = [0]

    end
    def run
      LineSubstituter.substitute( @infile, @outfile ){|line|
	line.gsub(/<sect[0-9]*>/){|m| 
          sectiontype = (m.to_s[5..-1]).to_i
	  
	  if @section.size <= sectiontype
	    @section << 0
	  end

	  @section = @section[0..sectiontype]
	  @section[sectiontype]+=1

	  

	  "<sect> &lt;#{@section.join('.')}&gt;:  "
        }
      }	
    end # run
  end # Flatten
  
  
  ##
  # Run the sample code thru rb2html, but strip away unwanted stuff
  # on both input and output.
  # Input should only be the stuff between lines with <CODE> and </CODE>
  # Output should only be the lines between the <body> and </body> tag
  #
  class Htmlify
    def initialize( argv )
      @argv = argv
    end
    def run
      @argv.each do |f|
	File.open(f,"r") do |infile| 
	File.open(f+".html","w") do |out|	
	    puts f
	    @current = f
	    IO.popen("ruby bin/rb2html.rb","w+") do |html|
	      feed( html, infile )
	      html.close_write
	      consume( html, out )
	    end
	  end
	end
      end    
    end
  
    
    def feed( html, infile )
      ignore = true
      infile.readlines.each{|line|
	if line.index "</CODE>" then ignore = true end
	if !ignore then html << line end
	if line.index "<CODE>" then ignore = false end
      }
    end
    
    def consume( html, out )
      ignore = true
      html.readlines.each{|line|
	line.gsub!("stdin"){|match|
	  if line.index("<div") || 
	      line.index("</div>") then
	    '<A HREF="'+@current+'">' + @current + '</A>'
	  else
	    match.to_s
	  end
	}
	if line.index "</body>" then ignore = true end	
	if !ignore then out << line end
	if line.index "<body>"  then ignore = false end
      }
    end
  end  # Htmlize



  ##
  # Substitute href's to SOURCE_CODE with the htmlized code of
  # the pointed to resource.
  class InsertSampleCode
    def initialize( argv )
      @argv = argv
    end

    def run
      @argv.each do |f|
	infile = f
	outfile = "html/" + f.split("/")[-1]

	re = /\<a href\="(.*)">SOURCE_CODE<\/a>/i  #/ " 

	LineSubstituter.substitute( infile, outfile ){|line|
	  line.gsub( re ){|match|
	    m = match.to_s
	    file = Regexp.last_match[1] #(/".*\.*"/.match m).to_s[1...-1]

	    puts file

	    a = file.split("/")[-1]
	    File.open("tmp/"+a+".html_section","r").readlines.join
	  }
	}	

      end
    end    
   
  end


  class InsertSGMLSampleCode
    def initialize( argv )
      @infile  = argv[0]
      @outfile = argv[1]
      @argv = argv
    end

    def run

	infile = @infile
	outfile = @outfile #"html/" + f.split("/")[-1]

	re = /\<htmlurl url\="(.*)" name\=\"SOURCE_CODE\">/i  #/ " 
	#re = /\<a href\=".*\">SOURCE_CODE<\/a>/i  #/ " 

	LineSubstituter.substitute( infile, outfile ){|line|
	  line.gsub( re ){|match|
	    m = match.to_s
	    file = Regexp.last_match[1] #(/\".*\.r.*\"/.match m).to_s[1...-1]

	    puts file

	    a = file.split("/")[-1]
	    File.open("tmp/"+a+".sgml_section","r").readlines.join
	  }
	}	


    end    
   
  end





  ##
  # Take SGML, substitue in SampleCode as verbatim sections
  class InsertSampleCodeStandalone
    def initialize( argv )
      @infile  = argv[0]
      @outfile = argv[1]
      puts argv.join(", ")
    end    
    def run

      re = /\<htmlurl\s+url\="(.*)"\s+name\=\"SOURCE_CODE\">/i  #/ "

      url_re = /\<url\s+url\="([^"]*)"\s+name\="([^"]*)">/i
      
      LineSubstituter.substitute( @infile, @outfile ){|line|
	line.gsub( re ){|match|
	  m = match.to_s
	  puts "Inserting #{m}"
	  file = Regexp.last_match[1] # (/\".*\.r.*\"/.match m).to_s[1...-1]
	  
	  result = "<code>"
	  result += "[ "+file+" ]\n"
	  count = 0
	  File.open("html/"+file,"r") do |file|
            file.readlines.each{|line|
	    count+=1
	    prefix = (count<=9) ? " " : ""
	    line = LaTeX.sub( line )
            line = UmlautSub.sgml( line )

	    result += "#{prefix}#{count}| #{line}"
	  }
          end
	  result + "</code>"
	}.gsub( url_re ){|match|
          url, name = Regexp.last_match[1..2]
          "<url url=\"<" + url + ">\" name=\"" + name + "\">"
          "<it>"+ name + "</it><footnote>"+url+"</footnote>"
        }
      }

    end

  end

  
  ##
  #
  class StripStuff

    def initialize( argv )
      @infile  = argv[0]
      @outfile = argv[1]
    end

    def feed( out, infile )
      raise "Subclass me! Subclass me! You take the full responcibility!"
    end

    def run
      File.open( @infile , "r"  ) do |infile| 
	File.open( @outfile , "w" ) do |out|	
	  puts @outfile	  
	  feed( out, infile )
	end
      end
    end # run
  end # StripStuff


  ##
  # turns on/off ignoring based on occurances of certain strings values
  # Ignore on line basis
  class StripToggle < StripStuff
    def initialize( argv, turnon, turnoff )
      super argv
      @turnon  = turnon
      @turnoff = turnoff
    end

    def feed( out, infile )
      ignore = true
      infile.readlines.each{|line|
	if line.index @turnoff then ignore = true end
	if !ignore then out << line end
	if line.index @turnon then ignore = false end
      }
    end

  end


  class StripRbCode < StripToggle
    def initialize( argv )
      super argv, "<CODE>", "</CODE>"
    end
  end # StripRbCode
  

  class StripToHtmlSection < StripToggle
    def initialize( argv )
      super argv, "<body>", "</body>"
      @filename = argv[2]
    end
    def feed( out, html )
      ignore = true
      html.readlines.each{|line|
	line.gsub!("stdin"){|match|
	  if line.index("<div") || 
	      line.index("</div>") then
	    '<A HREF="'+@filename+'">' + @filename + '</A>'
	  else
	    match.to_s
	  end
	}
	if line.index "</body>" then ignore = true end	
	if !ignore then out << UmlautSub.sgml(line) end
	if line.index "<body>"  then ignore = false end
      }
    end

  end # StripToHtmlSection



  class Umlaut
    def initialize( argv )
      @infile = argv[0]
      @outfile= argv[1]

    end
    def run
      LineSubstituter.substitute( @infile, @outfile ){|line|
	UmlautSub.sgml( line )
      }	
    end # run
  end # Flatten




end # Commands


class Edit
  def initialize( argv )
    @argv = argv
    
    command = @argv[0][1..-1]
    klass = Commands.const_get( command )
    @action = klass.new( argv[1..-1] )
  end


  def run
    @action.run
  end

end


if $0 == __FILE__
  e = Edit.new( ARGV )
  e.run
end

