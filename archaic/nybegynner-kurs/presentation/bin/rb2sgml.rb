#!/usr/local/bin/ruby
# Rubyスクリプト，Javaソース，C++ソースをHTMLに整形する
# キーワード，コメント，文字列に色を付ける

# Copyright (c) 2001 HORIKAWA Hisashi. All rights reserved.
#   mailto:vzw00011@nifty.ne.jp
#   http://www2.airnet.ne.jp/pak04955/


# Modification based on rb2html.rb trying to implement
# SGML generation for LinuxDOC code sections. 

require File.expand_path('rb2sgml-sub.rb', File.dirname(__FILE__))

class Ruby2Sgml < HtmlFormat
  def initialize()
    super()

    # lex.c wordlist[]
    @keywords = Hash.new
    %w(
      end else case ensure module elsif def rescue not then yield for
      self false retry return true if defined? super undef break in do
      nil until unless or next when redo and begin __LINE__ class __FILE__
      END BEGIN while alias
    ).each {|k| @keywords[k.strip] = 1 }

    @here_end = Array.new
    @spans = Array.new
  end


  def begin_span(ending)
    @spans.push ending
  end
  def end_span
    @spans.pop
  end


  def state1(ch)
    # 地の文
    case ch
    when '"'
      que_out()
      print BEGIN_LITERAL, "&quot;"
      begin_span( END_LITERAL)
      @state = 2
      return
    when '\''
      que_out()
      print BEGIN_LITERAL, "'"
      begin_span( END_LITERAL)
      @state = 3
      return
    when '/'
      if @line[0, 1] != ' '
        que_out()
        print BEGIN_LITERAL, "/"
	begin_span( END_LITERAL)
        @state = 4
        return
      end
    when '#'
      que_out()
      print BEGIN_COMMENT, "#", html_escape(@line), END_COMMENT #"</span>"
      @line = ''
      return
    when '$'
      if @line[0, 1] == '\''
        @que << ch << @line.shift
        return
      end
    when '<'
      if @line[0, 1] == '<' && @line[1, 1] == '\''
        que_out()
        print html_escape("<<'")
        @line = @line[2, @line.length]
        
        tail = ''
        while /[a-zA-Z0-9]/ =~ @line[0, 1]
          tail << @line.shift
        end
        if tail != ''
          @here_end << [0, tail]
          print html_escape(tail)
        end
        print html_escape(@line.shift) # tailの後ろの'
        return
      elsif @line[0, 1] == '<' && @line[1, 1] != ' '
        que_out()
        print html_escape(ch + @line.shift)
        print html_escape(@line.shift) if @line[0, 1] == '"'
        
        tail = ''
        while /[a-zA-Z0-9]/ =~ @line[0, 1]
          tail << @line.shift
        end
        if tail != ''
          @here_end << [1, tail]
          print html_escape(tail)
        end
        print html_escape(@line.shift) if @line[0, 1] == '"'
        return
      end
    when '?'
      # ?/ => 数値リテラル
      if @line != ''
        @que << ch << @line.shift
        return
      end
    when '%'
      # %w(...)
      if @line[0, 1] == 'w' && @line[1, 1] == '('
        que_out()
        print html_escape(ch + @line[0, 2]), BEGIN_LITERAL
        @line = @line[2, @line.length]
        begin_span( END_LITERAL)
        @state = 9
        return
      end
    end
    @que << ch
  end # state1()

  def state2(ch)
    # "..."
    case ch
    when '"'
      print html_escape(@que + ch), end_span #END_SPAN #"</span>"
      @que = ''
      @state = 1
      return
    when '\\'
      if @line != ''
        @que << ch << @line.shift
        return
      end
    end
    @que << ch
  end

  def parse_line(s)
    @line = s

    if @state == 9 # %w(...)
      print BEGIN_LITERAL
      begin_span( END_LITERAL)
    end
    if @state == 1
      if @here_end.size > 0
        if @here_end[0][0] == 0
          # <<'EOF'
          @state = 6
        else
          # <<EOF
          @state = 7
        end
=begin
      elsif @line == '=begin'
        print "</pre>"
        @state = 8
        return
=end
      end
    end

    case @state
    when 6
      # <<'EOF'
      if @line == @here_end[0][1]
        print html_escape(@line)
        @here_end.shift
        @state = 1
      else
        print BEGIN_LITERAL, html_escape(@line), END_LITERAL #"</span>"
      end
      return
    when 7
      # <<EOF
      if @line == @here_end[0][1]
        print html_escape(@line)
        @here_end.shift
        @state = 1
      else
        print BEGIN_LITERAL, html_escape(@line), END_LITERAL #"</span>"
      end
      return
    when 8
      # =begin ... =end
      if @line == "=end"
        start_formatted()
        @state = 1
      else
        print @line
      end
      return
    end
    
    while @line != ''
      ch = @line.shift
      case @state
      when 1
        # 地の文
        state1(ch)
      when 2
        # "..."
        state2(ch)
      when 3
        # '...'
        case ch
        when '\''
          print html_escape(@que + ch), end_span #"</span>"
          @que = ''
          @state = 1
        when '\\'
          if @line[0, 1] == '\\' || @line[0, 1] == '\''
            @que << ch << @line.shift
          else
            @que << ch
          end
        else
          @que << ch
        end
      when 4
        # /.../
        case ch
        when '/'
          print html_escape(@que + ch), end_span #"</span>"
          @que = ''
          @state = 1
        else
          @que << ch
        end
      when 9
        case ch
        when ')'
          print html_escape(@que), end_span #"</span>"
          @que = ')'
          @state = 1
        else
          @que << ch
        end
      else
        print "Internal error.\n"
        exit
      end
    end
    
    if @state == 1
      que_out()
    else
      print html_escape(@que)
      @que = ''
    end
    
    print end_span if @state == 9
  end # parse_line()

  def parse(fp)
    lno = 0
    while line = fp.gets
      line.gsub! /[\r\n]/, ''

      if @state == 1 && line == '=begin'
        print "</pre>\n"
        @state = 8
        next
      elsif @state == 8 && line == '=end'
        start_formatted()
        @state = 1
        next
      end

      if @state != 8
        lno += 1
	s = lno.to_s
	printf "<newline>" + "&ensp;"*(3-s.size) + s + "| "
        #printf "<newline>%3d| ", lno
      end
      parse_line(line)
      print "\n"
    end
  end

end

if __FILE__ == $0
  # main
  Ruby2Sgml.new.main
end
