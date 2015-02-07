
# Copyright (c) 2001 HORIKAWA Hisashi. All rights reserved.
#   mailto:vzw00011@nifty.ne.jp
#   http://www2.airnet.ne.jp/pak04955/

# Modification based on rb2html-sub.rb to implement
# HTML subsections with some differences to better suit the
# presentation material 

BEGIN_LITERAL = '<span style="color:#660066">'
BEGIN_COMMENT = '<span style="color:green">'
BEGIN_KEYWORD = '<span style="color:blue">'

END_SPAN = '</span>'

END_LITERAL = END_COMMENT = END_KEYWORD = END_SPAN #'</span>'



def html_escape(s)
  # エスケープする
  if s
    r = s.dup
    r.gsub! '&', '&amp;'
    r.gsub! '"', '&quot;'
    r.gsub! '<', '&lt;'
    r.gsub! '>', '&gt;'
    r
  else
    nil
  end
end

class String
  def shift
    r = self[0, 1]
    self[0, 1] = ''
    return r
  end
end

class HtmlFormat
  def initialize()
    @que = ''
    @line = ''
    @state = 1
    @filename = ''
  end
  
  def que_out()
    # 地の文の出力, キーワードの色付け
    while @que =~ /[a-zA-Z_][a-zA-Z0-9_]*[?!]?/
      @que = $'
      if @keywords[$&] && $`[-1] != ?.
        print html_escape($`), BEGIN_KEYWORD, $&, END_KEYWORD #"</span>"
      else
        print html_escape($`), $&
      end
    end
    print html_escape(@que)
    @que = ''
  end

  def parse(fp)
    lno = 0
    while line = fp.gets
      lno += 1
      printf "%3d| ", lno
      line.gsub! /[\r\n]/, ''
      parse_line(line)
      print "\n"
    end
  end # def
  
  def start_formatted
    print <<EOF
<table >
      <tr style="background-color:#F0D0D0" ><td>
<div style="margin-top:1em;font-family:sans-serif">#{@filename}</div>
<tr style="background-color:#FFF0F0"><td>
<pre style="margin-top:0">
EOF
  end

  def main
    if ARGV[0]
      @filename = ARGV[0]
      fp = File.open(ARGV[0])
    else
      @filename = "stdin"
      fp = $stdin
    end

    print <<EOF
<html>
<head>
  <title>#{@filename}</title>
</head>
<body>
EOF
    start_formatted()
    parse(fp)
    fp.close
    print <<EOF
</pre>
</td></table>
</body>
</html>
EOF
  end # main()
end
